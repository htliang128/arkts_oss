export default  class JAXBRuntimeException extends Error {
  constructor(cause: Error) {
    super(cause.message);
    this.name = "JAXBRuntimeException";
    Object.setPrototypeOf(this, JAXBRuntimeException.prototype);
  }
}
