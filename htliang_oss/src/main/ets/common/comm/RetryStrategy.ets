import RequestMessage from './RequestMessage';
import ResponseMessage from './ResponseMessage';

export default abstract class RetryStrategy {
  private static readonly DEFAULT_RETRY_PAUSE_SCALE: number = 300;

  // milliseconds.

  abstract shouldRetry(ex: Error, request: RequestMessage, response: ResponseMessage, retries: number): boolean;

  getPauseDelay(retries: number): number {
    // make the pause time increase exponentially
    // based on an assumption that the more times it retries,
    // the less probability it succeeds.
    const scale: number = RetryStrategy.DEFAULT_RETRY_PAUSE_SCALE;
    const delay: number = Math.pow(2, retries) * scale;

    return delay;
  }
}