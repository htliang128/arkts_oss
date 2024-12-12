import QName from "../QName";

export default class DatatypeElementFactory extends DocumentFactory {
  private elementQName: QName;
  private attributeXSDatatypes: Map<QName, XSDatatype> = new Map<QName, XSDatatype>();
  private childrenXSDatatypes: Map<QName, XSDatatype> = new Map<QName, XSDatatype>();

  constructor(elementQName: QName) {
    super();
    this.elementQName = elementQName;
  }

  getQName(): QName {
    return this.elementQName;
  }

  getAttributeXSDatatype(attributeQName: QName): XSDatatype | undefined {
    return this.attributeXSDatatypes.get(attributeQName);
  }

  setAttributeXSDatatype(attributeQName: QName, type: XSDatatype): void {
    this.attributeXSDatatypes.set(attributeQName, type);
  }

  getChildElementXSDatatype(qname: QName): XSDatatype | undefined {
    return this.childrenXSDatatypes.get(qname);
  }

  setChildElementXSDatatype(qname: QName, dataType: XSDatatype): void {
    this.childrenXSDatatypes.set(qname, dataType);
  }

  createElement(qname: QName): Element {
    let dataType = this.getChildElementXSDatatype(qname);

    if (dataType !== undefined) {
      return new DatatypeElement(qname, dataType);
    }

    let factory = qname.getDocumentFactory();

    if (factory instanceof DatatypeElementFactory) {
      let dtFactory = factory as DatatypeElementFactory;
      dataType = dtFactory.getChildElementXSDatatype(qname);

      if (dataType !== undefined) {
        return new DatatypeElement(qname, dataType);
      }
    }

    return super.createElement(qname);
  }

  createAttribute(owner: Element, qname: QName, value: string): Attribute {
    let dataType = this.getAttributeXSDatatype(qname);

    if (dataType === undefined) {
      return super.createAttribute(owner, qname, value);
    } else {
      return new DatatypeAttribute(qname, dataType, value);
    }
  }
}