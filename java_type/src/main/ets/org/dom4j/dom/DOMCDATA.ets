import CDATA from "../CDATA";
import Document from "../Document";
import Element from "../Element";
import Node from "../Node";
import DefaultCDATA from "../tree/DefaultCDATA";
import DOMNodeHelper from "./DOMNodeHelper";

export default class DOMCDATA extends DefaultCDATA implements CDATASection {
  constructor(text: string);
  constructor(parent: Element, text: string);
  constructor(arg1: any, arg2?: any) {
    if (typeof arg1 === 'string') {
      super(arg1);
    } else {
      super(arg1, arg2);
    }
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
    return "#cdata-section";
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

  getAttributes(): NamedNodeMap | null {
    return null;
  }

  getOwnerDocument(): Document {
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
    throw new DOMException('CDATASection nodes cannot have children', 'HierarchyRequestError');
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

  getData(): string {
    return DOMNodeHelper.getData(this);
  }

  setData(data: string): void {
    DOMNodeHelper.setData(this, data);
  }

  getLength(): number {
    return DOMNodeHelper.getLength(this);
  }

  substringData(offset: number, count: number): string {
    return DOMNodeHelper.substringData(this, offset, count);
  }

  appendData(arg: string): void {
    DOMNodeHelper.appendData(this, arg);
  }

  insertData(offset: number, arg: string): void {
    DOMNodeHelper.insertData(this, offset, arg);
  }

  deleteData(offset: number, count: number): void {
    DOMNodeHelper.deleteData(this, offset, count);
  }

  replaceData(offset: number, count: number, arg: string): void {
    DOMNodeHelper.replaceData(this, offset, count, arg);
  }

  splitText(offset: number): Text {
    if (this.isReadOnly()) {
      throw new DOMException('CharacterData node is read only: ' + this, 'NoModificationAllowedError');
    } else {
      const text = this.getText();
      const length = text ? text.length : 0;
      if (offset >= 0 && offset < length) {
        const start = text.substring(0, offset);
        const rest = text.substring(offset);
        this.setText(start);
        const parent = this.getParent();
        const newText = this.createCDATA(rest);
        if (parent) {
          parent.add(newText);
        }
        return DOMNodeHelper.asDOMText(newText);
      } else {
        throw new DOMException('No text at offset: ' + offset, 'IndexSizeError');
      }
    }
  }

  protected createCDATA(text: string): CDATA {
    return new DOMCDATA(text);
  }

  isElementContentWhitespace(): boolean {
    DOMNodeHelper.notSupported();
    return false;
  }

  getWholeText(): string | null {
    DOMNodeHelper.notSupported();
    return null;
  }

  replaceWholeText(content: string): Text | null {
    DOMNodeHelper.notSupported();
    return null;
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