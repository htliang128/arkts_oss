import ResponseMessage from '../comm/ResponseMessage';

export default interface ResponseParser<T> {
  /**
   * Converts the result from stream to a JavaScript object.
   *
   * @param response - The HTTP response message.
   * @returns The TypeScript type T object that the result stands for.
   * @throws Error - Failed to parse the result.
   */
  parse(response: ResponseMessage): T;
}