import ClientConfiguration from "../../ClientConfiguration";
import { ExecutionContext } from "./ExecutionContext";
import HttpRequestFactory from "./HttpRequestFactory";
import { RequestConfig } from "./RequestConfig";
import ResponseMessage from "./ResponseMessage";
import RetryStrategy from "./RetryStrategy";
import { Request, ServiceClient } from "./SeviceClient";
import { http } from "@kit.NetworkKit";
import ClientException from "../../ClientException";
import ByteArrayInputStream from "@htliang/java_type/src/main/ets/java/io/ByteArrayInputStream";
import HttpHeaders from "../utils/HttpHeaders";
import { buffer } from "@kit.ArkTS";
import RequestMessage from "./RequestMessage";
import ExceptionFactory from "../utils/ExceptionFactory";
import ClientErrorCode from "../../ClientErrorCode";
import HttpErr from "../../internal/model/HttpErr";

export default class DefaultServiceClient extends ServiceClient {
  protected static httpRequestFactory: HttpRequestFactory = new HttpRequestFactory();
  protected requestConfig: RequestConfig;

  constructor(config: ClientConfiguration) {
    super(config);
    this.requestConfig = new RequestConfig();
    this.requestConfig.setConnectTimeout(config.getConnectionTimeout());
    this.requestConfig.setReadTimeout(config.getSocketTimeout());
    this.requestConfig.setUserAgent(config.getUserAgent());
    let proxyHost = this.getClientConfiguration().getProxyHost();
    let proxyPort = this.getClientConfiguration().getProxyPort();
    if (proxyHost && proxyPort > 0) {
      this.requestConfig.setUsingProxy({
        host: proxyHost,
        port: proxyPort,
        username: this.getClientConfiguration().getProxyUsername(),
        password: this.getClientConfiguration().getProxyPassword(),
        exclusionList: []
      });
    }
  }

  protected async sendRequestCore(request: Request, context: ExecutionContext): Promise<ResponseMessage> {
    let httpRequestOptionsBuilder =
      DefaultServiceClient.httpRequestFactory.createHttpRequestOptionsBuilder(request, context);
    httpRequestOptionsBuilder.setConnectTimeout(this.requestConfig.getConnectTimeout());
    httpRequestOptionsBuilder.setReadTimeout(this.requestConfig.getReadTimeout());
    httpRequestOptionsBuilder.setUsingProxy(this.requestConfig.getUsingProxy());
    httpRequestOptionsBuilder.getHeader()?.set('User-Agent', this.requestConfig.getUserAgent());
    let uri = request.getUri();

    let httpRequest: http.HttpRequest = http.createHttp();
    let httpResponse: http.HttpResponse;
    let httpRequestOption = httpRequestOptionsBuilder.build();
    try {
      httpResponse = await httpRequest.request(uri, httpRequestOption);
    } catch (e) {
      throw ExceptionFactory.createNetworkException(e as HttpErr);
    } finally {
      httpRequest.destroy();
    }

    return this.buildResponse(request, httpResponse);
  }

  private buildResponse(request: Request,
    httpResponse: http.HttpResponse): ResponseMessage | PromiseLike<ResponseMessage> {
    let response = new ResponseMessage(request);
    response.setUrl(request.getUri());
    response.setHttpResponse(httpResponse);
    response.setStatusCode(httpResponse.responseCode);

    let responseBuf = httpResponse.result as ArrayBuffer;
    if (response.isSuccessful()) {
      response.setContent(new ByteArrayInputStream(responseBuf));
    } else {
      this.readAndSetErrorResponse(responseBuf, response);
    }

    let headerMap = new Map<string, string>(Object.entries(httpResponse.header));
    headerMap.forEach((value, key) => {
      if (HttpHeaders.CONTENT_LENGTH === key.toUpperCase()) {
        response.setContentLength(Number.parseInt(value));
      }
      response.addHeader(key, value);
    });

    return response;
  }

  private readAndSetErrorResponse(responseBuf: ArrayBuffer, response: ResponseMessage) {
    response.setErrorResponseAsString(buffer.from(responseBuf).toString());
    response.setContent(new ByteArrayInputStream(responseBuf));
  }

  protected getDefaultRetryStrategy(): RetryStrategy {
    return new DefaultRetryStrategy();
  }

  public shutdown(): void {
  }
}

class DefaultRetryStrategy extends RetryStrategy {
  shouldRetry(ex: Error, request: RequestMessage, response: ResponseMessage, retries: number): boolean {
    if (ex instanceof ClientException) {
      let errorCode = ex.errorCode;
      if (errorCode === ClientErrorCode.OPERATION_TIMEOUT ||
        errorCode === ClientErrorCode.FAILED_TO_CONNECT_TO_THE_SERVER ||
        errorCode === ClientErrorCode.INVALID_SERVER_RESPONSE) {
        return true;
      }
    }

    let statusCode = response.getStatusCode();
    if (statusCode === 500 || statusCode == 502 || statusCode == 503) {
      return true;
    }

    return false;
  }
}