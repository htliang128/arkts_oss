import CommonConstant from './common/CommonConstant';

export default class ClientException extends Error {
  errorMessage?: string;
  requestId?: string;
  errorCode?: string;

  constructor(errorMessage: string, errorCode?: string, requestId?: string) {
    super();
    this.name = "ClientException";
    this.errorMessage = errorMessage;
    this.requestId = requestId;
    this.errorCode = errorCode;

    this.message = `${errorMessage}
    [ErrorCode]: ${errorCode ?? CommonConstant.BLANK}
    [RequestId]: ${requestId ?? CommonConstant.BLANK}`
  }
}