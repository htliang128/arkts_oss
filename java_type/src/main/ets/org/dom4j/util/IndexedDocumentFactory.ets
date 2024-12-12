export default  class IndexedDocumentFactory extends DocumentFactory {
  protected static singleton: IndexedDocumentFactory = new IndexedDocumentFactory();

  constructor() {
    super();
  }

  public static getInstance(): DocumentFactory {
    return this.singleton;
  }

  public createElement(qname: QName): Element {
    return new IndexedElement(qname);
  }

  public createElement(qname: QName, attributeCount: number): Element {
    return new IndexedElement(qname, attributeCount);
  }
}