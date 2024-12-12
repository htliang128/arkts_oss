import DOMElement from "./DOMElement";
import DOMNodeHelper from "./DOMNodeHelper";

export default class DOMAttributeNodeMap implements NamedNodeMap {
  private element: DOMElement;

  constructor(element: DOMElement) {
    this.element = element;
  }

  // org.w3c.dom.NamedNodeMap interface
  // -------------------------------------------------------------------------
  public foo(): never {
    DOMNodeHelper.notSupported();
  }

  public getNamedItem(name: string): Attr | null {
    return this.element.getAttributeNode(name);
  }

  public setNamedItem(arg: Node): Node {
    if (arg instanceof Attr) {
      return this.element.setAttributeNode(arg as Attr);
    } else {
      throw new DOMException(DOMException.NOT_SUPPORTED_ERR, "Node is not an Attr: " + arg);
    }
  }

  public removeNamedItem(name: string): Node {
    const attr = this.element.getAttributeNode(name);

    if (attr === null) {
      throw new DOMException(DOMException.NOT_FOUND_ERR, "No attribute named " + name);
    }

    return this.element.removeAttributeNode(attr);
  }

  public item(index: number): Attr | null {
    return DOMNodeHelper.asDOMAttr(this.element.attribute(index));
  }

  public get length(): number {
    return this.element.attributeCount();
  }

  public getNamedItemNS(namespaceURI: string, localName: string): Attr | null {
    return this.element.getAttributeNodeNS(namespaceURI, localName);
  }

  public setNamedItemNS(arg: Node): Node {
    if (arg instanceof Attr) {
      return this.element.setAttributeNodeNS(arg as Attr);
    } else {
      throw new DOMException(DOMException.NOT_SUPPORTED_ERR, "Node is not an Attr: " + arg);
    }
  }

  public removeNamedItemNS(namespaceURI: string, localName: string): Node {
    const attr = this.element.getAttributeNodeNS(namespaceURI, localName);

    if (attr !== null) {
      return this.element.removeAttributeNode(attr);
    }

    return attr;
  }
}