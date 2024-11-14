import IOException from '@htliang/java_type/src/main/ets/java/io/IOException';
import ClientConfiguration from '../../ClientConfiguration';
import ClientException from '../../ClientException';
import OSSConstants from '../../internal/OSSConstants';
import CodingUtils from '../utils/CodingUtils';
import LogUtils from '../utils/LogUtils';
import { ExecutionContext } from './ExecutionContext';
import HttpMessage from './HttpMessage';
import { HttpMethod } from './HttpMethod';
import RequestMessage from './RequestMessage';
import ResponseMessage from './ResponseMessage';
import RetryStrategy from './RetryStrategy';

export abstract class ServiceClient {
  private clientConfiguration: ClientConfiguration;

  public getClientConfiguration(): ClientConfiguration {
    return this.clientConfiguration;
  }

  constructor(clientConfiguration: ClientConfiguration) {
    this.clientConfiguration = clientConfiguration;
  }

  public sendRequest(request: RequestMessage, context: ExecutionContext): ResponseMessage {
    CodingUtils.assertParameterNotNull(request, "request");
    CodingUtils.assertParameterNotNull(context, "context");

    try {
      return this.sendRequestImpl(request, context);
    } finally {
      // Close the request stream as well after the request is completed.
      try {
        request.close();
      } catch (err) {
        console.error(err)
        throw new ClientException("Unexpected io exception when trying to close http request: " + err)
      }
    }
  }

  public sendRequestImpl(request: RequestMessage, context: ExecutionContext) {
    let retryStrategy:RetryStrategy = context.getRetryStrategy() ?? this.getDefaultRetryStrategy();
    // Sign the request if a signer provided.
    if (context.getSigner() && !request.useUrlSignature) {
      context.getSigner()?.sign(request);
    }

    let signers = context.getSignerHandlers();
    signers.forEach(signer=>{
      signer.sign(request);
    })

    let requestContent = request.content;
    if (requestContent && requestContent.markSupported()) {
      requestContent.mark(OSSConstants.DEFAULT_STREAM_BUFFER_SIZE);
    }

    let retries = 0;
    let response :ResponseMessage |undefined = undefined;

    while (true) {
      try {
        if (retries > 0) {
          this.pause(retries, retryStrategy);
          if (requestContent && requestContent.markSupported()) {
            try {
              requestContent.reset();
              request.content = requestContent;
            } catch (e) {
              if (e instanceof IOException) {
                LogUtils.logException("Failed to reset the request input stream: ", e);
                throw new ClientException("Failed to reset the request input stream: ", ex);
              }
            }
          }
        }
      }
    }

  }

  public getDefaultRetryStrategy():RetryStrategy {

  }
}

export namespace ServiceClient {
  export class Request extends HttpMessage {
    private uri: string = '';
    private method: HttpMethod = HttpMethod.POST;
    private useUrlSignature: boolean = false;
    private useChunkEncoding: boolean = false;

    public getUri(): string {
      return this.uri;
    }

    public setUrl(uri: string): void {
      this.uri = uri;
    }

    public getMethod(): HttpMethod {
      return this.method;
    }

    public setMethod(method: HttpMethod): void {
      this.method = method;
    }

    public isUseUrlSignature(): boolean {
      return this.useUrlSignature;
    }

    public setUseUrlSignature(useUrlSignature: boolean): void {
      this.useUrlSignature = useUrlSignature;
    }

    public isUseChunkEncoding(): boolean {
      return this.useChunkEncoding;
    }

    public setUseChunkEncoding(useChunkEncoding: boolean): void {
      this.useChunkEncoding = useChunkEncoding;
    }
  }
}