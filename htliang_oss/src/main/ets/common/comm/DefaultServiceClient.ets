import ClientConfiguration from "../../ClientConfiguration";
import CustomHttpRequest from "./CustomHttpRequest";
import { ExecutionContext } from "./ExecutionContext";
import HttpRequestFactory from "./HttpRequestFactory";
import ResponseMessage from "./ResponseMessage";
import RetryStrategy from "./RetryStrategy";
import { Request, ServiceClient } from "./SeviceClient";

export default class DefaultServiceClient extends ServiceClient {
  protected static httpRequestFactory: HttpRequestFactory = new HttpRequestFactory();

  constructor(config: ClientConfiguration) {
    super(config);


  }

  protected sendRequestCore(request: Request, context: ExecutionContext): ResponseMessage {
    let httpRequest = DefaultServiceClient.httpRequestFactory.createHttpRequest(request, context);
    this.setProxyAuthorizationIfNeed(httpRequest);

    throw new Error("Method not implemented.");
  }

  private setProxyAuthorizationIfNeed(httpRequest: CustomHttpRequest) {
    let proxyHost = this.getClientConfiguration().getProxyHost();
    let proxyPort = this.getClientConfiguration().getProxyPort();
    if (proxyHost && proxyPort > 0) {
      httpRequest.options.usingProxy = {
        host: proxyHost,

        port: proxyPort,

        username: this.getClientConfiguration().getProxyUsername(),

        password: this.getClientConfiguration().getProxyPassword(),

        exclusionList: []
      }
    }
  }

  protected getDefaultRetryStrategy(): RetryStrategy {
    throw new Error("Method not implemented.");
  }

  public shutdown(): void {
    throw new Error("Method not implemented.");
  }
}