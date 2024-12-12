export default  class InvalidXPathException extends Error {
  constructor(xpath: string, reason?: string) {
    super(`Invalid XPath expression: ${xpath}${reason ? ' ' + reason : ''}`);
  }
}