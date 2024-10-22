export default class ResponseHeaderOverrides {
  private contentType?: string;
  private contentLanguage?: string;
  private expires?: string;
  private cacheControl?: string;
  private contentDisposition?: string;
  private contentEncoding?: string;
  static readonly RESPONSE_HEADER_CONTENT_TYPE = "response-content-type";
  static readonly RESPONSE_HEADER_CONTENT_LANGUAGE = "response-content-language";
  static readonly RESPONSE_HEADER_EXPIRES = "response-expires";
  static readonly RESPONSE_HEADER_CACHE_CONTROL = "response-cache-control";
  static readonly RESPONSE_HEADER_CONTENT_DISPOSITION = "response-content-disposition";
  static readonly RESPONSE_HEADER_CONTENT_ENCODING = "response-content-encoding";

  getContentType(): string | undefined {
    return this.contentType;
  }

  setContentType(contentType: string): void {
    this.contentType = contentType;
  }

  getContentLanguage(): string | undefined {
    return this.contentLanguage;
  }

  setContentLanguage(contentLanguage: string): void {
    this.contentLanguage = contentLanguage;
  }

  getExpires(): string | undefined {
    return this.expires;
  }

  setExpires(expires: string): void {
    this.expires = expires;
  }

  getCacheControl(): string | undefined {
    return this.cacheControl;
  }

  setCacheControl(cacheControl: string): void {
    this.cacheControl = cacheControl;
  }

  getContentDisposition(): string | undefined {
    return this.contentDisposition;
  }

  setContentDisposition(contentDisposition: string): void {
    this.contentDisposition = contentDisposition;
  }

  getContentEncoding(): string | undefined {
    return this.contentEncoding;
  }

  setContentEncoding(contentEncoding: string): void {
    this.contentEncoding = contentEncoding;
  }
}
