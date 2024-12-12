export default  class UserDataDocumentFactory extends DocumentFactory {
  private static singleton: UserDataDocumentFactory = new UserDataDocumentFactory();

  private constructor() {
    super();
  }

  public static getInstance(): DocumentFactory {
    return this.singleton;
  }

  public createElement(qname: QName): Element {
    return new UserDataElement(qname);
  }

  public createAttribute(owner: Element, qname: QName, value: string): Attribute {
    return new UserDataAttribute(qname, value);
  }
}