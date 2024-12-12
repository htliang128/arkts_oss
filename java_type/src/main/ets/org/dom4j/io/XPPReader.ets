export default class XPPReader {
  private factory: DocumentFactory | null = null;
  private xppParser: XmlPullParser | null = null;
  private xppFactory: XmlPullParserFactory | null = null;
  private dispatchHandler: DispatchHandler | null = null;

  constructor(factory?: DocumentFactory) {
    this.factory = factory || null;
  }

  public read(file: File): Document {
    const systemID = file.getAbsolutePath();
    return this.read(new BufferedReader(new FileReader(file)), systemID);
  }

  public read(url: URL): Document {
    const systemID = url.toExternalForm();
    return this.read(this.createReader(url.openStream()), systemID);
  }

  public read(systemID: string): Document {
    return systemID.indexOf(':') >= 0 ? this.read(new URL(systemID)) : this.read(new File(systemID));
  }

  public read(inStream: InputStream): Document {
    return this.read(this.createReader(inStream));
  }

  public read(reader: Reader): Document {
    this.getXPPParser().setInput(reader);
    return this.parseDocument();
  }

  public read(text: char[]): Document {
    this.getXPPParser().setInput(text);
    return this.parseDocument();
  }

  public read(inStream: InputStream, systemID: string): Document {
    return this.read(this.createReader(inStream), systemID);
  }

  public read(reader: Reader, systemID: string): Document {
    const document = this.read(reader);
    document.setName(systemID);
    return document;
  }

  public getXPPParser(): XmlPullParser {
    if (this.xppParser === null) {
      this.xppParser = this.getXPPFactory().newPullParser();
    }
    return this.xppParser;
  }

  public getXPPFactory(): XmlPullParserFactory {
    if (this.xppFactory === null) {
      this.xppFactory = XmlPullParserFactory.newInstance();
    }
    return this.xppFactory;
  }

  public setXPPFactory(xppFactory: XmlPullParserFactory): void {
    this.xppFactory = xppFactory;
  }

  public getDocumentFactory(): DocumentFactory {
    if (this.factory === null) {
      this.factory = DocumentFactory.getInstance();
    }
    return this.factory;
  }

  public setDocumentFactory(documentFactory: DocumentFactory): void {
    this.factory = documentFactory;
  }

  public addHandler(path: string, handler: ElementHandler): void {
    this.getDispatchHandler().addHandler(path, handler);
  }

  public removeHandler(path: string): void {
    this.getDispatchHandler().removeHandler(path);
  }

  public setDefaultHandler(handler: ElementHandler): void {
    this.getDispatchHandler().setDefaultHandler(handler);
  }

  protected parseDocument(): Document {
    const document = this.getDocumentFactory().createDocument();
    let parent: Element | null = null;
    const parser = this.getXPPParser();
    parser.setNamespaceAware(true);
    const startTag = new ProxyXmlStartTag();
    const endTag = this.xppFactory.newEndTag();

    while (true) {
      const type = parser.next();
      switch (type) {
        case 1:
          return document;
        case 2:
          parser.readStartTag(startTag);
          const newElement = startTag.getElement();
          if (parent) {
            parent.add(newElement);
          } else {
            document.add(newElement);
          }
          parent = newElement;
          break;
        case 3:
          parser.readEndTag(endTag);
          if (parent) {
            parent = parent.getParent();
          }
          break;
        case 4:
          const text = parser.readContent();
          if (parent === null) {
            throw new DocumentException("Cannot have text content outside of the root document");
          }
          parent.addText(text);
          break;
        default:
          throw new DocumentException(`Error: unknown type: ${type}`);
      }
    }
  }

  protected getDispatchHandler(): DispatchHandler {
    if (this.dispatchHandler === null) {
      this.dispatchHandler = new DispatchHandler();
    }
    return this.dispatchHandler;
  }

  protected setDispatchHandler(dispatchHandler: DispatchHandler): void {
    this.dispatchHandler = dispatchHandler;
  }

  protected createReader(inStream: InputStream): Reader {
    return new BufferedReader(new InputStreamReader(inStream));
  }
}