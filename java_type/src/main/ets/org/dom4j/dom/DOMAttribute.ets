import QName from "../QName";
import DefaultAttribute from "../tree/DefaultAttribute";
import DOMNodeHelper from "./DOMNodeHelper";

export default class DOMAttribute extends DefaultAttribute implements Attr {
  constructor(qname: QName, value?: string, parent?: Element) {
    super(qname, value, parent);
  }

  // org.w3c.dom.Node interface
  // -------------------------------------------------------------------------
  public supports(feature: string, version: string): boolean {
    return DOMNodeHelper.supports(this, feature, version);
  }

  public getNamespaceURI(): string {
    return this.getQName().getNamespaceURI();
  }

  public getPrefix(): string {
    return this.getQName().getNamespacePrefix();
  }

  public setPrefix(prefix: string): void {
    DOMNodeHelper.setPrefix(this, prefix);
  }

  public getLocalName(): string {
    return this.getQName().getName();
  }

  public getNodeName(): string {
    return this.getName();
  }

  public getNodeValue(): string | null {
    return DOMNodeHelper.getNodeValue(this);
  }

  public setNodeValue(nodeValue: string): void {
    DOMNodeHelper.setNodeValue(this, nodeValue);
  }

  public getParentNode(): Node | null {
    return null;
  }

  public getChildNodes(): NodeList {
    return DOMNodeHelper.getChildNodes(this);
  }

  public getFirstChild(): Node | null {
    return DOMNodeHelper.getFirstChild(this);
  }

  public getLastChild(): Node | null {
    return DOMNodeHelper.getLastChild(this);
  }

  public getPreviousSibling(): Node | null {
    return DOMNodeHelper.getPreviousSibling(this);
  }

  public getNextSibling(): Node | null {
    return DOMNodeHelper.getNextSibling(this);
  }

  public getAttributes(): NamedNodeMap | null {
    return null;
  }

  public getOwnerDocument(): Document | null {
    return DOMNodeHelper.getOwnerDocument(this);
  }

  public insertBefore(newChild: Node, refChild: Node | null): Node {
    this.checkNewChildNode(newChild);

    return DOMNodeHelper.insertBefore(this, newChild, refChild);
  }

  public replaceChild(newChild: Node, oldChild: Node): Node {
    this.checkNewChildNode(newChild);

    return DOMNodeHelper.replaceChild(this, newChild, oldChild);
  }

  public removeChild(oldChild: Node): Node {
    return DOMNodeHelper.removeChild(this, oldChild);
  }

  public appendChild(newChild: Node): Node {
    this.checkNewChildNode(newChild);

    return DOMNodeHelper.appendChild(this, newChild);
  }

  private checkNewChildNode(newChild: Node): void {
    const nodeType = newChild.nodeType;

    if (!(nodeType === Node.TEXT_NODE || nodeType === Node.ENTITY_REFERENCE_NODE)) {
      throw new DOMException(DOMException.HIERARCHY_REQUEST_ERR, "The node cannot be a child of attribute");
    }
  }

  public hasChildNodes(): boolean {
    return DOMNodeHelper.hasChildNodes(this);
  }

  public cloneNode(deep: boolean): Node {
    return DOMNodeHelper.cloneNode(this, deep);
  }

  public normalize(): void {
    DOMNodeHelper.normalize(this);
  }

  public isSupported(feature: string, version: string): boolean {
    return DOMNodeHelper.isSupported(this, feature, version);
  }

  public hasAttributes(): boolean {
    return DOMNodeHelper.hasAttributes(this);
  }

  // org.w3c.dom.Attr interface
  // -------------------------------------------------------------------------
  public getSpecified(): boolean {
    return true;
  }

  public getOwnerElement(): Element | null {
    return DOMNodeHelper.asDOMElement(this.getParent());
  }

  public getSchemaTypeInfo(): TypeInfo | null {
    DOMNodeHelper.notSupported();
    return null;
  }

  public isId(): boolean {
    DOMNodeHelper.notSupported();
    return false;
  }

  public getBaseURI(): string | null {
    DOMNodeHelper.notSupported();
    return null;
  }

  public compareDocumentPosition(other: Node): number {
    DOMNodeHelper.notSupported();
    return 0;
  }

  public getTextContent(): string | null {
    return this.getValue();
  }

  public setTextContent(textContent: string): void {
    this.setValue(textContent);
  }

  public isSameNode(other: Node): boolean {
    return DOMNodeHelper.isNodeSame(this, other);
  }

  public lookupPrefix(namespaceURI: string): string | null {
    DOMNodeHelper.notSupported();
    return null;
  }

  public isDefaultNamespace(namespaceURI: string): boolean {
    DOMNodeHelper.notSupported();
    return false;
  }

  public lookupNamespaceURI(prefix: string): string | null {
    DOMNodeHelper.notSupported();
    return null;
  }

  public isEqualNode(other: Node): boolean {
    return DOMNodeHelper.isNodeEquals(this, other);
  }

  public getFeature(feature: string, version: string): any {
    DOMNodeHelper.notSupported();
    return null;
  }

  public setUserData(key: string, data: any, handler: UserDataHandler | null): any {
    DOMNodeHelper.notSupported();
    return null;
  }

  public getUserData(key: string): any {
    DOMNodeHelper.notSupported();
    return null;
  }
}