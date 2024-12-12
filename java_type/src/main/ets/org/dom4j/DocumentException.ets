export default  class DocumentException extends Error {
  constructor(message?: string, public readonly cause?: Error) {
    super(message); // 'Error' breaks prototype chain here
    Object.setPrototypeOf(this, DocumentException.prototype);
  }

  /** @deprecated */
  getNestedException(): Error | null {
    return null;
  }
}