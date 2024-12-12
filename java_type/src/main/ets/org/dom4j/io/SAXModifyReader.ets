export default class SAXModifyReader extends SAXReader {
  private xmlWriter: XMLWriter | null = null;
  private pruneElements: boolean = false;

  public constructor();
  public constructor(validating: boolean);
  public constructor(factory: DocumentFactory);
  public constructor(factory: DocumentFactory, validating: boolean);
  public constructor(xmlReader: XMLReader);
  public constructor(xmlReader: XMLReader, validating: boolean);
  public constructor(xmlReaderClassName: string);
  public constructor(xmlReaderClassName: string, validating: boolean);
  public constructor(arg?: any) {
    if (typeof arg === 'boolean') {
      super(arg);
    } else if (arg instanceof DocumentFactory) {
      super(arg);
    } else if (arg instanceof XMLReader) {
      super(arg);
    } else if (typeof arg === 'string') {
      super(arg);
    } else {
      super();
    }
  }

  public setXMLWriter(writer: XMLWriter): void {
    this.xmlWriter = writer;
  }

  public isPruneElements(): boolean {
    return this.pruneElements;
  }

  public setPruneElements(pruneElements: boolean): void {
    this.pruneElements = pruneElements;
  }

  protected createContentHandler(reader: XMLReader): SAXModifyContentHandler {
    const handler = new SAXModifyContentHandler(this.getDocumentFactory(), this.getDispatchHandler());
    handler.setXMLWriter(this.xmlWriter);
    return handler;
  }

  protected getXMLWriter(): XMLWriter | null {
    return this.xmlWriter;
  }
}