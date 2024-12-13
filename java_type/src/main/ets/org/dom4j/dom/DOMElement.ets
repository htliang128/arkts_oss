import Element from "../Element";
import Namespace from "../Namespace";
import QName from "../QName";
import DefaultElement from "../tree/DefaultElement";
import DOMDocumentFactory from "./DOMDocumentFactory";
import DOMNodeHelper from "./DOMNodeHelper";

export default class DOMElement extends DefaultElement implements Element {
  private static readonly DOCUMENT_FACTORY = DOMDocumentFactory.getInstance();

  constructor(name: string);
  constructor(qname: QName);
  constructor(qname: QName, attributeCount: number);
  constructor(name: string, namespace: Namespace);
  constructor(...args: any[]) {
    super(...args);
  }

  supports(feature: string, version: string): boolean {
    return DOMNodeHelper.supports(this, feature, version);
  }

  getNamespaceURI(): string {
    return this.getQName().getNamespaceURI();
  }

  getPrefix(): string {
    return this.getQName().getNamespacePrefix();
  }

  setPrefix(prefix: string): void {
    DOMNodeHelper.setPrefix(this, prefix);
  }

  getLocalName(): string {
    return this.getQName().getName();
  }

  getNodeName(): string {
    return this.getName();
  }

  getNodeValue(): string | null {
    return null;
  }

  setNodeValue(nodeValue: string): void {}

  getParentNode(): Node | null {
    return DOMNodeHelper.getParentNode(this);
  }

  getChildNodes(): NodeList {
    return DOMNodeHelper.createNodeList(this.content());
  }

  getFirstChild(): Node | null {
    return DOMNodeHelper.asDOMNode(this.node(0));
  }

  getLastChild(): Node | null {
    return DOMNodeHelper.asDOMNode(this.node(this.nodeCount() - 1));
  }

  getPreviousSibling(): Node | null {
    return DOMNodeHelper.getPreviousSibling(this);
  }

  getNextSibling(): Node | null {
    return DOMNodeHelper.getNextSibling(this);
  }

  getAttributes(): NamedNodeMap {
    return new DOMAttributeNodeMap(this);
  }

  getOwnerDocument(): Document | null {
    return DOMNodeHelper.getOwnerDocument(this);
  }

  insertBefore(newChild: Node, refChild: Node): Node {
    this.checkNewChildNode(newChild);
    return DOMNodeHelper.insertBefore(this, newChild, refChild);
  }

  replaceChild(newChild: Node, oldChild: Node): Node {
    this.checkNewChildNode(newChild);
    return DOMNodeHelper.replaceChild(this, newChild, oldChild);
  }

  removeChild(oldChild: Node): Node {
    return DOMNodeHelper.removeChild(this, oldChild);
  }

  appendChild(newChild: Node): Node {
    this.checkNewChildNode(newChild);
    return DOMNodeHelper.appendChild(this, newChild);
  }

  private checkNewChildNode(newChild: Node): void {
    const nodeType = newChild.getNodeType();
    if (![1, 3, 8, 7, 4, 5].includes(nodeType)) {
      throw new DOMException((short)3, "Given node cannot be a child of element");
    }
  }

  hasChildNodes(): boolean {
    return this.nodeCount() > 0;
  }

  cloneNode(deep: boolean): Node {
    return DOMNodeHelper.cloneNode(this, deep);
  }

  isSupported(feature: string, version: string): boolean {
    return DOMNodeHelper.isSupported(this, feature, version);
  }

  hasAttributes(): boolean {
    return DOMNodeHelper.hasAttributes(this);
  }

  getTagName(): string {
    return this.getName();
  }

  getAttribute(name: string): string {
    const answer = this.attributeValue(name);
    return answer !== null ? answer : "";
  }

  setAttribute(name: string, value: string): void {
    this.addAttribute(name, value);
  }

  removeAttribute(name: string): void {
    const attribute = this.attribute(name);
    if (attribute !== null) {
      this.remove(attribute);
    }
  }

  getAttributeNode(name: string): Attr | null {
    return DOMNodeHelper.asDOMAttr(this.attribute(name));
  }

  setAttributeNode(newAttr: Attr): Attr {
    if (this.isReadOnly()) {
      throw new DOMException((short)7, "No modification allowed");
    }
    const attribute = this.attribute(newAttr);
    if (attribute !== newAttr) {
      if (newAttr.getOwnerElement() !== null) {
        throw new DOMException((short)10, "Attribute is already in use");
      }

      const newAttribute = this.createAttribute(newAttr);
      if (attribute !== null) {
        attribute.detach();
      }

      this.add(newAttribute);
    }

    return DOMNodeHelper.asDOMAttr(attribute);
  }

  removeAttributeNode(oldAttr: Attr): Attr {
    const attribute = this.attribute(oldAttr);
    if (attribute !== null) {
      attribute.detach();
      return DOMNodeHelper.asDOMAttr(attribute);
    } else {
      throw new DOMException((short)8, "No such attribute");
    }
  }

  getAttributeNS(namespaceURI: string, localName: string): string {
    const attribute = this.attribute(namespaceURI, localName);
    if (attribute !== null) {
      const answer = attribute.getValue();
      if (answer !== null) {
        return answer;
      }
    }
    return "";
  }

  setAttributeNS(namespaceURI: string, qualifiedName: string, value: string): void {
    const attribute = this.attribute(namespaceURI, qualifiedName);
    if (attribute !== null) {
      attribute.setValue(value);
    } else {
      const qname = this.getQName(namespaceURI, qualifiedName);
      this.addAttribute(qname, value);
    }
  }

