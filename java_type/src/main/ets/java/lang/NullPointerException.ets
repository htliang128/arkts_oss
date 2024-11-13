import RuntimeException from "./RuntimeException";

export default class NullPointerException extends RuntimeException {
  constructor(message?:string) {
    super(message);
    this.name = 'NullPointerException';
  }
}