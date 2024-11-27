import ClientErrorCode from "../../ClientErrorCode";
import ClientException from "../../ClientException";
import HttpErr from "../../internal/model/HttpErr";
import OSSErrorResult from "../../internal/model/OSSErrorResult";
import OSSErrorCode from "../../OSSErrorCode";
import OSSException from "../exceptions/OSSException";

export default class ExceptionFactory {
  public static createNetworkException(httpErr: HttpErr): ClientException {
    let requestId = "Unknown";
    let errorCode = ClientErrorCode.UNKNOWN;

    if (httpErr.code === 401) {
      errorCode = ClientErrorCode.PARAMETER_ERROR;
    } else if (httpErr.code === 201) {
      errorCode = ClientErrorCode.PERMISSION_DENIED;
    } else if (httpErr.code === 2300001) {
      errorCode = ClientErrorCode.UNSUPPORTED_PROTOCOL;
    } else if (httpErr.code === 2300003) {
      errorCode = ClientErrorCode.INVALID_URL_FORMAT_OR_MISSING_URL;
    } else if (httpErr.code === 2300005) {
      errorCode = ClientErrorCode.FAILED_TO_RESOLVE_THE_PROXY_NAME;
    } else if (httpErr.code === 2300006) {
      errorCode = ClientErrorCode.FAILED_TO_RESOLVE_THE_HOST_NAME;
    } else if (httpErr.code === 2300007) {
      errorCode = ClientErrorCode.FAILED_TO_CONNECT_TO_THE_SERVER;
    } else if (httpErr.code === 2300008) {
      errorCode = ClientErrorCode.INVALID_SERVER_RESPONSE;
    } else if (httpErr.code === 2300009) {
      errorCode = ClientErrorCode.ACCESS_TO_THE_REMOTE_RESOURCE_DENIED;
    } else if (httpErr.code === 2300016) {
      errorCode = ClientErrorCode.ERROR_IN_THE_HTTP2_FRAMING_LAYER;
    } else if (httpErr.code === 2300018) {
      errorCode = ClientErrorCode.TRANSFERRED_A_PARTIAL_FILE;
    } else if (httpErr.code === 2300023) {
      errorCode = ClientErrorCode.FAILED_TO_WRITE_THE_RECEIVED_DATA;
    } else if (httpErr.code === 2300025) {
      errorCode = ClientErrorCode.UPLOAD_FAILED;
    } else if (httpErr.code === 2300026) {
      errorCode = ClientErrorCode.FAILED_TO_OPEN_OR_READ_LOCAL_DATA;
    } else if (httpErr.code === 2300027) {
      errorCode = ClientErrorCode.OUT_OF_MEMORY;
    } else if (httpErr.code === 2300028) {
      errorCode = ClientErrorCode.OPERATION_TIMEOUT;
    } else if (httpErr.code === 2300047) {
      errorCode = ClientErrorCode.REDIRECTED_NUMBERS_EXCEED;
    } else if (httpErr.code === 2300052) {
      errorCode = ClientErrorCode.EMPTY_RETURN;
    } else if (httpErr.code === 2300055) {
      errorCode = ClientErrorCode.FAILED_TO_SEND_DATA_TO_THE_PEER;
    } else if (httpErr.code === 2300056) {
      errorCode = ClientErrorCode.FAILED_TO_RECEIVE_DATA_FROM_THE_PEER;
    } else if (httpErr.code === 2300058) {
      errorCode = ClientErrorCode.LOCAL_SSL_CERTIFICATE_ERROR;
    } else if (httpErr.code === 2300059) {
      errorCode = ClientErrorCode.THE_SPECIFIED_SSL_CIPHER_CANNOT_BE_USED;
    } else if (httpErr.code === 2300060) {
      errorCode = ClientErrorCode.INVALID_SSL_PEER_CERTIFICATE_OR_SSH_REMOTE_KEY;
    } else if (httpErr.code === 2300061) {
      errorCode = ClientErrorCode.INVALID_HTTP_ENCODING_FORMAT;
    } else if (httpErr.code === 2300063) {
      errorCode = ClientErrorCode.MAXIMUM_FILE_SIZE_EXCEEDED;
    } else if (httpErr.code === 2300070) {
      errorCode = ClientErrorCode.REMOTE_DISK_FULL;
    } else if (httpErr.code === 2300073) {
      errorCode = ClientErrorCode.REMOTE_FILE_ALREADY_EXISTS;
    } else if (httpErr.code === 2300077) {
      errorCode = ClientErrorCode.THE_SSL_CA_CERTIFICATE_NOT_EXIST_OR_INACCESSIBLE;
    } else if (httpErr.code === 2300078) {
      errorCode = ClientErrorCode.REMOTE_FILE_NOT_FOUND;
    } else if (httpErr.code === 2300094) {
      errorCode = ClientErrorCode.AUTHENTICATION_ERROR;
    } else if (httpErr.code === 2300998) {
      errorCode = ClientErrorCode.IT_IS_NOT_ALLOWED_TO_ACCESS_THIS_DOMAIN;
    } else if (httpErr.code === 2300999) {
      errorCode = ClientErrorCode.UNKNOWN_ERROR;
    }

    return new ClientException(httpErr.message, errorCode, requestId, new Error(httpErr.message));
  }

