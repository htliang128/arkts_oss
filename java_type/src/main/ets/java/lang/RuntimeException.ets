export default class RuntimeException extends Error {
  constructor(message?: string) {
    if (message) {
      super(message);
    } else {
      super();
    }
    this.name = 'RuntimeException';
  }
}