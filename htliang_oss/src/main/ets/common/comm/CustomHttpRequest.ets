import CustomHttpRequestOptions from "./CustomHttpRequestOptions";

export default class CustomHttpRequest {
  url: string;
  options: CustomHttpRequestOptions;

  constructor(url: string, options: CustomHttpRequestOptions) {
    this.url = url;
    this.options = options;
  }
}