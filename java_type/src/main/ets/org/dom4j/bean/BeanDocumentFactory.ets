export default class BeanDocumentFactory extends DocumentFactory {
  private static singleton = new BeanDocumentFactory();

  public static getInstance(): DocumentFactory {
    return this.singleton;
  }

  createElement(qname: QName): Element {
    let bean = this.createBean(qname);

    if (bean === null) {
      return new BeanElement(qname);
    } else {
      return new BeanElement(qname, bean);
    }
  }

  createElementWithAttributes(qname: QName, attributes: any): Element {
    let bean = this.createBeanWithAttributes(qname, attributes);

    if (bean === null) {
      return new BeanElement(qname);
    } else {
      return new BeanElement(qname, bean);
    }
  }

  createAttribute(owner: Element, qname: QName, value: string): Attribute {
    return new DefaultAttribute(qname, value);
  }

  protected createBean(qname: QName): any {
    return null;
  }

  protected createBeanWithAttributes(qname: QName, attributes: any): any {
    let value = attributes["class"];

    if (value !== undefined) {
      try {
        let beanClass = require(value);

        return new beanClass();
      } catch (e) {
        this.handleException(e);
      }
    }

    return null;
  }

  protected handleException(e: any): void {
    console.warn("#### Warning: couldn't create bean: " + e);
  }
}