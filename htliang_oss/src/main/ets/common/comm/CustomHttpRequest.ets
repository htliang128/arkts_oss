import HttpRequestOptionsBuilder from "./CustomHttpRequestOptions";

export default class CustomHttpRequest {
  url: string;
  options: HttpRequestOptionsBuilder;

  constructor(url: string, options: HttpRequestOptionsBuilder) {
    this.url = url;
    this.options = options;
  }
}