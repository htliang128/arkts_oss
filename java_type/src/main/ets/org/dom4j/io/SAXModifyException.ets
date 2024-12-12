export default class SAXModifyException extends Error {
  constructor(cause: Error) {
    super(cause.message);
    this.name = "SAXModifyException";
    // Preserve the original stack trace
    if (Error.captureStackTrace) {
      Error.captureStackTrace(this, SAXModifyException);
    }
  }
}