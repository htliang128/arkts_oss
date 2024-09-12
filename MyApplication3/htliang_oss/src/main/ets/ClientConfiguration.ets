import { RequestSigner } from './common/auth/RequestSigner';
import { Protocol } from './common/comm/Protocol';
import RetryStrategy from './common/comm/RetryStrategy';
import { SignVersion } from './common/comm/SignVersion';
import VersionInfoUtils from './common/utils/VersionInfoUtils';

export default class ClientConfiguration {
  public static DEFAULT_USER_AGENT: string = VersionInfoUtils.getDefaultUserAgent();
  public static DEFAULT_MAX_RETRIES: number = 3;
  public static DEFAULT_CONNECTION_REQUEST_TIMEOUT: number = -1;
  public static DEFAULT_CONNECTION_TIMEOUT: number = 50 * 1000;
  public static DEFAULT_SOCKET_TIMEOUT: number = 50 * 1000;
  public static DEFAULT_MAX_CONNECTIONS: number = 1024;
  public static DEFAULT_CONNECTION_TTL: number = -1;
  public static DEFAULT_IDLE_CONNECTION_TIME: number = 60 * 1000;
  public static DEFAULT_VALIDATE_AFTER_INACTIVITY: number = 2 * 1000;
  public static DEFAULT_THREAD_POOL_WAIT_TIME: number = 60 * 1000;
  public static DEFAULT_REQUEST_TIMEOUT: number = 5 * 60 * 1000;
  public static DEFAULT_SLOW_REQUESTS_THRESHOLD: number = 5 * 60 * 1000;
  public static DEFAULT_USE_REAPER: boolean = true;
  public static DEFAULT_CNAME_EXCLUDE_LIST: string = "aliyuncs.com,aliyun-inc.com,aliyun.com";
  public static DEFAULT_SIGNATURE_VERSION: SignVersion = SignVersion.V1;
  userAgent: string = ClientConfiguration.DEFAULT_USER_AGENT;
  maxErrorRetry: number = ClientConfiguration.DEFAULT_MAX_RETRIES;
  connectionRequestTimeout: number = ClientConfiguration.DEFAULT_CONNECTION_REQUEST_TIMEOUT;
  connectionTimeout: number = ClientConfiguration.DEFAULT_CONNECTION_TIMEOUT;
  socketTimeout: number = ClientConfiguration.DEFAULT_SOCKET_TIMEOUT;
  maxConnections: number = ClientConfiguration.DEFAULT_MAX_CONNECTIONS;
  connectionTTL: number = ClientConfiguration.DEFAULT_CONNECTION_TTL;
  useReaper: boolean = ClientConfiguration.DEFAULT_USE_REAPER;
  idleConnectionTime: number = ClientConfiguration.DEFAULT_IDLE_CONNECTION_TIME;
  protocol: Protocol = Protocol.HTTP;
  proxyHost: string | null = null;
  proxyPort: number = -1;
  proxyUsername: string | null = null;
  proxyPassword: string | null = null;
  proxyDomain: string | null = null;
  proxyWorkstation: string | null = null;
  supportCname: boolean = true;
  cnameExcludeList: string[] = [];
  sldEnabled: boolean = false;
  requestTimeout: number = ClientConfiguration.DEFAULT_REQUEST_TIMEOUT;
  requestTimeoutEnabled: boolean = false;
  slowRequestsThreshold: number = ClientConfiguration.DEFAULT_SLOW_REQUESTS_THRESHOLD;
  defaultHeaders: Map<string, string> = new Map<string, string>();
  crcCheckEnabled: boolean = true;
  signerHandlers: RequestSigner[] = [];
  signatureVersion: SignVersion = ClientConfiguration.DEFAULT_SIGNATURE_VERSION;
  tickOffset: number = 0;
  retryStrategy: RetryStrategy | undefined;
  redirectEnable: boolean = true;
  verifySSLEnable: boolean = true;
  logConnectionPoolStats: boolean = false;
  useSystemPropertyValues: boolean = false;
  extractSettingFromEndpoint: boolean = true;
  verifyObjectStrict: boolean = true;
  tracerEnabled: boolean = false;

  constructor() {
    // 初始化逻辑，例如设置默认值
  }
}
