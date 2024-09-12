import RetryStrategy from './RetryStrategy';
import Credentials from '../auth/Credentials';
import OSSConstants from '../../internal/OSSConstants';
import RequestHandler from './RequestHandler';
import { RequestSigner } from '../auth/RequestSigner';
import ResponseHandler from './ResponseHandler';


export class ExecutionContext {
  private signer: RequestSigner | undefined;
  private requestHandlers: RequestHandler[] = [];
  private responseHandlers: ResponseHandler[] = [];
  private signerHandlers: RequestSigner[] = [];
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

  public getResponseHandlers(): ResponseHandler[] {
    return this.responseHandlers;
  }

  public addResponseHandler(handler: ResponseHandler): void {
    this.responseHandlers.push(handler);
  }

  // Similar methods for inserting and removing response handlers

  public getRequestHandlers(): RequestHandler[] {
    return this.requestHandlers;
  }

  // Similar methods for adding, inserting, and removing request handlers

  public getSignerHandlers(): RequestSigner[] {
    return this.signerHandlers;
  }

  // Similar methods for adding, inserting, and removing signer handlers

  public getCredentials(): Credentials | undefined {
    return this.credentials;
  }

  public setCredentials(credentials: Credentials): void {
    this.credentials = credentials;
  }
}
