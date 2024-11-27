import HttpMessage from './HttpMessage';
import uri from '@ohos.uri'
import { WebServiceRequest } from '../../internal/model/WebServiceRequest';
import { http } from '@kit.NetworkKit';

export default class RequestMessage extends HttpMessage {
  private bucket?: string;
  private key?: string;
  private resourcePath?: string;
  private endpoint?: uri.URI;
  private method: http.RequestMethod = http.RequestMethod.GET;
  private parameters: Map<string, string> = new Map<string, string>();
  private absoluteUrl?: string;
  private useUrlSignature: boolean = false;
  private useChunkEncoding: boolean = false;
  private originalRequest?: WebServiceRequest;

  constructor() {
    super();
  }

  public setBucket(value: string | undefined) {
    this.bucket = value;
  }

  public getBucket(): string | undefined {
    return this.bucket;
  }

  public setKey(value: string | undefined) {
    this.key = value;
  }

  public getKey(): string | undefined {
    return this.key;
  }


  public setResourcePath(value: string | undefined) {
    this.resourcePath = value;
  }

  public getResourcePath(): string | undefined {
    return this.resourcePath;
  }


  public setEndpoint(value: uri.URI | undefined) {
    this.endpoint = value;
  }

  public getEndpoint(): uri.URI | undefined {
    return this.endpoint;
  }

  public setMethod(value: http.RequestMethod) {
    this.method = value;
  }

  public getMethod(): http.RequestMethod {
    return this.method;
  }

  public setParameters(value: Map<string, string>) {
    this.parameters = value;
  }

  public getParameters(): Map<string, string> {
    return this.parameters;
  }

  public addParameter(key: string, value: string): void {
    this.parameters.set(key, value);
  }

  public setAbsoluteUrl(value: string | undefined) {
    this.absoluteUrl = value;
  }

  public getAbsoluteUrl(): string | undefined {
    return this.absoluteUrl;
  }

  public setUseUrlSignature(value: boolean) {
    this.useUrlSignature = value;
  }

  public getUseUrlSignature(): boolean {
    return this.useUrlSignature;
  }

  public setUseChunkEncoding(value: boolean) {
    this.useChunkEncoding = value;
  }

  public getUseChunkEncoding(): boolean {
    return this.useChunkEncoding;
  }

  public setOriginalRequest(value: WebServiceRequest | undefined) {
    this.originalRequest = value;
  }

  public getOriginalRequest(): WebServiceRequest | undefined {
    return this.originalRequest;
  }

  public isRepeatable(): boolean {
    let content = this.getContent();
    return !content || content.markSupported();
  }
}