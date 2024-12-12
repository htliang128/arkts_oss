export default class DocumentSource extends SAXSource {
  public static readonly DOM4J_FEATURE = "http://org.dom4j.io.DocumentSource/feature";
  private xmlReader: XMLReader = new SAXWriter();

  constructor(nodeOrDocument: Node | Document) {
    super();
    if ('getDocument' in nodeOrDocument) {
      this.setDocument(nodeOrDocument.getDocument());
    } else {
      this.setDocument(nodeOrDocument);
    }
  }

  getDocument(): Document {
    const source = this.getInputSource() as DocumentInputSource;
    return source.getDocument();
  }

  setDocument(document: Document): void {
    super.setInputSource(new DocumentInputSource(document));
  }

  getXMLReader(): XMLReader {
    return this.xmlReader;
  }

  setInputSource(inputSource: InputSource): void {
    if (inputSource instanceof DocumentInputSource) {
      super.setInputSource(inputSource);
    } else {
      throw new UnsupportedOperationException();
    }
  }

  setXMLReader(reader: XMLReader): void {
    if (reader instanceof SAXWriter) {
      this.xmlReader = reader;
    } else if (reader instanceof XMLFilter) {
      let filter: XMLFilter = reader;

      while (true) {
        const parent = filter.getParent();
        if (!(parent instanceof XMLFilter)) {
          filter.setParent(this.xmlReader);
          this.xmlReader = filter;
          break;
        }

        filter = parent as XMLFilter;
      }
    } else {
      throw new UnsupportedOperationException();
    }
  }
}