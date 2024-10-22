import ClientConfiguration from '../../ClientConfiguration';
import CodingUtils from '../utils/CodingUtils';
import { ExecutionContext } from './ExecutionContext';
import { HttpMethod } from './HttpMethod';
import RequestMessage from './RequestMessage';
import ResponseMessage from './ResponseMessage';

export abstract class ServiceClient {
  private clientConfiguration: ClientConfiguration;

  public getClientConfiguration(): ClientConfiguration {
    return this.clientConfiguration;
  }

  constructor(clientConfiguration: ClientConfiguration) {
    this.clientConfiguration = clientConfiguration;
  }

  //   public sendRequest(request: RequestMessage, context: ExecutionContext): ResponseMessage {
  //
  //     CodingUtils.assertParameterNotNull(request, "request");
  //     CodingUtils.assertParameterNotNull(context, "context");
  //
  //     try {
  //       return this.sendRequestImpl(request, context);
  //     } finally {
  //       // Close the request stream as well after the request is completed.
  //       try {
  //         request.close();
  //       } catch (err) {
  //         console.error(err)
  //         throw new Error("Unexpected io exception when trying to close http request: "+ err)
  //       }
  //     }
  //   }
}


export class Request {
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