  public static createInvalidResponseException(requestId: string | undefined, cause: Error): OSSException;

  public static createInvalidResponseException(requestId: string | undefined,
    message: string): OSSException;

  public static createInvalidResponseException(requestId: string | undefined,
    message: string | undefined, rawResponseError: string | undefined): OSSException;

  public static createInvalidResponseException(requestId: string | undefined, rawResponseError: string | undefined,
    cause: Error): OSSException;

  public static createInvalidResponseException(requestId: string | undefined, arg2: string | Error | undefined,
    arg3?: string | Error | undefined): OSSException {
    let message = '';
    let rawResponseError = '';
    if (!arg3) {
      if (typeof arg2 !== 'string') {
        message = `\u8FD4\u56DE\u7ED3\u679C\u65E0\u6CD5\u6B63\u786E\u89E3\u6790\u3002 : "${arg2?.message}"`;
      } else {
        message = arg2;
      }
    } else {
      if (typeof arg3 !== 'string') {
        rawResponseError = arg2 as string;
        message = `\u8FD4\u56DE\u7ED3\u679C\u65E0\u6CD5\u6B63\u786E\u89E3\u6790\u3002 : "${arg3?.message}"`;
      } else {
        message = arg2 as string;
        rawResponseError = arg3;
      }
    }

    return ExceptionFactory.createOSSException(requestId, OSSErrorCode.INVALID_RESPONSE, message, rawResponseError);
  }


  public static createOSSException(errorResult: OSSErrorResult): OSSException;

  public static createOSSException(errorResult: OSSErrorResult, rawResponseError: string | undefined): OSSException

  public static createOSSException(requestId: string | undefined, errorCode: string | undefined,
    message: string): OSSException

  public static createOSSException(requestId: string | undefined, errorCode: string | undefined,
    message: string | undefined,
    rawResponseError: string): OSSException


  public static createOSSException(arg1: OSSErrorResult | string | undefined,
    arg2?: string | undefined, arg3?: string | undefined, arg4?: string): OSSException {
    if (!arg2) {
      let errorResult = arg1 as OSSErrorResult;
      return new OSSException(errorResult.Message, errorResult.Code, errorResult.RequestId, errorResult.HostId,
        errorResult.Header, errorResult.ResourceType, errorResult.Method, undefined, undefined, errorResult.EC);
    }
    if (!arg3) {
      let errorResult = arg1 as OSSErrorResult;
      return new OSSException(errorResult.Message, errorResult.Code, errorResult.RequestId, errorResult.HostId,
        errorResult.Header, errorResult.ResourceType, errorResult.Method, arg2, undefined, errorResult.EC);
    }

    let requestId = arg1 as string;
    let errorCode = arg2 as string;
    let message = arg3 as string;
    let rawResponseError = arg4;

    return new OSSException(message, errorCode, requestId, undefined, undefined, undefined, undefined,
      rawResponseError);
  }

  public static createUnknownOSSException(requestId: string | undefined, statusCode: number): OSSException {
    let message = `No body in response, http status code ${statusCode}`;
    return new OSSException(message, ClientErrorCode.UNKNOWN, requestId, undefined, undefined, undefined, undefined);
  }
}