import RuntimeException from "./RuntimeException";

export default class NullPointerException extends RuntimeException {
  constructor(message?:string) {
    if (message) {
      super(message);
    } else {
      super();
    }
    this.name = 'NullPointerException';
  }
}