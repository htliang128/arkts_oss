import RuntimeException from '@htliang/java_type/src/main/ets/java/lang/RuntimeException';
import CommonConstant from '../CommonConstant';

export default class ServiceException extends RuntimeException {
  name: string;
  message: string;
  stack?: string;
  errorMessage?: string;
  errorCode?: string;
  requestId?: string;
  hostId?: string;
  ec?: string;
  rawResponseError?: string;

  constructor();

  constructor(errorMessage: string);

  constructor(cause: Error);

  constructor(errorMessage: string, cause: Error);

  constructor(errorMessage: string, errorCode: string, requestId: string, hostId: string);

  constructor(errorMessage: string, errorCode: string, requestId: string, hostId: string, cause: Error);

  constructor(errorMessage: string, errorCode: string, requestId: string, hostId: string, rawResponseError: string,
    cause: Error);

  constructor(errorMessage: string, errorCode: string, requestId: string, hostId: string, rawResponseError: string,
    cause: Error, ec: string);

  constructor(arg1?: string | Error, arg2?: string | Error, arg3?: string, arg4?: string, arg5?: string | Error,
    arg6?: string | Error, arg7?: string) {
    if (!arg1) {
      super();
    } else if (!arg2) {
      if (typeof arg1 === 'string') {
        super(arg1);
        this.errorMessage = arg1;
      } else {
        super(arg1);
        this.errorMessage = CommonConstant.BLANK;
      }
    } else if (!arg3) {
      super(arg1 as string, arg2 as Error);
      this.errorMessage = arg1 as string;
    } else if (!arg5) {
      super(arg1 as string);
      this.errorMessage = arg1 as string;
      this.errorCode = arg2 as string;
      this.requestId = arg3 as string;
      this.hostId = arg4 as string;
    } else if (!arg6) {
      super(arg1 as string, arg5 as Error);
      this.errorMessage = arg1 as string;
      this.errorCode = arg2 as string;
      this.requestId = arg3 as string;
      this.hostId = arg4 as string;
    } else {
      super(arg1 as string, arg6 as Error);
      this.errorMessage = arg1 as string;
      this.errorCode = arg2 as string;
      this.requestId = arg3 as string;
      this.hostId = arg4 as string;
      this.rawResponseError = arg5 as string;
      if (arg7) {
        this.ec = arg7 as string;
      }
    }

    this.name = "ServiceException";

    this.message =
      `${this.errorMessage}\n[ErrorCode]: ${this.errorCode}\n[RequestId]: ${this.requestId}\n[HostId]: ${this.hostId}${this.ec ==
      CommonConstant.BLANK ? CommonConstant.BLANK : "\n[EC]: " + this.ec}${this.rawResponseError ==
      CommonConstant.BLANK ? CommonConstant.BLANK : "\n[ResponseError]:\n" + this.rawResponseError}`;
  }
}