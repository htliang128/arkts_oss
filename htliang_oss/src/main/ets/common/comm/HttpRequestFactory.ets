import { ExecutionContext } from "./ExecutionContext";

import { Request } from "./SeviceClient";
import { http } from "@kit.NetworkKit";
import CustomHttpRequestOptions from "./CustomHttpRequestOptions";
import CustomHttpRequest from "./CustomHttpRequest";
import HttpHeaders from "../utils/HttpHeaders";
import { TreeMap } from "@kit.ArkTS";

export default class HttpRequestFactory {
  public createHttpRequest(request: Request, context: ExecutionContext): CustomHttpRequest {
    let httpRequestOptions: CustomHttpRequestOptions = new CustomHttpRequestOptions();
    httpRequestOptions.method = request.getMethod();
    httpRequestOptions.extraData = xxx;

    let uri = request.getUri();
    this.configureRequestHeaders(request, context, httpRequestOptions);
    return new CustomHttpRequest(uri, httpRequestOptions);
  }

  private configureRequestHeaders(request: Request, context: ExecutionContext,
    httpRequestOptions: CustomHttpRequestOptions): void {
    request.headers.forEach((value, key) => {
      if (!key) {
        return;
      }
      if (key.toUpperCase() === HttpHeaders.CONTENT_LENGTH || key.toUpperCase() === HttpHeaders.HOST) {
        return;
      }
      if (!httpRequestOptions.header) {
        httpRequestOptions.header = new TreeMap();
      }
      httpRequestOptions.header.set(key, value);
    })
  }
}