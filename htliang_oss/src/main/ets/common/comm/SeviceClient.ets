import IOException from '@htliang/java_type/src/main/ets/java/io/IOException';
import ClientConfiguration from '../../ClientConfiguration';
import ClientException from '../../ClientException';
import OSSConstants from '../../internal/OSSConstants';
import CommonConstant from '../CommonConstant';
import ServiceException from '../exceptions/ServiceException';
import BinaryUtil from '../utils/BinaryUtil';
import CodingUtils from '../utils/CodingUtils';
import HttpUtil from '../utils/HttpUtil';
import LogUtils from '../utils/LogUtils';
import { ExecutionContext } from './ExecutionContext';
import HttpMessage from './HttpMessage';
import RequestMessage from './RequestMessage';
import ResponseMessage from './ResponseMessage';
import RetryStrategy from './RetryStrategy';
import ByteArrayInputStream from '@htliang/java_type/src/main/ets/java/io/ByteArrayInputStream'
import RuntimeException from '@htliang/java_type/src/main/ets/java/lang/RuntimeException';
import ResponseHandler from './ResponseHandler';
import RequestHandler from './RequestHandler';
import HttpHeaders from '../utils/HttpHeaders';
import { http } from '@kit.NetworkKit';
import { LinkedList } from '@kit.ArkTS';

function sleepCallback(delay: number, callback: () => void) {
  setTimeout(callback, delay);
}

export abstract class ServiceClient {
  private clientConfiguration: ClientConfiguration;

  public getClientConfiguration(): ClientConfiguration {
    return this.clientConfiguration;
  }

  constructor(clientConfiguration: ClientConfiguration) {
    this.clientConfiguration = clientConfiguration;
  }

  public async sendRequest(request: RequestMessage, context: ExecutionContext): Promise<ResponseMessage> {
    CodingUtils.assertParameterNotNull(request, "request");
    CodingUtils.assertParameterNotNull(context, "context");

    try {
      return await this.sendRequestImpl(request, context);
    } finally {
      // Close the request stream as well after the request is completed.
      try {
        request.close();
      } catch (err) {
        console.error(err)
        throw new ClientException("Unexpected io exception when trying to close http request: " + err)
      }
    }
  }

  public async sendRequestImpl(request: RequestMessage, context: ExecutionContext): Promise<ResponseMessage> {
    let retryStrategy: RetryStrategy = context.getRetryStrategy() ?? this.getDefaultRetryStrategy();
    // Sign the request if a signer provided.
    if (context.getSigner() && !request.getUseUrlSignature()) {
      context.getSigner()?.sign(request);
    }

    let signers = context.getSignerHandlers();
    signers.forEach(signer => {
      signer.sign(request);
    })

    let requestContent = request.getContent();
    if (requestContent && requestContent.markSupported()) {
      requestContent.mark(OSSConstants.DEFAULT_STREAM_BUFFER_SIZE);
    }

    let retries = 0;
    let response: ResponseMessage | undefined = undefined;

    while (true) {
      try {
        if (retries > 0) {
          await this.pause(retries, retryStrategy);
          if (requestContent && requestContent.markSupported()) {
            try {
              requestContent.reset();
              request.setContent(requestContent);
            } catch (e) {
              if (e instanceof IOException) {
                LogUtils.logException("Failed to reset the request input stream: ", e as Error);
                throw new ClientException("Failed to reset the request input stream: ", e as Error);
              }
              throw new Error(e);
            }
          }
        }

        /*
        * The key four steps to send HTTP requests and receive HTTP
        * responses.
        */

        // Step 1. Preprocess HTTP request.
        this.handleRequest(request, context.getRequestHandlers());

        // Step 2. Build HTTP request with specified request parameters
        // and context.
        let httpRequest = this.buildRequest(request, context);

        // Step 3. Send HTTP request to OSS.
        let poolStatsInfo = this.clientConfiguration.isLogConnectionPoolStatsEnable() ?
          "Connection pool stats " + this.getConnectionPoolStats() : "";
        let startTime = Date.now();
        response = await this.sendRequestCore(httpRequest, context);
        let duration = Date.now() - startTime;
        if (duration > this.clientConfiguration.getSlowRequestsThreshold()) {
          LogUtils.warn(this.formatSlowRequestLog(request, response, duration) + poolStatsInfo);
        }

        // Step 4. Preprocess HTTP response.
        this.handleResponse(response, context.getResponseHandlers());

        return response;
      } catch (e) {
        if (!response) {
          throw new ClientException("Connection error due to: " + (e as Error).message, e);
        }
        if (e instanceof ServiceException) {
          LogUtils.logException("[Server]Unable to execute HTTP request: ", e as Error,
            request ? request.getOriginalRequest()?.isLogEnabled() : true);

          // Notice that the response should not be closed in the
          // finally block because if the request is successful,
          // the response should be returned to the callers.
          this.closeResponseSilently(response);

          if (!this.shouldRetry(e as Error, request, response, retries, retryStrategy)) {
            throw e;
          }
        } else if (e instanceof ClientException) {
          LogUtils.logException("[Client]Unable to execute HTTP request: ", e as Error,
            request ? request.getOriginalRequest()?.isLogEnabled() : true);

          this.closeResponseSilently(response);

          if (!this.shouldRetry(e as Error, request, response, retries, retryStrategy)) {
            throw e;
          }
        }

        LogUtils.logException("[UNKNOWN]Unable to execute HTTP request: ", e as Error,
          request ? request.getOriginalRequest()?.isLogEnabled() : true);

        this.closeResponseSilently(response);

        throw new ClientException("Connection error due to: " + (e as Error).message, e);
      } finally {
        retries++;
      }
    }
  }

