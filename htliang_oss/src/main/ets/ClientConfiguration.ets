import { RequestSigner } from './common/auth/RequestSigner';
import { Protocol } from './common/comm/Protocol';
import RetryStrategy from './common/comm/RetryStrategy';
import { SignVersion } from './common/comm/SignVersion';
import VersionInfoUtils from './common/utils/VersionInfoUtils';

export default class ClientConfiguration {
  public static readonly DEFAULT_USER_AGENT = VersionInfoUtils.getDefaultUserAgent();
  public static readonly DEFAULT_MAX_RETRIES = 3;
  public static readonly DEFAULT_CONNECTION_REQUEST_TIMEOUT = -1;
  public static readonly DEFAULT_CONNECTION_TIMEOUT = 50;
  public static readonly DEFAULT_SOCKET_TIMEOUT = 50;
  public static readonly DEFAULT_MAX_CONNECTIONS = 1024;
  public static readonly DEFAULT_CONNECTION_TTL = -1;
  public static readonly DEFAULT_IDLE_CONNECTION_TIME = 60;
  public static readonly DEFAULT_VALIDATE_AFTER_INACTIVITY = 2;
  public static readonly DEFAULT_THREAD_POOL_WAIT_TIME = 60;
  public static readonly DEFAULT_REQUEST_TIMEOUT = 5;
  public static readonly DEFAULT_SLOW_REQUESTS_THRESHOLD = 5;
  public static readonly DEFAULT_USE_REAPER = true;
  public static readonly DEFAULT_CNAME_EXCLUDE_LIST = "aliyuncs.com,aliyun-inc.com,aliyun.com";
  public static readonly DEFAULT_SIGNATURE_VERSION = SignVersion.V4;
  protected userAgent: string = ClientConfiguration.DEFAULT_USER_AGENT;
  protected maxErrorRetry: number = ClientConfiguration.DEFAULT_MAX_RETRIES;
  protected connectionRequestTimeout: number = ClientConfiguration.DEFAULT_CONNECTION_REQUEST_TIMEOUT;
  protected connectionTimeout: number = ClientConfiguration.DEFAULT_CONNECTION_TIMEOUT;
  protected socketTimeout: number = ClientConfiguration.DEFAULT_SOCKET_TIMEOUT;
  protected maxConnections: number = ClientConfiguration.DEFAULT_MAX_CONNECTIONS;
  protected connectionTTL: number = ClientConfiguration.DEFAULT_CONNECTION_TTL;
  protected useReaper: boolean = ClientConfiguration.DEFAULT_USE_REAPER;
  protected idleConnectionTime: number = ClientConfiguration.DEFAULT_IDLE_CONNECTION_TIME;
  protected protocol: Protocol = Protocol.HTTP;
  protected proxyHost: string | undefined;
  protected proxyPort: number = -1;
  protected proxyUsername: string | undefined;
  protected proxyPassword: string | undefined;
  protected proxyDomain: string | undefined;
  protected proxyWorkstation: string | undefined;
  protected supportCname: boolean = true;
  protected cnameExcludeList: string[] = [];
  protected sldEnabled: boolean = false;
  protected requestTimeout: number = ClientConfiguration.DEFAULT_REQUEST_TIMEOUT;
  protected requestTimeoutEnabled: boolean = false;
  protected slowRequestsThreshold: number = ClientConfiguration.DEFAULT_SLOW_REQUESTS_THRESHOLD;
  protected defaultHeaders: Map<string, string> = new Map<string, string>();
  protected crcCheckEnabled: boolean = true;
  protected signerHandlers: RequestSigner[] = [];
  protected signatureVersion: SignVersion = ClientConfiguration.DEFAULT_SIGNATURE_VERSION;
  protected tickOffset: number = 0;
  private retryStrategy?: RetryStrategy;
  private redirectEnable: boolean = true;
  private verifySSLEnable: boolean = true;
  protected logConnectionPoolStats: boolean = false;
  protected useSystemPropertyValues: boolean = false;
  private extractSettingFromEndpoint: boolean = true;
  private verifyObjectStrict: boolean = true;
  private tracerEnabled: boolean = false;

