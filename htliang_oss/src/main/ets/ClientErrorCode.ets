export default class ClientErrorCode {
  static readonly UNKNOWN = "Unknown";
  static readonly UNKNOWN_HOST = "UnknownHost";
  static readonly CONNECTION_TIMEOUT = "ConnectionTimeout";
  static readonly SOCKET_TIMEOUT = "SocketTimeout";
  static readonly SOCKET_EXCEPTION = "SocketException";
  static readonly CONNECTION_REFUSED = "ConnectionRefused";
  static readonly NONREPEATABLE_REQUEST = "NonRepeatableRequest";
  static readonly INPUTSTREAM_READING_ABORTED = "InputStreamReadingAborted";
  static readonly SSL_EXCEPTION = "SslException";
}