import CredentialsProvider from '../common/auth/CredentialsProvider';
import { ServiceClient } from '../common/comm/SeviceClient';
import OSSConstants from './OSSConstants';
import uri from '@ohos.uri';
import { SignVersion } from '../common/comm/SignVersion';
import RequestMessage from '../common/comm/RequestMessage';
import { ExecutionContext } from '../common/comm/ExecutionContext';
import ResponseMessage from '../common/comm/ResponseMessage';
import ServiceException from '../common/exceptions/ServiceException';
import Credentials from '../common/auth/Credentials';
import { RequestSigner } from '../common/auth/RequestSigner';
import ClientConfiguration from '../ClientConfiguration';
import OSSSignerParams from './signer/OSSSignerParams';
import { WebServiceRequest } from './model/WebServiceRequest';
import { OSSUtils } from './OSSUtils';
import OSSException from '../common/exceptions/OSSException';
import ResponseParser from '../common/parser/ResponseParser';
import OSSSignerBase from './signer/OSSSignerBase';
import { http } from '@kit.NetworkKit';

export default abstract class OSSOperation {
  protected product: string;
  protected region: string;
  protected endpoint: uri.URI | null;
  protected credsProvider: CredentialsProvider;
  protected client: ServiceClient;
  protected cloudBoxId: string;
  protected signVersion: SignVersion | null;
  protected static errorResponseHandler = new OSSErrorResponseHandler();
  protected static emptyResponseParser = new EmptyResponseParser();
  protected static requestIdResponseParser = new RequestIdResponseParser();
  protected static noRetryStrategy = new NoRetryStrategy();

  protected constructor(client: ServiceClient, credsProvider: CredentialsProvider) {
    this.client = client;
    this.credsProvider = credsProvider;
    this.product = OSSConstants.PRODUCT_DEFAULT;
    this.signVersion = null;
    this.endpoint = null;
  }

  getProduct(): string {
    return this.product;
  }

  setProduct(product: string): void {
    this.product = product;
  }

  getRegion(): string {
    return this.region;
  }

  setRegion(region: string): void {
    this.region = region;
  }

  getEndpoint(request?: WebServiceRequest): uri.URI | null {
    const reqEndpoint = request?.getEndpoint();
    if (!reqEndpoint) {
      return this.getEndpoint();
    }
    const defaultProto = this.client.getClientConfiguration().getProtocol().toString();
    const ret = OSSUtils.toEndpointURI(reqEndpoint, defaultProto);
    OSSUtils.ensureEndpointValid(ret.host);
    return ret;
  }

  setEndpoint(endpoint: uri.URI): void {
    this.endpoint = new uri.URI(endpoint.toString());
  }

  getCloudBoxId(): string {
    return this.cloudBoxId;
  }

  setCloudBoxId(cloudBoxId: string): void {
    this.cloudBoxId = cloudBoxId;
  }

  getSignVersion(): SignVersion | null {
    return this.signVersion;
  }

  setSignVersion(signVersion: SignVersion): void {
    this.signVersion = signVersion;
  }

  protected getInnerClient(): ServiceClient {
    return this.client;
  }

  protected async send(request: RequestMessage, context: ExecutionContext,
    keepResponseOpen = false): Promise<ResponseMessage> {
    let response: ResponseMessage | null = null;
    try {
      response = await this.client.sendRequest(request, context);
      return response;
    } catch (e) {
      // if (e instanceof ServiceException) {
      //   throw e as OSSException;
      // }
      throw new Error(e);
    } finally {
      if (response && !keepResponseOpen) {
        this.safeCloseResponse(response);
      }
    }
  }

