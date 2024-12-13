import Element from "../Element";
import DOMNodeHelper from "./DOMNodeHelper";
import Text from "../Text";
import DefaultText from "../tree/DefaultText";
import Node from "../Node";

export default class DOMText extends DefaultText implements Text {
  constructor(text: string);
  constructor(parent: Element, text: string);
  constructor(...args: any[]) {
    if (args.length === 1) {
      super(args[0]);
    } else if (args.length === 2) {
      super(args[0], args[1]);
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
    return "#text";
  }

  getNodeValue(): string | null {
    return DOMNodeHelper.getNodeValue(this);
  }

  setNodeValue(nodeValue: string): void {
    DOMNodeHelper.setNodeValue(this, nodeValue);
  }

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
    throw new DOMException((short)3, "Text nodes cannot have children");
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
      throw new DOMException((short)7, "CharacterData node is read only: " + this);
    } else {
      const text = this.getText();
      const length = text != null ? text.length : 0;
      if (offset >= 0 && offset < length) {
        const start = text.substring(0, offset);
        const rest = text.substring(offset);
        this.setText(start);
        const parent = this.getParent();
        const newText = this.createText(rest);
        if (parent != null) {
          parent.add(newText);
        }

        return DOMNodeHelper.asDOMText(newText);
      } else {
        throw new DOMException((short)1, "No text at offset: " + offset);
      }
    }
  }

  protected createText(text: string): org.dom4j.Text {
    return new DOMText(text);
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
    DOMNodeHelper.notSupported();
    return false;
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