  removeAttributeNS(namespaceURI: string, localName: string): void {
    const attribute = this.attribute(namespaceURI, localName);
    if (attribute !== null) {
      this.remove(attribute);
    }
  }

  getAttributeNodeNS(namespaceURI: string, localName: string): Attr | null {
    const attribute = this.attribute(namespaceURI, localName);
    if (attribute !== null) {
      return DOMNodeHelper.asDOMAttr(attribute);
    }
    return null;
  }

  setAttributeNodeNS(newAttr: Attr): Attr {
    const attribute = this.attribute(newAttr.getNamespaceURI(), newAttr.getLocalName());
    if (attribute !== null) {
      attribute.setValue(newAttr.getValue());
    } else {
      const newAttribute = this.createAttribute(newAttr);
      this.add(newAttribute);
    }

    return DOMNodeHelper.asDOMAttr(attribute);
  }

  getElementsByTagName(name: string): NodeList {
    const list: Array<org.dom4j.Node> = [];
    DOMNodeHelper.appendElementsByTagName(list, this, name);
    return DOMNodeHelper.createNodeList(list);
  }

  getElementsByTagNameNS(namespace: string, lName: string): NodeList {
    const list: Array<org.dom4j.Node> = [];
    DOMNodeHelper.appendElementsByTagNameNS(list, this, namespace, lName);
    return DOMNodeHelper.createNodeList(list);
  }

  hasAttribute(name: string): boolean {
    return this.attribute(name) !== null;
  }

  hasAttributeNS(namespaceURI: string, localName: string): boolean {
    return this.attribute(namespaceURI, localName) !== null;
  }

  protected getDocumentFactory(): DocumentFactory {
    const factory = this.getQName().getDocumentFactory();
    return factory !== null ? factory : DOMElement.DOCUMENT_FACTORY;
  }

  protected attribute(attr: Attr): Attribute | null {
    return this.attribute(DOMElement.DOCUMENT_FACTORY.createQName(attr.getLocalName(), attr.getPrefix(), attr.getNamespaceURI()));
  }

  protected attribute(namespaceURI: string, localName: string): Attribute | null {
    const attributes = this.attributeList();
    for (const attribute of attributes) {
      if (localName === attribute.getName() &&
        (namespaceURI === null || namespaceURI.length === 0) &&
        (attribute.getNamespaceURI() === null || attribute.getNamespaceURI().length === 0)) {
        return attribute;
      }
      if (namespaceURI !== null && namespaceURI === attribute.getNamespaceURI()) {
        return attribute;
      }
    }
    return null;
  }

  protected createAttribute(newAttr: Attr): Attribute {
    let qname: QName | null = null;
    let name = newAttr.getLocalName();
    if (name !== null) {
      const prefix = newAttr.getPrefix();
      const uri = newAttr.getNamespaceURI();
      qname = this.getDocumentFactory().createQName(name, prefix, uri);
    } else {
      name = newAttr.getName();
      qname = this.getDocumentFactory().createQName(name);
    }

    return new DOMAttribute(qname, newAttr.getValue());
  }

  protected getQName(namespace: string, qualifiedName: string): QName {
    const index = qualifiedName.indexOf(":");
    let prefix = "";
    let localName = qualifiedName;
    if (index >= 0) {
      prefix = qualifiedName.substring(0, index);
      localName = qualifiedName.substring(index + 1);
    }

    return this.getDocumentFactory().createQName(localName, prefix, namespace);
  }

  getSchemaTypeInfo(): TypeInfo | null {
    DOMNodeHelper.notSupported();
    return null;
  }

  setIdAttribute(name: string, isId: boolean): void {
    DOMNodeHelper.notSupported();
  }

  setIdAttributeNS(namespaceURI: string, localName: string, isId: boolean): void {
    DOMNodeHelper.notSupported();
  }

  setIdAttributeNode(idAttr: Attr, isId: boolean): void {
    DOMNodeHelper.notSupported();
  }

  getBaseURI(): string | null {
    DOMNodeHelper.notSupported();
    return null;
  }

  compareDocumentPosition(other: Node): short {
    DOMNodeHelper.notSupported();
    return 0;
  }

  getTextContent(): string | null {
    DOMNodeHelper.notSupported();
    return null;
  }

  setTextContent(textContent: string): void {
    DOMNodeHelper.notSupported();
  }

  isSameNode(other: Node): boolean {
    return DOMNodeHelper.isNodeSame(this, other);
  }

  lookupPrefix(namespaceURI: string): string | null {
    DOMNodeHelper.notSupported();
    return null;
  }

  isDefaultNamespace(namespaceURI: string): boolean {
    DOMNodeHelper.notSupported();
    return false;
  }

  lookupNamespaceURI(prefix: string): string | null {
    DOMNodeHelper.notSupported();
    return null;
  }

  isEqualNode(other: Node): boolean {
    return DOMNodeHelper.isNodeEquals(this, other);
  }

  getFeature(feature: string, version: string): Object | null {
    DOMNodeHelper.notSupported();
    return null;
  }

  setUserData(key: string, data: Object, handler: UserDataHandler): Object | null {
    DOMNodeHelper.notSupported();
    return null;
  }

  getUserData(key: string): Object | null {
    DOMNodeHelper.notSupported();
    return null;
  }
}