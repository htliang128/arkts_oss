import InputStream from "@htliang/java_type/src/main/ets/java/io/InputStream";
import { TreeMap, uri } from "@kit.ArkTS";
import { http } from "@kit.NetworkKit";
import RequestMessage from "../common/comm/RequestMessage";
import { ServiceClient } from "../common/comm/SeviceClient";
import { WebServiceRequest } from "./model/WebServiceRequest";
import { OSSUtils } from "./OSSUtils";

export class OSSRequestMessageBuilder {
  private endpoint?: uri.URI;
  private method: http.RequestMethod = http.RequestMethod.GET;
  private bucket?: string;
  private key?: string;
  private headers: Map<string, string> = new Map();
  private parameters: Map<string, string> = new Map();
  private inputStream?: InputStream;
  private inputSize: number = 0;
  private innerClient?:ServiceClient;
  private useChunkEncoding: boolean = false;

  private originalRequest?: WebServiceRequest;

  constructor(innerClient: ServiceClient) {
    this.innerClient = innerClient;
  }

  setEndpoint(endpoint: uri.URI): OSSRequestMessageBuilder {
    this.endpoint = endpoint;
    return this;
  }

  setMethod(method: http.RequestMethod): OSSRequestMessageBuilder {
    this.method = method;
    return this;
  }

  setBucket(bucket: string): OSSRequestMessageBuilder {
    this.bucket = bucket;
    return this;
  }

  setKey(key: string): OSSRequestMessageBuilder {
    this.key = key;
    return this;
  }

  setHeaders(headers: Map<string, string>): OSSRequestMessageBuilder {
    this.headers = headers;
    return this;
  }

  addHeader(key: string, value: string): OSSRequestMessageBuilder {
    this.headers.set(key, value);
    return this;
  }

  setParameters(parameters: Map<string, string>): OSSRequestMessageBuilder {
    this.parameters = parameters;
    return this;
  }

  addParameter(key: string, value: string): OSSRequestMessageBuilder {
    this.parameters.set(key, value);
    return this;
  }

  setInputStream(inputStream: InputStream): OSSRequestMessageBuilder {
    this.inputStream = inputStream;
    return this;
  }

  setInputSize(inputSize: number): OSSRequestMessageBuilder {
    this.inputSize = inputSize;
    return this;
  }

  setUseChunkEncoding(useChunkEncoding: boolean): OSSRequestMessageBuilder {
    this.useChunkEncoding = useChunkEncoding;
    return this;
  }

  setOriginalRequest(originalRequest: any): OSSRequestMessageBuilder {
    this.originalRequest = originalRequest;
    return this;
  }

  build(): RequestMessage {
    let clientConfig = this.innerClient?.getClientConfiguration();
    let sentHeaders:TreeMap<string, string> = new TreeMap<string, string>(this.headers);
    let sentParameters:Map<string, string> = new Map<string, string>(this.parameters);

    return {
      originalRequest: this.originalRequest,
      bucket: this.bucket,
      key: this.key,
      endpoint: OSSUtils.determineFinalEndpoint(this.endpoint, this.bucket, clientConfig),
      resourcePath: OSSUtils.determineResourcePath(this.bucket, this.key, clientConfig?.isSLDEnabled()),
      headers: sentHeaders,
      parameters: sentParameters,
      method: this.method,
      content: this.inputStream,
      contentLength: this.inputSize,
      useChunkEncoding: this.inputSize === -1 ? true : this.useChunkEncoding,
    };
  }
}
