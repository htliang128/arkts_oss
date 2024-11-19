import OSSHeaders from '../../internal/OSSHeaders';
import HttpMessage from './HttpMessage';
import { Request } from './SeviceClient';
import { http } from '@kit.NetworkKit';
import InputStream from '@htliang/java_type/src/main/ets/java/io/InputStream';

export default class ResponseMessage extends HttpMessage {
  private static readonly HTTP_SUCCESS_STATUS_CODE: number = 200;
  private uri: string = '';
  private statusCode: number = -1;
  private request: Request;
  private httpResponse?: http.HttpResponse;
  private errorResponseAsString: string = '';

  constructor(request: Request) {
    super();
    this.request = request;
  }

  getUri(): string {
    return this.uri;
  }

  setUrl(uri: string): void {
    this.uri = uri;
  }

  getStatusCode(): number {
    return this.statusCode;
  }

  setStatusCode(statusCode: number): void {
    this.statusCode = statusCode;
  }

  getRequestId(): string | undefined {
    return this.headers.get(OSSHeaders.OSS_HEADER_REQUEST_ID);
  }

  getRequest(): Request {
    return this.request;
  }

  isSuccessful(): boolean {
    return Math.floor(this.statusCode / 100) === Math.floor(ResponseMessage.HTTP_SUCCESS_STATUS_CODE / 100);
  }

  getErrorResponseAsString(): string | null {
    return this.errorResponseAsString;
  }

  setErrorResponseAsString(errorResponseAsString: string): void {
    this.errorResponseAsString = errorResponseAsString;
  }

  abort(): void {
    // if (this.httpResponse) {
    //   await this.httpResponse.close();
    // }
  }

  getHttpResponse(): http.HttpResponse | undefined {
    return this.httpResponse;
  }

  setHttpResponse(httpResponse: http.HttpResponse): void {
    this.httpResponse = httpResponse;
  }
}