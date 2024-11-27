import RetryStrategy from './RetryStrategy';
import Credentials from '../auth/Credentials';
import OSSConstants from '../../internal/OSSConstants';
import RequestHandler from './RequestHandler';
import { RequestSigner } from '../auth/RequestSigner';
import ResponseHandler from './ResponseHandler';
import { LinkedList } from '@kit.ArkTS';


export class ExecutionContext {
  private signer: RequestSigner | undefined;
  private requestHandlers: LinkedList<RequestHandler> = new LinkedList();
  private responseHandlers: LinkedList<ResponseHandler> = new LinkedList();
  private signerHandlers: LinkedList<RequestSigner> = new LinkedList();
  private charset: string = OSSConstants.DEFAULT_CHARSET_NAME;
  private retryStrategy: RetryStrategy | undefined;
  private credentials: Credentials | undefined;

  public getRetryStrategy(): RetryStrategy | undefined {
    return this.retryStrategy;
  }

  public setRetryStrategy(retryStrategy: RetryStrategy): void {
    this.retryStrategy = retryStrategy;
  }

  public getCharset(): string {
    return this.charset;
  }

  public setCharset(charset: string): void {
    this.charset = charset;
  }

  public getSigner(): RequestSigner | undefined {
    return this.signer;
  }

  public setSigner(signer: RequestSigner): void {
    this.signer = signer;
  }

  public getResponseHandlers(): LinkedList<ResponseHandler> {
    return this.responseHandlers;
  }

  public addResponseHandler(handler: ResponseHandler): void {
    this.responseHandlers.add(handler);
  }

  public insertResponseHandler(position: number, handler: ResponseHandler): void {
    this.responseHandlers.insert(position, handler);
  }

  public removeResponseHandler(handler: ResponseHandler): void {
    this.responseHandlers.remove(handler);
  }

  public getRequestHandlers(): LinkedList<RequestHandler> {
    return this.requestHandlers;
  }

  public addRequestHandlers(handler: RequestHandler): void {
    this.requestHandlers.add(handler);
  }

  public insertRequestHandler(position: number, handler: RequestHandler): void {
    this.requestHandlers.insert(position, handler);
  }

  public removeRequestHandler(handler: RequestHandler): void {
    this.requestHandlers.remove(handler);
  }

  public getSignerHandlers(): LinkedList<RequestSigner> {
    return this.signerHandlers;
  }

  public addSignerHandler(handler: RequestSigner): void {
    this.signerHandlers.add(handler);
  }

  public insertSignerHandler(position: number, handler: RequestSigner): void {
    this.signerHandlers.insert(position, handler);
  }

  public removeSignerHandler(handler: RequestSigner): void {
    this.signerHandlers.remove(handler);
  }

  public getCredentials(): Credentials | undefined {
    return this.credentials;
  }

  public setCredentials(credentials: Credentials): void {
    this.credentials = credentials;
  }
}
