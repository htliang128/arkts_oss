export default class XMLResult extends SAXResult {
  private xmlWriter: XMLWriter;

  constructor();
  constructor(writer: Writer);
  constructor(writer: Writer, format: OutputFormat);
  constructor(out: OutputStream);
  constructor(out: OutputStream, format: OutputFormat);
  constructor(xmlWriter: XMLWriter);
  constructor(arg1?: any, arg2?: OutputFormat) {
    if (arg1 instanceof XMLWriter) {
      super(arg1);
      this.xmlWriter = arg1;
    } else if (arg1 instanceof Writer) {
      this.xmlWriter = arg2 ? new XMLWriter(arg1, arg2) : new XMLWriter(arg1);
      super(this.xmlWriter);
    } else if (arg1 instanceof OutputStream) {
      try {
        this.xmlWriter = arg2 ? new XMLWriter(arg1, arg2) : new XMLWriter(arg1);
        super(this.xmlWriter);
      } catch (e) {
        if (e instanceof UnsupportedEncodingException) {
          throw e;
        }
      }
    } else {
      this.xmlWriter = new XMLWriter();
      super(this.xmlWriter);
    }
    this.setLexicalHandler(this.xmlWriter);
  }

  public getXMLWriter(): XMLWriter {
    return this.xmlWriter;
  }

  public setXMLWriter(writer: XMLWriter): void {
    this.xmlWriter = writer;
    this.setHandler(this.xmlWriter);
    this.setLexicalHandler(this.xmlWriter);
  }

  public getHandler(): ContentHandler {
    return this.xmlWriter;
  }

  public getLexicalHandler(): LexicalHandler {
    return this.xmlWriter;
  }
}