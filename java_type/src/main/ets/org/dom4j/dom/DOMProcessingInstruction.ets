import Element from "../Element";
import ProcessingInstruction from "../ProcessingInstruction";
import DefaultProcessingInstruction from "../tree/DefaultProcessingInstruction";
import DOMNodeHelper from "./DOMNodeHelper";
import { Node } from "@kit.ArkGraphics3D";
import Document from "../Document";

export default class DOMProcessingInstruction extends DefaultProcessingInstruction implements ProcessingInstruction {
  constructor(target: string, values: Map<string, string>);
  constructor(target: string, values: string);
  constructor(parent: Element, target: string, val: string);
  constructor(targetOrParent: any, targetOrValues: any, val?: string) {
    super(targetOrParent, targetOrValues, val);
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
    throw new DOMException(DOMException.HIERARCHY_REQUEST_ERR, "PI nodes cannot have children");
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
    return this.getText();
  }

  setData(data: string): void {
    if (this.isReadOnly()) {
      throw new DOMException(DOMException.NO_MODIFICATION_ALLOWED_ERR, "This ProcessingInstruction is read only");
    } else {
      this.setText(data);
    }
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
    throw new Error("Not supported yet.");
  }
}