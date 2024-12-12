export default class XPathException extends Error {
  private xpath: string;

  constructor(xpath: string, reason?: string, e?: Error) {
    if (reason) {
      super(`Exception occurred evaluating XPath: ${xpath} ${reason}`);
    } else if (e) {
      super(`Exception occurred evaluating XPath: ${xpath}. Exception: ${e.message}`);
    } else {
      super(`Exception occurred evaluating XPath: ${xpath}`);
    }
    this.xpath = xpath;
  }

  getXPath(): string {
    return this.xpath;
  }
}