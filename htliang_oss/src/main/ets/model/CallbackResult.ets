import InputStream from '@htliang/java_type/src/main/ets/java/io/InputStream';
import fs from '@ohos.file.fs';

export default interface CallbackResult {
  /**
   * Gets the response body of the callback request.
   *
   * @returns The ReadableStream instance of the response body.
   */
  getCallbackResponseBody(): InputStream | undefined;

  /**
   * Sets the callback response body.
   *
   * @param callbackResponseBody The ReadableStream instance of the response body.
   */
  setCallbackResponseBody(callbackResponseBody: InputStream): void;
}