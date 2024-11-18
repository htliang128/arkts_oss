import Throwable from "./Throwable";

export default class RuntimeException extends Throwable {
  constructor();

  constructor(message: string);

  constructor(throwable: Error);

  constructor(message: string, throwable: Error);

  constructor(arg1?: string | Error, throwable?: Error) {
    if (!arg1) {
      super();
    } else if (typeof arg1 !== 'string') {
      super(arg1);
    } else if (!throwable) {
      super(arg1);
    } else {
      super(arg1, throwable);
    }

    this.name = 'RuntimeException';
  }
}