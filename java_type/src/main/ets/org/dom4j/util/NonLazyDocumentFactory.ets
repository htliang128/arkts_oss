export default  class NonLazyDocumentFactory extends DocumentFactory {
  protected static singleton: NonLazyDocumentFactory = new NonLazyDocumentFactory();

  constructor() {
    super();
  }

  public static getInstance(): DocumentFactory {
    return this.singleton;
  }

  public createElement(qname: QName): Element {
    return new NonLazyElement(qname);
  }
}
