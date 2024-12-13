import RuntimeException from "./RuntimeException";

export default class IllegalArgumentException extends RuntimeException {
  constructor(message?: string) {
    if (message) {
      super(message);
    } else {
      super();
    }

    this.name = 'IllegalArgumentException';
  }
}