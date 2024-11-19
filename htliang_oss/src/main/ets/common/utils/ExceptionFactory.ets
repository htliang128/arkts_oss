import ClientErrorCode from "../../ClientErrorCode";
import ClientException from "../../ClientException";

export default class ExceptionFactory {
  public static createNetworkException(ex: Error): ClientException {
    let requestId = "Unknown";
    let errorCode = ClientErrorCode.UNKNOWN;

    if (ex.message.includes('401')) {
      errorCode = ClientErrorCode.PARAMETER_ERROR;
    } else if (ex.message.includes('201')) {
      errorCode = ClientErrorCode.PERMISSION_DENIED;
    } else if (ex.message.includes('2300001')) {
      errorCode = ClientErrorCode.UNSUPPORTED_PROTOCOL;
    } else if (ex.message.includes('2300003')) {
      errorCode = ClientErrorCode.INVALID_URL_FORMAT_OR_MISSING_URL;
    } else if (ex.message.includes('2300005')) {
      errorCode = ClientErrorCode.FAILED_TO_RESOLVE_THE_PROXY_NAME;
    } else if (ex.message.includes('2300006')) {
      errorCode = ClientErrorCode.FAILED_TO_RESOLVE_THE_HOST_NAME;
    } else if (ex.message.includes('2300007')) {
      errorCode = ClientErrorCode.FAILED_TO_CONNECT_TO_THE_SERVER;
    } else if (ex.message.includes('2300008')) {
      errorCode = ClientErrorCode.INVALID_SERVER_RESPONSE;
    } else if (ex.message.includes('2300009')) {
      errorCode = ClientErrorCode.ACCESS_TO_THE_REMOTE_RESOURCE_DENIED;
    } else if (ex.message.includes('2300016')) {
      errorCode = ClientErrorCode.ERROR_IN_THE_HTTP2_FRAMING_LAYER;
    } else if (ex.message.includes('2300018')) {
      errorCode = ClientErrorCode.TRANSFERRED_A_PARTIAL_FILE;
    } else if (ex.message.includes('2300023')) {
      errorCode = ClientErrorCode.FAILED_TO_WRITE_THE_RECEIVED_DATA;
    } else if (ex.message.includes('2300025')) {
      errorCode = ClientErrorCode.UPLOAD_FAILED;
    } else if (ex.message.includes('2300026')) {
      errorCode = ClientErrorCode.FAILED_TO_OPEN_OR_READ_LOCAL_DATA;
    } else if (ex.message.includes('2300027')) {
      errorCode = ClientErrorCode.OUT_OF_MEMORY;
    } else if (ex.message.includes('2300028')) {
      errorCode = ClientErrorCode.OPERATION_TIMEOUT;
    } else if (ex.message.includes('2300047')) {
      errorCode = ClientErrorCode.REDIRECTED_NUMBERS_EXCEED;
    } else if (ex.message.includes('2300052')) {
      errorCode = ClientErrorCode.EMPTY_RETURN;
    } else if (ex.message.includes('2300055')) {
      errorCode = ClientErrorCode.FAILED_TO_SEND_DATA_TO_THE_PEER;
    } else if (ex.message.includes('2300056')) {
      errorCode = ClientErrorCode.FAILED_TO_RECEIVE_DATA_FROM_THE_PEER;
    } else if (ex.message.includes('2300058')) {
      errorCode = ClientErrorCode.LOCAL_SSL_CERTIFICATE_ERROR;
    } else if (ex.message.includes('2300059')) {
      errorCode = ClientErrorCode.THE_SPECIFIED_SSL_CIPHER_CANNOT_BE_USED;
    } else if (ex.message.includes('2300060')) {
      errorCode = ClientErrorCode.INVALID_SSL_PEER_CERTIFICATE_OR_SSH_REMOTE_KEY;
    } else if (ex.message.includes('2300061')) {
      errorCode = ClientErrorCode.INVALID_HTTP_ENCODING_FORMAT;
    } else if (ex.message.includes('2300063')) {
      errorCode = ClientErrorCode.MAXIMUM_FILE_SIZE_EXCEEDED;
    } else if (ex.message.includes('2300070')) {
      errorCode = ClientErrorCode.REMOTE_DISK_FULL;
    } else if (ex.message.includes('2300073')) {
      errorCode = ClientErrorCode.REMOTE_FILE_ALREADY_EXISTS;
    } else if (ex.message.includes('2300077')) {
      errorCode = ClientErrorCode.THE_SSL_CA_CERTIFICATE_NOT_EXIST_OR_INACCESSIBLE;
    } else if (ex.message.includes('2300078')) {
      errorCode = ClientErrorCode.REMOTE_FILE_NOT_FOUND;
    } else if (ex.message.includes('2300094')) {
      errorCode = ClientErrorCode.AUTHENTICATION_ERROR;
    } else if (ex.message.includes('2300998')) {
      errorCode = ClientErrorCode.IT_IS_NOT_ALLOWED_TO_ACCESS_THIS_DOMAIN;
    } else if (ex.message.includes('2300999')) {
      errorCode = ClientErrorCode.UNKNOWN_ERROR;
    }

    return new ClientException(ex.message, errorCode, requestId, ex);
  }
}