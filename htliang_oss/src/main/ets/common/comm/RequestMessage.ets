import HttpMessage from './HttpMessage';
import { HttpMethod } from './HttpMethod';
import uri from '@ohos.uri'
import { WebServiceRequest } from '../../internal/model/WebServiceRequest';

export default class RequestMessage extends HttpMessage {
  constructor() {
    super();
  }

  /* bucket name */
  private _bucket: string = "";

  public set bucket(value: string) {
    this._bucket = value;
  }

  public get bucket(): string {
    return this._bucket;
  }

  /* object name */
  private _key: string = "";

  public set key(value: string) {
    this._key = value;
  }

  public get key(): string {
    return this._key;
  }

  /* The resource path being requested */
  private _resourcePath: string = "";

  public set resourcePath(value: string) {
    this._resourcePath = value;
  }

  public get resourcePath(): string {
    return this._resourcePath;
  }

  /* The service endpoint to which this request should be sent */
  private _endpoint: uri.URI | undefined;

  public set endpoint(value: uri.URI | undefined) {
    this._endpoint = value;
  }

  public get endpoint(): uri.URI | undefined {
    return this._endpoint;
  }

  /* The HTTP method to use when sending this request */
  private _method: HttpMethod = HttpMethod.GET;

  public set method(value: HttpMethod) {
    this._method = value;
  }

  public get method(): HttpMethod {
    return this._method;
  }

  /* Use a LinkedHashMap to preserve the insertion order. */
  private _parameters: Map<string, string> = new Map<string, string>();

  public set parameters(value: Map<string, string>) {
    this._parameters = value;
  }

  public get parameters(): Map<string, string> {
    return this._parameters;
  }

  public addParameter(key: string, value: string): void {
    this._parameters.set(key, value);
  }

  /* The absolute url to which the request should be sent */
  private _absoluteUrl: string = "";

  public set absoluteUrl(value: string) {
    this._absoluteUrl = value;
  }

  public get absoluteUrl(): string {
    return this._absoluteUrl;
  }

  /* Indicate whether using url signature */
  private _useUrlSignature: boolean = false;

  public set useUrlSignature(value: boolean) {
    this._useUrlSignature = value;
  }

  public get useUrlSignature(): boolean {
    return this._useUrlSignature;
  }

  /* Indicate whether using chunked encoding */
  private _useChunkEncoding: boolean = false;

  public set useChunkEncoding(value: boolean) {
    this._useChunkEncoding = value;
  }

  public get useChunkEncoding(): boolean {
    return this._useChunkEncoding;
  }

  private _originalRequest: WebServiceRequest | undefined;

  public set originalRequest(value: WebServiceRequest | undefined) {
    this._originalRequest = value;
  }

  public get originalRequest(): WebServiceRequest | undefined {
    return this._originalRequest;
  }
}