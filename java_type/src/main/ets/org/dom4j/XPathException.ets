import RuntimeException from "../../java/lang/RuntimeException";

export default class XPathException extends RuntimeException {
  private xpath: string;

  constructor(xpath: string);

  constructor(xpath: string, reason: string);

  constructor(xpath: string, e: Error);

  constructor(xpath: string, arg?: string | Error) {
    if (!arg) {
      super(`Exception occurred evaluating XPath: ${xpath}`);
    } else if (typeof arg === 'string') {
      super(`Exception occurred evaluating XPath: ${xpath} ${arg}`);
    } else {
      super(`Exception occurred evaluating XPath: ${xpath}. Exception: ${arg.message}`);
    }
    this.xpath = xpath;
  }

  getXPath(): string {
    return this.xpath;
  }
}