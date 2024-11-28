import { ExecutionContext } from "./ExecutionContext";

import { Request } from "./SeviceClient";
import { http } from "@kit.NetworkKit";
import HttpRequestOptionsBuilder from "./CustomHttpRequestOptions";
import HttpHeaders from "../utils/HttpHeaders";
import { TreeMap } from "@kit.ArkTS";

export default class HttpRequestFactory {
  public createHttpRequestOptionsBuilder(request: Request, context: ExecutionContext): HttpRequestOptionsBuilder {
    let httpRequestOptions: HttpRequestOptionsBuilder = new HttpRequestOptionsBuilder();
    let method = request.getMethod();

    switch (method) {
      case http.RequestMethod.POST:
      case http.RequestMethod.PUT:
      case http.RequestMethod.DELETE:
        this.setupContent(request, httpRequestOptions);
    }

    httpRequestOptions.setMethod(method);
    httpRequestOptions.setExpectDataType(http.HttpDataType.ARRAY_BUFFER);
    this.configureRequestHeaders(request, context, httpRequestOptions);
    return httpRequestOptions;
  }

  private setupContent(request: Request, httpRequestOptions: HttpRequestOptionsBuilder) {
    let content = request.getContent();
    if (!content) {
      return;
    }
    if (request.getContentLength() > 0) {
      httpRequestOptions.setExtraData(content.readNBytes(request.getContentLength()).buffer);
      return;
    }

    httpRequestOptions.setExtraData(content.readAllBytes().buffer);
  }

  private configureRequestHeaders(request: Request, context: ExecutionContext,
    httpRequestOptions: HttpRequestOptionsBuilder): void {
    request.getHeaders().forEach((value, key) => {
      if (!key) {
        return;
      }
      if (key.toUpperCase() === HttpHeaders.CONTENT_LENGTH || key.toUpperCase() === HttpHeaders.HOST) {
        return;
      }
      if (!httpRequestOptions.getHeader()) {
        httpRequestOptions.setHeader(new TreeMap());
      }
      httpRequestOptions.getHeader()?.set(key, value);
    })
  }
}