  constructor() {
    this.appendDefaultExcludeList(this.cnameExcludeList);
  }

  getUserAgent(): string {
    return this.userAgent;
  }

  setUserAgent(userAgent: string): void {
    this.userAgent = userAgent;
  }

  getProxyHost(): string | undefined {
    return this.proxyHost;
  }

  setProxyHost(proxyHost: string): void {
    this.proxyHost = proxyHost;
  }

  getProxyPort(): number {
    return this.proxyPort;
  }

  setProxyPort(proxyPort: number): void {
    if (proxyPort <= 0) {
      throw new Error("Parameter is invalid.");
    }
    this.proxyPort = proxyPort;
  }

  getProxyUsername(): string | undefined {
    return this.proxyUsername;
  }

  setProxyUsername(proxyUsername: string): void {
    this.proxyUsername = proxyUsername;
  }

  getProxyPassword(): string | undefined {
    return this.proxyPassword;
  }

  setProxyPassword(proxyPassword: string): void {
    this.proxyPassword = proxyPassword;
  }

  getProxyDomain(): string | undefined {
    return this.proxyDomain;
  }

  setProxyDomain(proxyDomain: string): void {
    this.proxyDomain = proxyDomain;
  }

  getProxyWorkstation(): string | undefined {
    return this.proxyWorkstation;
  }

  setProxyWorkstation(proxyWorkstation: string): void {
    this.proxyWorkstation = proxyWorkstation;
  }

  getMaxConnections(): number {
    return this.maxConnections;
  }

  setMaxConnections(maxConnections: number): void {
    this.maxConnections = maxConnections;
  }

  getSocketTimeout(): number {
    return this.socketTimeout;
  }

  setSocketTimeout(socketTimeout: number): void {
    this.socketTimeout = socketTimeout;
  }

  getConnectionTimeout(): number {
    return this.connectionTimeout;
  }

  setConnectionTimeout(connectionTimeout: number): void {
    this.connectionTimeout = connectionTimeout;
  }

  getConnectionRequestTimeout(): number {
    return this.connectionRequestTimeout;
  }

  setConnectionRequestTimeout(connectionRequestTimeout: number): void {
    this.connectionRequestTimeout = connectionRequestTimeout;
  }

  getMaxErrorRetry(): number {
    return this.maxErrorRetry;
  }

  setMaxErrorRetry(maxErrorRetry: number): void {
    this.maxErrorRetry = maxErrorRetry;
  }

  getConnectionTTL(): number {
    return this.connectionTTL;
  }

  setConnectionTTL(connectionTTL: number): void {
    this.connectionTTL = connectionTTL;
  }

  isUseReaper(): boolean {
    return this.useReaper;
  }

  setUseReaper(useReaper: boolean): void {
    this.useReaper = useReaper;
  }

  getIdleConnectionTime(): number {
    return this.idleConnectionTime;
  }

  setIdleConnectionTime(idleConnectionTime: number): void {
    this.idleConnectionTime = idleConnectionTime;
  }

  getProtocol(): Protocol {
    return this.protocol;
  }

  setProtocol(protocol: Protocol): void {
    this.protocol = protocol;
  }

  getCnameExcludeList(): string[] {
    return [...this.cnameExcludeList];
  }

  setCnameExcludeList(cnameExcludeList: string[]): void {
    if (cnameExcludeList == null) {
      throw new Error("Cname exclude list should not be null.");
    }

    this.cnameExcludeList = cnameExcludeList.filter(excl => excl.trim() !== '');
    this.appendDefaultExcludeList(this.cnameExcludeList);
  }

  private appendDefaultExcludeList(excludeList: string[]): void {
    const excludes = ClientConfiguration.DEFAULT_CNAME_EXCLUDE_LIST.split(",");
    excludes.forEach(excl => {
      if (excl.trim() !== '' && !excludeList.includes(excl)) {
        excludeList.push(excl.trim().toLowerCase());
      }
    });
  }

  isSupportCname(): boolean {
    return this.supportCname;
  }

  setSupportCname(supportCname: boolean) {
    this.supportCname = supportCname;
    return this;
  }

