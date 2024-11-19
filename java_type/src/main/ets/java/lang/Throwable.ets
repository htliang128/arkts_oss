export default class Throwable extends Error {
  private detailMessage: string;
  private cause?: Error;

  constructor();

  constructor(message: string);

  constructor(throwable: Error);

  constructor(message: string, throwable: Error);

  constructor(arg1?: string | Error, throwable?: Error) {
    if (!arg1) {
      super();
      this.detailMessage = '';
      return;
    }
    if (typeof arg1 !== 'string') {
      super();
      this.cause = arg1;
      this.detailMessage = '';
      this.stack = arg1.stack;
      return;
    }
    super(arg1);
    this.detailMessage = arg1;
    this.cause = throwable;
    this.stack = throwable?.stack;
  }

  public getDetailMessage(): string {
    return this.detailMessage;
  }

  public getCause(): Error | undefined {
    return this.cause;
  }
}