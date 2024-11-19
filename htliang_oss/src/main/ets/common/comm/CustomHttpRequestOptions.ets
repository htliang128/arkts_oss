import { http } from "@kit.NetworkKit";
import { TreeMap } from "@kit.ArkTS";

export default class CustomHttpRequestOptions implements http.HttpRequestOptions {
  constructor() {
  }

  private _method?: http.RequestMethod | undefined;

  public set method(value: http.RequestMethod | undefined) {
    this._method = value;
  }

  public get method(): http.RequestMethod | undefined {
    return this._method;
  }

  private _extraData?: string | Object | ArrayBuffer | undefined;

  public set extraData(value: string | Object | ArrayBuffer | undefined) {
    this._extraData = value;
  }

  public get extraData(): string | Object | ArrayBuffer | undefined {
    return this._extraData;
  }

  private _expectDataType?: http.HttpDataType | undefined;

  public set expectDataType(value: http.HttpDataType | undefined) {
    this._expectDataType = value;
  }

  public get expectDataType(): http.HttpDataType | undefined {
    return this._expectDataType;
  }

  private _usingCache?: boolean | undefined;

  public set usingCache(value: boolean | undefined) {
    this._usingCache = value;
  }

  public get usingCache(): boolean | undefined {
    return this._usingCache;
  }

  private _priority?: number | undefined;

  public set priority(value: number | undefined) {
    this._priority = value;
  }

  public get priority(): number | undefined {
    return this._priority;
  }

  private _header?: TreeMap<string, string> | undefined;

  public set header(value: TreeMap<string, string> | undefined) {
    this._header = value;
  }

  public get header(): TreeMap<string, string> | undefined {
    return this._header;
  }

  private _readTimeout?: number | undefined;

  public set readTimeout(value: number | undefined) {
    this._readTimeout = value;
  }

  public get readTimeout(): number | undefined {
    return this._readTimeout;
  }

  private _connectTimeout?: number | undefined;

  public set connectTimeout(value: number | undefined) {
    this._connectTimeout = value;
  }

  public get connectTimeout(): number | undefined {
    return this._connectTimeout;
  }

  private _usingProtocol?: http.HttpProtocol | undefined;

  public set usingProtocol(value: http.HttpProtocol | undefined) {
    this._usingProtocol = value;
  }

  public get usingProtocol(): http.HttpProtocol | undefined {
    return this._usingProtocol;
  }

  private _usingProxy?: boolean | http.HttpProxy | undefined;

  public set usingProxy(value: boolean | http.HttpProxy | undefined) {
    this._usingProxy = value;
  }

  public get usingProxy(): boolean | http.HttpProxy | undefined {
    return this._usingProxy;
  }

  private _caPath?: string | undefined;

  public set caPath(value: string | undefined) {
    this._caPath = value;
  }

  public get caPath(): string | undefined {
    return this._caPath;
  }

  private _resumeFrom?: number | undefined;

  public set resumeFrom(value: number | undefined) {
    this._resumeFrom = value;
  }

  public get resumeFrom(): number | undefined {
    return this._resumeFrom;
  }

  private _resumeTo?: number | undefined;

  public set resumeTo(value: number | undefined) {
    this._resumeTo = value;
  }

  public get resumeTo(): number | undefined {
    return this._resumeTo;
  }

  private _clientCert?: http.ClientCert | undefined;

  public set clientCert(value: http.ClientCert | undefined) {
    this._clientCert = value;
  }

  public get clientCert(): http.ClientCert | undefined {
    return this._clientCert;
  }

  private _dnsOverHttps?: string | undefined;

  public set dnsOverHttps(value: string | undefined) {
    this._dnsOverHttps = value;
  }

  public get dnsOverHttps(): string | undefined {
    return this._dnsOverHttps;
  }

  private _dnsServers?: Array<string> | undefined;

  public set dnsServers(value: Array<string> | undefined) {
    this._dnsServers = value;
  }

  public get dnsServers(): Array<string> | undefined {
    return this._dnsServers;
  }

  private _maxLimit?: number | undefined;

  public set maxLimit(value: number | undefined) {
    this._maxLimit = value;
  }

  public get maxLimit(): number | undefined {
    return this._maxLimit;
  }

  private _multiFormDataList?: Array<http.MultiFormData> | undefined;

  public set multiFormDataList(value: Array<http.MultiFormData> | undefined) {
    this._multiFormDataList = value;
  }

  public get multiFormDataList(): Array<http.MultiFormData> | undefined {
    return this._multiFormDataList;
  }

  private _certificatePinning?: http.CertificatePinning | http.CertificatePinning[] | undefined;

  public set certificatePinning(value: http.CertificatePinning | http.CertificatePinning[] | undefined) {
    this._certificatePinning = value;
  }

  public get certificatePinning(): http.CertificatePinning | http.CertificatePinning[] | undefined {
    return this._certificatePinning;
  }
}