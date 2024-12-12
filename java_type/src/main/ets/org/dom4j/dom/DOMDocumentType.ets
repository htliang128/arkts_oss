import Document from "../Document";
import DocumentType from "../DocumentType";
import Node from "../Node";
import DefaultDocumentType from "../tree/DefaultDocumentType";
import DOMNodeHelper from "./DOMNodeHelper";

export default class DOMDocumentType extends DefaultDocumentType implements DocumentType {
  constructor();
  constructor(elementName: string, systemID: string);
  constructor(name: string, publicID: string, systemID: string);
  constructor(name?: string, publicID?: string, systemID?: string) {
    super(name, publicID, systemID);
  }

  supports(feature: string, version: string): boolean {
    return DOMNodeHelper.supports(this, feature, version);
  }

  getNamespaceURI(): string {
    return DOMNodeHelper.getNamespaceURI(this);
  }

  getPrefix(): string {
    return DOMNodeHelper.getPrefix(this);
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

  getNodeValue(): string | null {
    return null;
  }

  setNodeValue(nodeValue: string): void {}

  getParentNode(): Node | null {
    return DOMNodeHelper.getParentNode(this);
  }

  getChildNodes(): NodeList {
    return DOMNodeHelper.getChildNodes(this);
  }

  getFirstChild(): Node | null {
    return DOMNodeHelper.getFirstChild(this);
  }

  getLastChild(): Node | null {
    return DOMNodeHelper.getLastChild(this);
  }

  getPreviousSibling(): Node | null {
    return DOMNodeHelper.getPreviousSibling(this);
  }

  getNextSibling(): Node | null {
    return DOMNodeHelper.getNextSibling(this);
  }

  getAttributes(): NamedNodeMap | null {
    return null;
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
    throw new DOMException(DOMException.HIERARCHY_REQUEST_ERR, "DocumentType nodes cannot have children");
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

  getEntities(): NamedNodeMap | null {
    return null;
  }

  getNotations(): NamedNodeMap | null {
    return null;
  }

  getPublicId(): string {
    return this.getPublicID();
  }

  getSystemId(): string {
    return this.getSystemID();
  }

  getInternalSubset(): string {
    return this.getElementName();
  }

  getBaseURI(): string | null {
    DOMNodeHelper.notSupported();
    return null;
  }

  compareDocumentPosition(other: Node): number {
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
    DOMNodeHelper.notSupported();
    return false;
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

  getNodeType(): number {
    DOMNodeHelper.notSupported();
    return 0;
  }
}