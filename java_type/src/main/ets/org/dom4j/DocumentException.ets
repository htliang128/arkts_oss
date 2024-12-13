import Throwable from "../../java/lang/Throwable";

export default class DocumentException extends Throwable {
  constructor();

  constructor(message: string);

  constructor(message: string, cause: Error)

  constructor(cause: Error);

  constructor(arg1?: string | Error, arg2?: Error) {
    if (!arg1) {
      super();
    } else if (!arg2) {
      if (typeof arg1 === 'string') {
        super(arg1);
      } else {
        super(arg1);
      }
    } else {
      super(arg1 as string, arg2);
    }

    this.name = 'DocumentException';
  }

  /** @deprecated */
  getNestedException(): Error | null {
    return null;
  }
}