  protected abstract sendRequestCore(request: Request, context: ExecutionContext): Promise<ResponseMessage>;

  private buildRequest(requestMessage: RequestMessage, context: ExecutionContext): Request {
    let request = new Request();
    request.setMethod(requestMessage.getMethod());
    request.setUseChunkEncoding(requestMessage.getUseChunkEncoding());

    if (requestMessage.getUseUrlSignature()) {
      request.setUrl(requestMessage.getAbsoluteUrl());
      request.setUseUrlSignature(true);

      request.setContent(requestMessage.getContent());
      request.setContentLength(requestMessage.getContentLength());
      request.setHeaders(requestMessage.getHeaders());

      return request;
    }

    request.setHeaders(requestMessage.getHeaders());
    request.setSendProgressCallBack(requestMessage.getOriginalRequest()?.getSendProgressCallBack());
    request.setReceiveProgressCallBack(requestMessage.getOriginalRequest()?.getReceiveProgressCallback());

    // The header must be converted after the request is signed,
    // otherwise the signature will be incorrect.
    if (!request.getHeaders().isEmpty()) {
      HttpUtil.convertHeaderCharsetToIso88591(request.getHeaders());
    }

    const delimiter = "/";
    let endpoint = requestMessage.getEndpoint();
    let uri = endpoint ? endpoint.toString() : CommonConstant.BLANK;
    let resourcePath = requestMessage.getResourcePath() ?? CommonConstant.BLANK;
    if (!uri.endsWith(delimiter) && (resourcePath.length === 0 || !resourcePath.startsWith(delimiter))) {
      uri += delimiter;
    }

    if (resourcePath.length > 0) {
      uri += resourcePath;
    }

    let paramString = HttpUtil.paramToQueryString(requestMessage.getParameters(), context.getCharset());

    /*
     * For all non-POST requests, and any POST requests that already have a
     * payload, we put the encoded params directly in the URI, otherwise,
     * we'll put them in the POST request's payload.
     */
    let requestHasNoPayload: boolean = requestMessage.getContent() !== undefined;
    let requestIsPost: boolean = requestMessage.getMethod() === http.RequestMethod.POST;
    let putParamsInUri: boolean = !requestIsPost || requestHasNoPayload;
    if (paramString.length > 0 && putParamsInUri) {
      uri += "?" + paramString;
    }

    request.setUrl(uri);

    if (requestIsPost && !requestMessage.getContent() && paramString !== null) {
      // Put the param string to the request body if POSTing and
      // no content.
      try {
        let buf: Uint8Array = new Uint8Array(BinaryUtil.encodeToBuffer(paramString, context.getCharset()).buffer);
        let content = new ByteArrayInputStream(buf);
        request.setContent(content);
        request.setContentLength(buf.length);
      } catch (e) {
        throw new RuntimeException(
          `Encoding failed due to: ${(e as Error).message}`);
      }
    } else {
      request.setContent(requestMessage.getContent());
      request.setContentLength(requestMessage.getContentLength());
    }

    return request;
  }

