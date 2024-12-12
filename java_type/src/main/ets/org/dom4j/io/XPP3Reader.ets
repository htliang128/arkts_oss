export default  class XPP3Reader {
  private factory: DocumentFactory | null = null;
  private xppParser: XmlPullParser | null = null;
  private xppFactory: XmlPullParserFactory | null = null;
  private dispatchHandler: DispatchHandler | null = null;

  constructor();
  constructor(factory: DocumentFactory);
  constructor(factory?: DocumentFactory) {
    this.factory = factory || null;
  }

  public read(file: File): Promise<Document> {
    const systemID = file.getAbsolutePath();
    return this.read(new BufferedReader(new FileReader(file)), systemID);
  }

  public read(url: URL): Promise<Document> {
    const systemID = url.toExternalForm();
    return this.read(this.createReader(url.openStream()), systemID);
  }

  public read(systemID: string): Promise<Document> {
    return systemID.indexOf(':') >= 0 ? this.read(new URL(systemID)) : this.read(new File(systemID));
  }

  public read(inStream: InputStream): Promise<Document> {
    return this.read(this.createReader(inStream));
  }

  public read(reader: Reader): Promise<Document> {
    this.getXPPParser().setInput(reader);
    return this.parseDocument();
  }

  public read(text: char[]): Promise<Document> {
    this.getXPPParser().setInput(new CharArrayReader(text));
    return this.parseDocument();
  }

  public read(inStream: InputStream, systemID: string): Promise<Document> {
    return this.read(this.createReader(inStream), systemID);
  }

  public read(reader: Reader, systemID: string): Promise<Document> {
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
    this.xppFactory.setNamespaceAware(true);
    return this.xppFactory;
  }

  public setXPPFactory(xPPfactory: XmlPullParserFactory): void {
    this.xppFactory = xPPfactory;
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

  protected parseDocument(): Promise<Document> {
    const df = this.getDocumentFactory();
    const document = df.createDocument();
    let parent: Element | null = null;
    const pp = this.getXPPParser();
    pp.setFeature("http://xmlpull.org/v1/doc/features.html#process-namespaces", true);

    while (true) {
      const type = pp.nextToken();
      let text: string;

      switch (type) {
        case 1:
          return document;
        case 2:
          const qname = pp.getPrefix() == null ? df.createQName(pp.getName(), pp.getNamespace()) : df.createQName(pp.getName(), pp.getPrefix(), pp.getNamespace());
          const newElement = df.createElement(qname);
          const nsStart = pp.getNamespaceCount(pp.getDepth() - 1);
          const nsEnd = pp.getNamespaceCount(pp.getDepth());

          for (let i = nsStart; i < nsEnd; ++i) {
            if (pp.getNamespacePrefix(i) != null) {
              newElement.addNamespace(pp.getNamespacePrefix(i), pp.getNamespaceUri(i));
            }
          }

          for (let i = 0; i < pp.getAttributeCount(); ++i) {
            const qa = pp.getAttributePrefix(i) == null ? df.createQName(pp.getAttributeName(i)) : df.createQName(pp.getAttributeName(i), pp.getAttributePrefix(i), pp.getAttributeNamespace(i));
            newElement.addAttribute(qa, pp.getAttributeValue(i));
          }

          if (parent != null) {
            parent.add(newElement);
          } else {
            document.add(newElement);
          }

          parent = newElement;
          break;
        case 3:
          if (parent != null) {
            parent = parent.getParent();
          }
          break;
        case 4:
          text = pp.getText();
          if (parent == null) {
            throw new DocumentException("Cannot have text content outside of the root document");
          }
          parent.addText(text);
          break;
        case 5:
          if (parent == null) {
            throw new DocumentException("Cannot have text content outside of the root document");
          }
          parent.addCDATA(pp.getText());
          break;
        case 6:
        case 7:
        default:
          break;
        case 8:
          text = pp.getText();
          const loc = text.indexOf(" ");
          if (loc >= 0) {
            const target = text.substring(0, loc);
            const txt = text.substring(loc + 1);
            document.addProcessingInstruction(target, txt);
          } else {
            document.addProcessingInstruction(text, "");
          }
          break;
        case 9:
          if (parent != null) {
            parent.addComment(pp.getText());
          } else {
            document.addComment(pp.getText());
          }
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