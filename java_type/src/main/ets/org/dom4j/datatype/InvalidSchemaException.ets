export default class InvalidSchemaException extends IllegalArgumentException {
  constructor(reason: string) {
    super(reason);
    this.name = "InvalidSchemaException";
  }
}