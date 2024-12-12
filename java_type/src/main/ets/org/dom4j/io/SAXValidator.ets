export default class SAXValidator {
  private xmlReader: XMLReader | null = null;
  private errorHandler: ErrorHandler | null = null;

  constructor();
  constructor(xmlReader: XMLReader);
  constructor(xmlReader?: XMLReader) {
    this.xmlReader = xmlReader || null;
  }

  public validate(document: Document): void {
    if (document) {
      const reader = this.getXMLReader();
      if (this.errorHandler) {
        reader.setErrorHandler(this.errorHandler);
      }

      try {
        reader.parse(new DocumentInputSource(document));
      } catch (error) {
        throw new Error("Caught an exception that should never happen: " + error);
      }
    }
  }

  public getXMLReader(): XMLReader {
    if (!this.xmlReader) {
      this.xmlReader = this.createXMLReader();
      this.configureReader();
    }

    return this.xmlReader;
  }

  public setXMLReader(reader: XMLReader): void {
    this.xmlReader = reader;
    this.configureReader();
  }

  public getErrorHandler(): ErrorHandler | null {
    return this.errorHandler;
  }

  public setErrorHandler(errorHandler: ErrorHandler): void {
    this.errorHandler = errorHandler;
  }

  protected createXMLReader(): XMLReader {
    return SAXHelper.createXMLReader(true);
  }

  protected configureReader(): void {
    const handler = this.xmlReader?.getContentHandler();
    if (!handler) {
      this.xmlReader?.setContentHandler(new DefaultHandler());
    }

    this.xmlReader?.setFeature("http://xml.org/sax/features/validation", true);
    this.xmlReader?.setFeature("http://xml.org/sax/features/namespaces", true);
    this.xmlReader?.setFeature("http://xml.org/sax/features/namespace-prefixes", false);
  }
}