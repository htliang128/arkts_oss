import DocumentFactory from "../DocumentFactory";
import DefaultElement from "../tree/DefaultElement";

export default class BeanElement extends DefaultElement {
  private static DOCUMENT_FACTORY: DocumentFactory = BeanDocumentFactory.getInstance();

  private bean: any;

  constructor(name: string, bean: any);
  constructor(name: string, namespace: Namespace, bean: any);
  constructor(qname: QName, bean: any);
  constructor(qname: QName);
  constructor(arg1: string | QName, arg2?: any | Namespace, arg3?: any) {
    if (typeof arg1 === 'string') {
      if (arg2 instanceof Namespace) {
        super(BeanElement.DOCUMENT_FACTORY.createQName(arg1, arg2));
        this.bean = arg3;
      } else {
        super(BeanElement.DOCUMENT_FACTORY.createQName(arg1));
        this.bean = arg2;
      }
    } else if (arg1 instanceof QName) {
      super(arg1);
      this.bean = arg2;
    }
  }

  getData(): any {
    return this.bean;
  }

  setData(data: any): void {
    this.bean = data;
    // force the attributeList to be lazily
    // created next time an attribute related
    // method is called again.
    this.setAttributeList(null);
  }

  attribute(name: string): BeanAttribute;
  attribute(qname: QName): BeanAttribute;
  attribute(arg: string | QName): BeanAttribute {
    return this.getBeanAttributeList().attribute(arg);
  }

  addAttribute(name: string, value: string): Element;
  addAttribute(qName: QName, value: string): Element;
  addAttribute(arg: string | QName, value: string): Element {
    let attribute: Attribute = this.attribute(arg);

    if (attribute !== null) {
      attribute.setValue(value);
    }

    return this;
  }

  setAttributes(attributes: Attribute[]): void {
    throw new Error("Not implemented yet.");
  }

  // Method overridden from AbstractElement
  setAttributesWithNamespace(attributes: any, namespaceStack: any, noNamespaceAttributes: boolean): void {
    let className: string = attributes["class"];

    if (className !== undefined) {
      try {
        let beanClass = require(className);
        this.setData(new beanClass());

        for (let attributeName in attributes) {
          if (attributeName !== "class") {
            this.addAttribute(attributeName, attributes[attributeName]);
          }
        }
      } catch (ex) {
        // What to do here?
        (this.getDocumentFactory() as BeanDocumentFactory).handleException(ex);
      }
    } else {
      super.setAttributes(attributes, namespaceStack, noNamespaceAttributes);
    }
  }

  // Implementation methods
  // -------------------------------------------------------------------------
  protected getDocumentFactory(): DocumentFactory {
    return BeanElement.DOCUMENT_FACTORY;
  }

  protected getBeanAttributeList(): BeanAttributeList {
    return this.attributeList() as BeanAttributeList;
  }

  protected createAttributeList(): Attribute[] {
    return new BeanAttributeList(this);
  }

  protected createAttributeListWithSize(size: number): Attribute[] {
    return new BeanAttributeList(this);
  }
}