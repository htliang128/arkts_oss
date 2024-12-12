import Node from "../Node";
import DOMNodeHelper from "./DOMNodeHelper";

export default class DOMNamespace extends DefaultNamespace implements Node {
  constructor(prefix: string, uri: string);
  constructor(parent: Element, prefix: string, uri: string);
  constructor(arg1: string | Element, prefix?: string, uri?: string) {
    if (typeof arg1 === 'string') {
      super(arg1, prefix!);
    } else {
      super(arg1, prefix!, uri!);
    }
  }

  supports(feature: string, version: string): boolean {
    return DOMNodeHelper.supports(this, feature, version);
  }

  getNamespaceURI(): string {
    return DOMNodeHelper.getNamespaceURI(this);
  }

  setPrefix(prefix: string): void {
    DOMNodeHelper.setPrefix(this, prefix);
  }

  getLocalName(): string {
    return DOMNodeHelper.getLocalName(this);
  }

  getNodeName(): string {
    return this.getName();
  }

  getNodeValue(): string {
    return DOMNodeHelper.getNodeValue(this);
  }

  setNodeValue(nodeValue: string): void {
    DOMNodeHelper.setNodeValue(this, nodeValue);
  }

  getParentNode(): Node {
    return DOMNodeHelper.getParentNode(this);
  }

  getChildNodes(): NodeList {
    return DOMNodeHelper.getChildNodes(this);
  }

  getFirstChild(): Node {
    return DOMNodeHelper.getFirstChild(this);
  }

  getLastChild(): Node {
    return DOMNodeHelper.getLastChild(this);
  }

  getPreviousSibling(): Node {
    return DOMNodeHelper.getPreviousSibling(this);
  }

  getNextSibling(): Node {
    return DOMNodeHelper.getNextSibling(this);
  }

  getAttributes(): NamedNodeMap {
    return DOMNodeHelper.getAttributes(this);
  }

  getOwnerDocument(): Document {
    return DOMNodeHelper.getOwnerDocument(this);
  }

  insertBefore(newChild: Node, refChild: Node): Node {
    return DOMNodeHelper.insertBefore(this, newChild, refChild);
  }

  replaceChild(newChild: Node, oldChild: Node): Node {
    return DOMNodeHelper.replaceChild(this, newChild, oldChild);
  }

  removeChild(oldChild: Node): Node {
    return DOMNodeHelper.removeChild(this, oldChild);
  }

  appendChild(newChild: Node): Node {
    return DOMNodeHelper.appendChild(this, newChild);
  }

  hasChildNodes(): boolean {
    return DOMNodeHelper.hasChildNodes(this);
  }

  cloneNode(deep: boolean): Node {
    return DOMNodeHelper.cloneNode(this, deep);
  }

  normalize(): void {
    DOMNodeHelper.normalize(this);
  }

  isSupported(feature: string, version: string): boolean {
    return DOMNodeHelper.isSupported(this, feature, version);
  }

  hasAttributes(): boolean {
    return DOMNodeHelper.hasAttributes(this);
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

  getFeature(feature: string, version: string): any {
    DOMNodeHelper.notSupported();
    return null;
  }

  setUserData(key: string, data: any, handler: UserDataHandler): any {
    DOMNodeHelper.notSupported();
    return null;
  }

  getUserData(key: string): any {
    DOMNodeHelper.notSupported();
    return null;
  }
}