  private handleResponse(response: ResponseMessage, responseHandlers: LinkedList<ResponseHandler>): void {
    responseHandlers.forEach((h) => {
      h.handle(response);
    });
  }

  private handleRequest(message: RequestMessage, requestHandlers: LinkedList<RequestHandler>): void {
    requestHandlers.forEach((h) => {
      h.handle(message);
    });
  }

  private async pause(retries: number, retryStrategy: RetryStrategy): Promise<void> {
    let delay = retryStrategy.getPauseDelay(retries);

    LogUtils.debug(
      "An retriable error request will be retried after " + delay + "(ms) with attempt times: " + retries);

    try {
      await sleepCallback(delay, () => {
      })
    } catch (e) {
      throw new ClientException(e.getMessage(), e);
    }
  }

  private shouldRetry(exception: Error, request: RequestMessage, response: ResponseMessage, retries: number,
    retryStrategy: RetryStrategy): boolean {

    if (retries >= this.clientConfiguration.getMaxErrorRetry()) {
      return false;
    }

    if (!request.isRepeatable()) {
      return false;
    }

    if (retryStrategy.shouldRetry(exception, request, response, retries)) {
      LogUtils.debug("Retrying on " + exception.name + ": " + exception.message);
      return true;
    }
    return false;
  }

  private closeResponseSilently(response: ResponseMessage): void {
    if (response !== null) {
      try {
        response.close();
      } catch (e) {
        /* silently close the response. */
      }
    }
  }

  private formatSlowRequestLog(request: RequestMessage, response: ResponseMessage, useTimesMs: number): string {
    return `Request cost ${useTimesMs /
      1000} seconds, endpoint ${request.getEndpoint()}, resourcePath ${request.getResourcePath()}, " + "method ${request.getMethod()}, Date '${request.getHeaders()
      .get(HttpHeaders.DATE)}', statusCode ${response.getStatusCode()}, requestId ${response.getRequestId()}.`;
  }

  protected abstract getDefaultRetryStrategy(): RetryStrategy;

  public abstract shutdown(): void;

  public getConnectionPoolStats(): string {
    return CommonConstant.BLANK;
  };
}

export class Request extends HttpMessage {
  private sendProgressCallBack?: Callback<http.DataSendProgressInfo>;
  private receiveProgressCallback?: Callback<http.DataReceiveProgressInfo>;
  private uri: string = '';
  private method: http.RequestMethod = http.RequestMethod.POST;
  private useUrlSignature: boolean = false;
  private useChunkEncoding: boolean = false;

  public getSendProgressCallBack(): Callback<http.DataSendProgressInfo> | undefined {
    return this.sendProgressCallBack;
  }

  public setSendProgressCallBack(sendProgressCallback: Callback<http.DataSendProgressInfo> | undefined): void {
    this.sendProgressCallBack = sendProgressCallback;
  }

  public getReceiveProgressCallback(): Callback<http.DataReceiveProgressInfo> | undefined {
    return this.receiveProgressCallback;
  }

  public setReceiveProgressCallBack(receiveProgressCallback: Callback<http.DataReceiveProgressInfo> | undefined): void {
    this.receiveProgressCallback = receiveProgressCallback;
  }

  public getUri(): string {
    return this.uri;
  }

  public setUrl(uri: string | undefined): void {
    this.uri = uri ?? CommonConstant.BLANK;
  }

  public getMethod(): http.RequestMethod {
    return this.method;
  }

  public setMethod(method: http.RequestMethod): void {
    this.method = method;
  }

  public isUseUrlSignature(): boolean {
    return this.useUrlSignature;
  }

  public setUseUrlSignature(useUrlSignature: boolean): void {
    this.useUrlSignature = useUrlSignature;
  }

  public isUseChunkEncoding(): boolean {
    return this.useChunkEncoding;
  }

  public setUseChunkEncoding(useChunkEncoding: boolean): void {
    this.useChunkEncoding = useChunkEncoding;
  }
}