  protected async doOperation<T>(request: RequestMessage, parser: ResponseParser<T>, bucketName: string, key: string,
    keepResponseOpen = false, requestHandlers: RequestHandler[] = [],
    responseHandlers: ResponseHandler[] = []): Promise<T> {
    let span: Span | null = null;
    if (this.client.getClientConfiguration().isTracerEnabled()) {
      const tracer = AlibabaCloudTracerProvider.getInstance().getTracer();
      const attributes = new AlibabaCloudAttributesBuilder()
        .put("alibaba.cloud.service", this.getProduct())
        .put("alibaba.cloud.signature_version", this.client.getClientConfiguration().getSignatureVersion().toString())
        .put("alibaba.cloud.resource.type", "OSS")
        .put("http.request.method", request.getMethod().name())
        .build();

      const spanBuilder = tracer.spanBuilder(bucketName);
      if (spanBuilder) {
        span = spanBuilder.setAllAttributes(attributes).startSpan();
      }
    }

    const originalRequest = request.getOriginalRequest();
    request.getHeaders().setAll(this.client.getClientConfiguration().getDefaultHeaders());
    request.getHeaders().setAll(originalRequest.getHeaders());
    request.getParameters().setAll(originalRequest.getParameters());

    const context = this.createDefaultContext(request.getMethod(), bucketName, key, originalRequest);

    context.addRequestHandler(new RequestProgressHandler());
    requestHandlers.forEach(handler => context.addRequestHandler(handler));
    if (this.client.getClientConfiguration().isCrcCheckEnabled()) {
      context.addRequestHandler(new RequestChecksumHandler());
    }

    context.addResponseHandler(new ResponseProgressHandler(originalRequest));
    responseHandlers.forEach(handler => context.addResponseHandler(handler));
    if (this.client.getClientConfiguration().isCrcCheckEnabled()) {
      context.addResponseHandler(new ResponseChecksumHandler());
    }

    const signerHandlers = this.client.getClientConfiguration().getSignerHandlers();
    signerHandlers?.forEach(signer => context.addSignerHandler(signer));

    let response: ResponseMessage | null = null;
    try {
      response = await this.send(request, context, keepResponseOpen);
      return parser.parse(response);
    } catch (rpe) {
      const oe = ExceptionFactory.createInvalidResponseException(response?.getRequestId() || '', rpe.message, rpe);
      this.logException("Unable to parse response error: ", rpe);
      span?.setAttribute("alibaba.cloud.error.code", "ParseResponseError");
      throw oe;
    } catch(e) {
      if (e instanceof OSSException) {
        span?.setAttribute("alibaba.cloud.error.code", e.getErrorCode());
        span?.setAttribute("alibaba.cloud.request_id", e.getRequestId());
      } else if (e instanceof ClientException) {
        span?.setAttribute("alibaba.cloud.error.code", e.getErrorCode());
      }
      throw e;
    }

    finally
    {
      if (span) {
        if (response) {
          span.setAttribute("alibaba.cloud.request_id", response.getRequestId());
          span.setAttribute("http.response.status_code", String(response.getStatusCode()));
        }
        span.end();
      }
    }
  }

  private createSigner(bucketName: string, key: string, creds: Credentials,
    config: ClientConfiguration): RequestSigner {
    const resourcePath = `/${bucketName ? bucketName + '/' : ''}${key || ''}`;

    const params = new OSSSignerParams(resourcePath, creds);
    params.setProduct(this.product);
    params.setRegion(this.region);
    params.setCloudBoxId(this.cloudBoxId);
    params.setTickOffset(config.getTickOffset());
    return OSSSignerBase.createRequestSigner(this.signVersion || config.getSignatureVersion(), params);
  }

  protected createDefaultContext(method: http.RequestMethod, bucketName: string, key: string,
    originalRequest?: WebServiceRequest): ExecutionContext {
    const context = new ExecutionContext();
    const credentials = this.credsProvider.getCredentials();
    this.assertParameterNotNull(credentials, "credentials");
    context.setCharset(DEFAULT_CHARSET_NAME);
    context.setSigner(this.createSigner(bucketName, key, credentials, this.client.getClientConfiguration()));
    context.addResponseHandler(OSSOperation.errorResponseHandler);
    if (method === http.RequestMethod.POST && !this.isRetryablePostRequest(originalRequest)) {
      context.setRetryStrategy(OSSOperation.noRetryStrategy);
    }

    const retryStrategy = this.client.getClientConfiguration().getRetryStrategy();
    if (retryStrategy) {
      context.setRetryStrategy(retryStrategy);
    }

    context.setCredentials(credentials);
    return context;
  }

  protected isRetryablePostRequest(request: WebServiceRequest): boolean {
    return false;
  }

  private safeCloseResponse(response: ResponseMessage): void {
    // Implement safe closing logic for the response
  }

  private logException(message: string, error: Error): void {
    console.error(message, error);
  }

  private assertParameterNotNull(param: ESObject, paramName: string): void {
    if (param == null) {
      throw new Error(`${paramName} should not be null.`);
    }
  }
}
