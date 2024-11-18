import RuntimeException from '@htliang/java_type/src/main/ets/java/lang/RuntimeException';
import CommonConstant from '../CommonConstant';

export default class ServiceException extends  RuntimeException {
  name: string;
  message: string;
  stack?: string;
  errorMessage?: string;
  errorCode?: string;
  requestId?: string;
  hostId?: string;
  ec?: string;
  rawResponseError?: string;

  constructor(errorMessage?: string, cause?: Error, errorCode?: string, requestId?: string, hostId?: string,
    rawResponseError?: string,
    ec?: string) {
    super(errorMessage, cause);
    this.name = "ServiceException";
    this.errorMessage = errorMessage ?? CommonConstant.BLANK;
    this.errorCode = errorCode ?? CommonConstant.BLANK;
    this.requestId = requestId ?? CommonConstant.BLANK;
    this.hostId = this.hostId ?? CommonConstant.BLANK;
    this.rawResponseError = rawResponseError ?? CommonConstant.BLANK;
    this.ec = ec ?? CommonConstant.BLANK;

    this.stack = cause ? cause?.stack : CommonConstant.BLANK;


    this.message =
      `${this.errorMessage}\n[ErrorCode]: ${this.errorCode}\n[RequestId]: ${this.requestId}\n[HostId]: ${this.hostId}${this.ec ==
      CommonConstant.BLANK ? CommonConstant.BLANK : "\n[EC]: " + this.ec}${this.rawResponseError ==
      CommonConstant.BLANK ? CommonConstant.BLANK : "\n[ResponseError]:\n" + this.rawResponseError}`;
  }
}