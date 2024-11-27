import { http } from "@kit.NetworkKit";
import { TreeMap } from "@kit.ArkTS";

export default class HttpRequestOptionsBuilder {
  constructor() {
  }

  private method?: http.RequestMethod;
  private extraData?: string | Object | ArrayBuffer;
  private expectDataType?: http.HttpDataType;
  private usingCache?: boolean;
  private priority?: number;
  private header?: TreeMap<string, string>;
  private readTimeout?: number;
  private connectTimeout?: number;
  private usingProtocol?: http.HttpProtocol;
  private usingProxy?: boolean | http.HttpProxy;
  private caPath?: string;
  private resumeFrom?: number;
  private resumeTo?: number;
  private clientCert?: http.ClientCert;
  private dnsOverHttps?: string;
  private dnsServers?: Array<string>;
  private maxLimit?: number;
  private multiFormDataList?: Array<http.MultiFormData>;
  private certificatePinning?: http.CertificatePinning | http.CertificatePinning[];

  // Getter and setter for method
  getMethod(): http.RequestMethod | undefined {
    return this.method;
  }

  setMethod(value: http.RequestMethod | undefined): void {
    this.method = value;
  }

  // Getter and setter for extraData
  getExtraData(): string | Object | ArrayBuffer | undefined {
    return this.extraData;
  }

  setExtraData(value: string | Object | ArrayBuffer | undefined): void {
    this.extraData = value;
  }

  // Getter and setter for expectDataType
  getExpectDataType(): http.HttpDataType | undefined {
    return this.expectDataType;
  }

  setExpectDataType(value: http.HttpDataType | undefined): void {
    this.expectDataType = value;
  }

  // Getter and setter for usingCache
  getUsingCache(): boolean | undefined {
    return this.usingCache;
  }

  setUsingCache(value: boolean | undefined): void {
    this.usingCache = value;
  }

  // Getter and setter for priority
  getPriority(): number | undefined {
    return this.priority;
  }

  setPriority(value: number | undefined): void {
    this.priority = value;
  }

  // Getter and setter for header
  getHeader(): TreeMap<string, string> | undefined {
    return this.header;
  }

  setHeader(value: TreeMap<string, string> | undefined): void {
    this.header = value;
  }

  // Getter and setter for readTimeout
  getReadTimeout(): number | undefined {
    return this.readTimeout;
  }

  setReadTimeout(value: number | undefined): void {
    this.readTimeout = value;
  }

  // Getter and setter for connectTimeout
  getConnectTimeout(): number | undefined {
    return this.connectTimeout;
  }

  setConnectTimeout(value: number | undefined): void {
    this.connectTimeout = value;
  }

  // Getter and setter for usingProtocol
  getUsingProtocol(): http.HttpProtocol | undefined {
    return this.usingProtocol;
  }

  setUsingProtocol(value: http.HttpProtocol | undefined): void {
    this.usingProtocol = value;
  }

  // Getter and setter for usingProxy
  getUsingProxy(): boolean | http.HttpProxy | undefined {
    return this.usingProxy;
  }

  setUsingProxy(value: boolean | http.HttpProxy | undefined): void {
    this.usingProxy = value;
  }

  // Getter and setter for caPath
  getCaPath(): string | undefined {
    return this.caPath;
  }

  setCaPath(value: string | undefined): void {
    this.caPath = value;
  }

  // Getter and setter for resumeFrom
  getResumeFrom(): number | undefined {
    return this.resumeFrom;
  }

  setResumeFrom(value: number | undefined): void {
    this.resumeFrom = value;
  }

  // Getter and setter for resumeTo
  getResumeTo(): number | undefined {
    return this.resumeTo;
  }

  setResumeTo(value: number | undefined): void {
    this.resumeTo = value;
  }

  // Getter and setter for clientCert
  getClientCert(): http.ClientCert | undefined {
    return this.clientCert;
  }

  setClientCert(value: http.ClientCert | undefined): void {
    this.clientCert = value;
  }

  // Getter and setter for dnsOverHttps
  getDnsOverHttps(): string | undefined {
    return this.dnsOverHttps;
  }

  setDnsOverHttps(value: string | undefined): void {
    this.dnsOverHttps = value;
  }

  // Getter and setter for dnsServers
  getDnsServers(): Array<string> | undefined {
    return this.dnsServers;
  }

  setDnsServers(value: Array<string> | undefined): void {
    this.dnsServers = value;
  }

  // Getter and setter for maxLimit
  getMaxLimit(): number | undefined {
    return this.maxLimit;
  }

  setMaxLimit(value: number | undefined): void {
    this.maxLimit = value;
  }

  // Getter and setter for multiFormDataList
  getMultiFormDataList(): Array<http.MultiFormData> | undefined {
    return this.multiFormDataList;
  }

  setMultiFormDataList(value: Array<http.MultiFormData> | undefined): void {
    this.multiFormDataList = value;
  }

  // Getter and setter for certificatePinning
  getCertificatePinning(): http.CertificatePinning | http.CertificatePinning[] | undefined {
    return this.certificatePinning;
  }

  setCertificatePinning(value: http.CertificatePinning | http.CertificatePinning[] | undefined): void {
    this.certificatePinning = value;
  }

  public build(): http.HttpRequestOptions {
    let jsonString = '{';
    this.header?.forEach((value, key) => {
      jsonString += `"${key}":"${value}",`;
    })
    jsonString = jsonString.slice(0, -1) + '}';

    return {
      method: this.method,
      extraData: this.extraData,
      expectDataType: this.expectDataType,
      usingCache: this.usingCache,
      priority: this.priority,
      header: JSON.parse(jsonString),
      readTimeout: this.readTimeout,
      connectTimeout: this.connectTimeout,
      usingProtocol: this.usingProtocol,
      usingProxy: this.usingProxy,
      caPath: this.caPath,
      resumeFrom: this.resumeFrom,
      resumeTo: this.resumeTo,
      clientCert: this.clientCert,
      dnsOverHttps: this.dnsOverHttps,
      dnsServers: this.dnsServers,
      maxLimit: this.maxLimit,
      multiFormDataList: this.multiFormDataList,
      certificatePinning: this.certificatePinning
    }
  }
}