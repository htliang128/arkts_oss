export default class IOException extends Error {
  constructor(message?: string) {
    if (message) {
      super(message);
    } else {
      super();
    }
    this.name = 'IOException';
  }
}