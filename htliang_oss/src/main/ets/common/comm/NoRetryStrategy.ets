import RequestMessage from "./RequestMessage";
import ResponseMessage from "./ResponseMessage";
import RetryStrategy from "./RetryStrategy";

export default class NoRetryStrategy extends RetryStrategy {
  shouldRetry(ex: Error, request: RequestMessage, response: ResponseMessage, retries: number): boolean {
    return false;
  }
}