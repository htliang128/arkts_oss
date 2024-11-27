import InputStream from "@htliang/java_type/src/main/ets/java/io/InputStream";
import { TreeMap, uri } from "@kit.ArkTS";
import { http } from "@kit.NetworkKit";
import ClientException from "../ClientException";
import RequestMessage from "../common/comm/RequestMessage";
import { ServiceClient } from "../common/comm/SeviceClient";
import { WebServiceRequest } from "./model/WebServiceRequest";
import { OSSUtils } from "./OSSUtils";

export class OSSRequestMessageBuilder {
  private endpoint?: uri.URI;
  private method: http.RequestMethod = http.RequestMethod.GET;
  private bucket?: string;
  private key?: string;
  private headers: TreeMap<string, string> = new TreeMap();
  private parameters: TreeMap<string, string> = new TreeMap();
  private inputStream?: InputStream;
  private inputSize: number = 0;
  private innerClient?: ServiceClient;
  private useChunkEncoding: boolean = false;
  private originalRequest?: WebServiceRequest;

  constructor(innerClient: ServiceClient) {
    this.innerClient = innerClient;
  }

  setEndpoint(endpoint: uri.URI | undefined): OSSRequestMessageBuilder {
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

  setHeaders(headers: TreeMap<string, string>): OSSRequestMessageBuilder {
    this.headers = headers;
    return this;
  }

  addHeader(key: string, value: string): OSSRequestMessageBuilder {
    this.headers.set(key, value);
    return this;
  }

  setParameters(parameters: TreeMap<string, string>): OSSRequestMessageBuilder {
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

  setOriginalRequest(originalRequest: WebServiceRequest): OSSRequestMessageBuilder {
    this.originalRequest = originalRequest;
    return this;
  }

  build(): RequestMessage {
    if (!this.endpoint) {
      throw new ClientException('Endpoint cannot be undefined.');
    }
    if (!this.bucket) {
      throw new ClientException('Bucket cannot be undefined.');
    }
    if (!this.key) {
      throw new ClientException('Key cannot be undefined.');
    }
    if (!this.innerClient) {
      throw new ClientException('InnerClient cannot be undefined.');
    }

    let clientConfig = this.innerClient?.getClientConfiguration();
    let sentHeaders: TreeMap<string, string> = new TreeMap<string, string>();
    this.headers.forEach((value, key) => sentHeaders.set(key, value));
    let sentParameters: TreeMap<string, string> = new TreeMap<string, string>();
    sentParameters.setAll(this.parameters);

    let message = new RequestMessage();
    message.setOriginalRequest(this.originalRequest);
    message.setBucket(this.bucket);
    message.setKey(this.key);
    message.setEndpoint(OSSUtils.determineFinalEndpoint(this.endpoint, this.bucket, clientConfig));
    message.setResourcePath(OSSUtils.determineResourcePath(this.bucket, this.key, clientConfig?.isSLDEnabled()));
    message.setHeaders(sentHeaders);
    message.setParameters(sentParameters);
    message.setMethod(this.method);
    message.setContent(this.inputStream);
    message.setContentLength(this.inputSize);
    message.setUseChunkEncoding(this.inputSize === -1 ? true : this.useChunkEncoding);

    return message;
  }
}
