import RuntimeException from "./RuntimeException";

export default class IndexOutOfBoundsException extends RuntimeException {
  constructor(message?: string) {
    if (message) {
      super(message);
    } else {
      super();
    }

    this.name = 'IndexOutOfBoundsException';
  }
}