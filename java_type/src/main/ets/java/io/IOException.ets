import Throwable from "../lang/Throwable";

export default class IOException extends Throwable {
  constructor(message?: string) {
    if (message) {
      super(message);
    } else {
      super();
    }
    this.name = 'IOException';
  }
}