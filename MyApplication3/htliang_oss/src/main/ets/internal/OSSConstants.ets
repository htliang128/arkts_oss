export default class OSSConstants {
  /**
   * Default OSS endpoint
   */
  public static DEFAULT_OSS_ENDPOINT: string = "http://oss.aliyuncs.com";
  /**
   * Default character set name
   */
  public static DEFAULT_CHARSET_NAME: string = "utf-8";
  /**
   * Default XML encoding
   */
  public static DEFAULT_XML_ENCODING: string = "utf-8";
  /**
   * Default object content type
   */
  public static DEFAULT_OBJECT_CONTENT_TYPE: string = "application/octet-stream";
  /**
   * Kilobyte constant
   */
  public static KB: number = 1024;
  /**
   * Default buffer size
   */
  public static DEFAULT_BUFFER_SIZE: number = 8 * OSSConstants.KB;
  /**
   * Default stream buffer size
   */
  public static DEFAULT_STREAM_BUFFER_SIZE: number = 512 * OSSConstants.KB;
  /**
   * Default file size limit
   */
  public static DEFAULT_FILE_SIZE_LIMIT: number = 5 * 1024 * 1024 * 1024;
  /**
   * Resource name for common
   */
  public static RESOURCE_NAME_COMMON: string = "common";
  /**
   * Resource name for OSS
   */
  public static RESOURCE_NAME_OSS: string = "oss";
  /**
   * Maximum length for object name
   */
  public static OBJECT_NAME_MAX_LENGTH: number = 1024;
  /**
   * Logger package name
   */
  public static LOGGER_PACKAGE_NAME: string = "com.aliyun.oss";
  /**
   * HTTP protocol
   */
  public static PROTOCOL_HTTP: string = "http://";
  /**
   * HTTPS protocol
   */
  public static PROTOCOL_HTTPS: string = "https://";
  /**
   * RTMP protocol
   */
  public static PROTOCOL_RTMP: string = "rtmp://";
  /**
   * Represents a null OSS version ID
   */
  public static NULL_VERSION_ID: string = "null";
  /**
   * URL encoding for OSS object keys
   */
  public static URL_ENCODING: string = "url";
  /**
   * Default product name
   */
  public static PRODUCT_DEFAULT: string = "oss";
  /**
   * Cloud box product name
   */
  public static PRODUCT_CLOUD_BOX: string = "oss-cloudbox";
}