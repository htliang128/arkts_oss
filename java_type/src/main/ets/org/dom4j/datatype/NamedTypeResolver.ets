import DocumentFactory from "../DocumentFactory";
import Element from "../Element";
import QName from "../QName";

export default class NamedTypeResolver {
  protected complexTypeMap: Map<QName, DocumentFactory> = new Map<QName, DocumentFactory>();
  protected simpleTypeMap: Map<QName, XSDatatype> = new Map<QName, XSDatatype>();
  protected typedElementMap: Map<Element, QName> = new Map<Element, QName>();
  protected elementFactoryMap: Map<Element, DocumentFactory> = new Map<Element, DocumentFactory>();
  protected documentFactory: DocumentFactory;

  constructor(documentFactory: DocumentFactory) {
    this.documentFactory = documentFactory;
  }

  registerComplexType(type: QName, factory: DocumentFactory): void {
    this.complexTypeMap.set(type, factory);
  }

  registerSimpleType(type: QName, datatype: XSDatatype): void {
    this.simpleTypeMap.set(type, datatype);
  }

  registerTypedElement(element: Element, type: QName, parentFactory: DocumentFactory): void {
    this.typedElementMap.set(element, type);
    this.elementFactoryMap.set(element, parentFactory);
  }

  resolveElementTypes(): void {
    for (let [element, type] of this.typedElementMap.entries()) {
      let elementQName = this.getQNameOfSchemaElement(element);

      if (this.complexTypeMap.has(type)) {
        let factory = this.complexTypeMap.get(type);
        if (factory) {
          elementQName.setDocumentFactory(factory);
        }
      } else if (this.simpleTypeMap.has(type)) {
        let datatype = this.simpleTypeMap.get(type);
        let factory = this.elementFactoryMap.get(element);

        if (factory instanceof DatatypeElementFactory && datatype) {
          factory.setChildElementXSDatatype(elementQName, datatype);
        }
      }
    }
  }

  resolveNamedTypes(): void {
    this.resolveElementTypes();
  }

  private getQNameOfSchemaElement(element: Element): QName {
    let name = element.attributeValue("name");

    return this.getQName(name);
  }

  private getQName(name: string): QName {
    return this.documentFactory.createQName(name);
  }
}