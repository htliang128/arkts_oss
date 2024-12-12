import Document from "../Document";
import SAXContentHandler from "./SAXContentHandler";

export default  class DocumentResult extends SAXResult {
  private contentHandler: SAXContentHandler;

  constructor();
  constructor(contentHandler: SAXContentHandler);
  constructor(contentHandler: SAXContentHandler = new SAXContentHandler()) {
    super();
    this.contentHandler = contentHandler;
    super.setHandler(this.contentHandler);
    super.setLexicalHandler(this.contentHandler);
  }

  public getDocument(): Document {
    return this.contentHandler.getDocument();
  }

  public setHandler(handler: ContentHandler): void {
    if (handler instanceof SAXContentHandler) {
      this.contentHandler = handler;
      super.setHandler(this.contentHandler);
    }
  }

  public setLexicalHandler(handler: LexicalHandler): void {
    if (handler instanceof SAXContentHandler) {
      this.contentHandler = handler;
      super.setLexicalHandler(this.contentHandler);
    }
  }
}