  isSLDEnabled(): boolean {
    return this.sldEnabled;
  }

  setSLDEnabled(enabled: boolean) {
    this.sldEnabled = enabled;
    return this;
  }

  getValidateAfterInactivity(): number {
    return ClientConfiguration.DEFAULT_VALIDATE_AFTER_INACTIVITY;
  }

  isRequestTimeoutEnabled(): boolean {
    return this.requestTimeoutEnabled;
  }

  setRequestTimeoutEnabled(requestTimeoutEnabled: boolean): void {
    this.requestTimeoutEnabled = requestTimeoutEnabled;
  }

  setRequestTimeout(requestTimeout: number): void {
    this.requestTimeout = requestTimeout;
  }

  getRequestTimeout(): number {
    return this.requestTimeout;
  }

  getSlowRequestsThreshold(): number {
    return this.slowRequestsThreshold;
  }

  setSlowRequestsThreshold(slowRequestsThreshold: number): void {
    this.slowRequestsThreshold = slowRequestsThreshold;
  }

  getDefaultHeaders(): Map<string, string> {
    return this.defaultHeaders;
  }

  setDefaultHeaders(defaultHeaders: Map<string, string>): void {
    this.defaultHeaders = defaultHeaders;
  }

  addDefaultHeader(key: string, value: string): void {
    this.defaultHeaders.set(key, value);
  }

  isCrcCheckEnabled(): boolean {
    return this.crcCheckEnabled;
  }

  setCrcCheckEnabled(crcCheckEnabled: boolean): void {
    this.crcCheckEnabled = crcCheckEnabled;
  }

  getSignerHandlers(): RequestSigner[] {
    return this.signerHandlers;
  }

  setSignerHandlers(signerHandlers: RequestSigner[]): void {
    if (signerHandlers == null) {
      return;
    }
    this.signerHandlers = signerHandlers.filter(signer => signer != null);
  }

  getSignatureVersion(): SignVersion {
    return this.signatureVersion;
  }

  setSignatureVersion(signatureVersion: SignVersion): void {
    if (signatureVersion !== SignVersion.V4) {
      throw new Error('CurrentVersion support V4 only!')
    }
    this.signatureVersion = signatureVersion;
  }

  getTickOffset(): number {
    return this.tickOffset;
  }

  setTickOffset(epochTicks: number): void {
    const localTime = Date.now();
    this.tickOffset = epochTicks - localTime;
  }

  getRetryStrategy(): RetryStrategy | undefined {
    return this.retryStrategy;
  }

  setRetryStrategy(retryStrategy: RetryStrategy): void {
    this.retryStrategy = retryStrategy;
  }

  isRedirectEnable(): boolean {
    return this.redirectEnable;
  }

  setRedirectEnable(redirectEnable: boolean): void {
    this.redirectEnable = redirectEnable;
  }

  isVerifySSLEnable(): boolean {
    return this.verifySSLEnable;
  }

  setVerifySSLEnable(verifySSLEnable: boolean): void {
    this.verifySSLEnable = verifySSLEnable;
  }


  setLogConnectionPoolStats(enabled: boolean): void {
    this.logConnectionPoolStats = enabled;
  }

  isLogConnectionPoolStatsEnable(): boolean {
    return this.logConnectionPoolStats;
  }

  setUseSystemPropertyValues(enabled: boolean): void {
    this.useSystemPropertyValues = enabled;
  }

  isUseSystemPropertyValues(): boolean {
    return this.useSystemPropertyValues;
  }

  setExtractSettingFromEndpoint(enabled: boolean): void {
    this.extractSettingFromEndpoint = enabled;
  }

  isExtractSettingFromEndpointEnable(): boolean {
    return this.extractSettingFromEndpoint;
  }

  setVerifyObjectStrictEnable(enabled: boolean): void {
    this.verifyObjectStrict = enabled;
  }

  isVerifyObjectStrict(): boolean {
    return this.verifyObjectStrict;
  }

  isTracerEnabled(): boolean {
    return this.tracerEnabled;
  }

  setTracerEnabled(enabled: boolean): void {
    this.tracerEnabled = enabled;
  }
}
