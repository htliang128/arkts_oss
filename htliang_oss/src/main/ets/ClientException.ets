import ClientErrorCode from './ClientErrorCode';
import CommonConstant from './common/CommonConstant';

export default class ClientException extends Error {
  errorMessage: string;
  requestId: string;
  errorCode: string;

  constructor();

  constructor(errorMessage: string);

  constructor(cause: Error);

  constructor(errorMessage: string, cause: Error);

  constructor(errorMessage: string, errorCode: string, requestId: string);

  constructor(errorMessage: string, errorCode: string, requestId: string, cause: Error);

  constructor(arg1?: string | Error, arg2?: string | Error, arg3?: string, arg4?: Error) {
    if (!arg1) {
      super();
      this.name = "ClientException";
      this.errorMessage = ClientErrorCode.UNKNOWN;
      this.errorCode = ClientErrorCode.UNKNOWN;
      this.requestId = ClientErrorCode.UNKNOWN;
      this.message = `${this.errorMessage}
    [ErrorCode]: ${this.errorCode ?? CommonConstant.BLANK}
    [RequestId]: ${this.requestId ?? CommonConstant.BLANK}`
      return;
    }

    if (typeof arg1 === 'string' && !arg2) {
      super(arg1);
      this.name = "ClientException";
      this.errorMessage = arg1;
      this.errorCode = ClientErrorCode.UNKNOWN;
      this.requestId = ClientErrorCode.UNKNOWN;
      this.message = `${this.errorMessage}
    [ErrorCode]: ${this.errorCode ?? CommonConstant.BLANK}
    [RequestId]: ${this.requestId ?? CommonConstant.BLANK}`
      return;
    }

    if (typeof arg1 !== 'string' && !arg2) {
      super(arg1.message);
      this.name = "ClientException";
      this.errorMessage = CommonConstant.BLANK;
      this.errorCode = ClientErrorCode.UNKNOWN;
      this.requestId = ClientErrorCode.UNKNOWN;
      this.message = `${this.errorMessage}
    [ErrorCode]: ${this.errorCode ?? CommonConstant.BLANK}
    [RequestId]: ${this.requestId ?? CommonConstant.BLANK}`
      return;
    }

    if (!arg3) {
      super(arg1 as string);
      this.name = "ClientException";
      this.errorMessage = arg1 as string;
      this.errorCode = ClientErrorCode.UNKNOWN;
      this.requestId = ClientErrorCode.UNKNOWN;
      this.message = `${this.errorMessage}
    [ErrorCode]: ${this.errorCode ?? CommonConstant.BLANK}
    [RequestId]: ${this.requestId ?? CommonConstant.BLANK}`
      return;
    }


    this.errorMessage = errorMessage;
    this.requestId = requestId;
    this.errorCode = errorCode;

    this.message = `${errorMessage}
    [ErrorCode]: ${errorCode ?? CommonConstant.BLANK}
    [RequestId]: ${requestId ?? CommonConstant.BLANK}`
  }
}