import RuntimeException from "./RuntimeException";

export default class IndexOutOfBoundsException extends RuntimeException {
  constructor(message?: string) {
    super(message);
    this.name = 'IndexOutOfBoundsException';
  }
}