export default  class FlyweightAttribute extends AbstractAttribute {
  private qname: QName;
  protected value: string;

  constructor(qname: QName);
  constructor(qname: QName, value: string);
  constructor(name: string, value: string);
  constructor(name: string, value: string, namespace: Namespace);
  constructor(nameOrQname: string | QName, value?: string, namespace?: Namespace) {
    super();
    if (typeof nameOrQname === "string") {
      this.qname = this.getDocumentFactory().createQName(nameOrQname, namespace);
    } else {
      this.qname = nameOrQname;
    }
    this.value = value || "";
  }

  getValue(): string {
    return this.value;
  }

  getQName(): QName {
    return this.qname;
  }

  // Assuming getDocumentFactory() is a method in AbstractAttribute
  // You need to define it according to your needs
  protected getDocumentFactory(): any {
    // Method implementation goes here
  }
}