import Document from "../Document";
import Node from "../Node";
import DefaultDocument from "../tree/DefaultDocument";
import DOMDocumentFactory from "./DOMDocumentFactory";
import DOMDocumentType from "./DOMDocumentType";
import DOMElement from "./DOMElement";
import DOMNodeHelper from "./DOMNodeHelper";

export default class DOMDocument extends DefaultDocument implements Document {
  private static readonly DOCUMENT_FACTORY: DOMDocumentFactory = DOMDocumentFactory.getInstance() as DOMDocumentFactory;

  constructor();
  constructor(name: string);
  constructor(rootElement: DOMElement);
  constructor(docType: DOMDocumentType);
  constructor(rootElement: DOMElement, docType: DOMDocumentType);
  constructor(name: string, rootElement: DOMElement, docType: DOMDocumentType);
  constructor(arg1?: any, arg2?: any, arg3?: any) {
    if (typeof arg1 === 'string') {
      super(arg1, arg2, arg3);
    } else {
      super(arg1, arg2);
    }
    this.init();
  }

  private init(): void {
    this.setDocumentFactory(DOMDocument.DOCUMENT_FACTORY);
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
    return "#document";
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

  getAttributes(): NamedNodeMap | null {
    return null;
  }

  getOwnerDocument(): Document | null {
    return null;
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
    const nodeType = newChild.nodeType;
    if (nodeType !== 1 && nodeType !== 8 && nodeType !== 7 && nodeType !== 10) {
      throw new DOMException('Given node cannot be a child of document', 'HierarchyRequestError');
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

  getElementsByTagName(name: string): NodeList {
    const list = new ArrayList<org.dom4j.Node>();
    DOMNodeHelper.appendElementsByTagName(list, this, name);
    return DOMNodeHelper.createNodeList(list);
  }

  getElementsByTagNameNS(namespace: string, name: string): NodeList {
    const list = new ArrayList<org.dom4j.Node>();
    DOMNodeHelper.appendElementsByTagNameNS(list, this, namespace, name);
    return DOMNodeHelper.createNodeList(list);
  }

  getDoctype(): DocumentType | null {
    return DOMNodeHelper.asDOMDocumentType(this.getDocType());
  }

  getImplementation(): DOMImplementation {
    return this.getDocumentFactory() as DOMImplementation;
  }

  getDocumentElement(): Element | null {
    return DOMNodeHelper.asDOMElement(this.getRootElement());
  }

  createElement(name: string): Element {
    return this.getDocumentFactory().createElement(name) as Element;
  }

  createDocumentFragment(): DocumentFragment | null {
    DOMNodeHelper.notSupported();
    return null;
  }

  createTextNode(data: string): Text {
    return this.getDocumentFactory().createText(data) as Text;
  }

  createComment(data: string): Comment {
    return this.getDocumentFactory().createComment(data) as Comment;
  }

  createCDATASection(data: string): CDATASection {
    return this.getDocumentFactory().createCDATA(data) as CDATASection;
  }

  createProcessingInstruction(target: string, data: string): ProcessingInstruction {
    return this.getDocumentFactory().createProcessingInstruction(target, data) as ProcessingInstruction;
  }

  createAttribute(name: string): Attr {
    const qname = this.getDocumentFactory().createQName(name);
    return this.getDocumentFactory().createAttribute(null, qname, '') as Attr;
  }

  createEntityReference(name: string): EntityReference {
    return this.getDocumentFactory().createEntity(name, null) as EntityReference;
  }

  importNode(importedNode: Node, deep: boolean): Node | null {
    DOMNodeHelper.notSupported();
    return null;
  }

  createElementNS(namespaceURI: string, qualifiedName: string): Element {
    const qname = this.getDocumentFactory().createQName(qualifiedName, namespaceURI);
    return this.getDocumentFactory().createElement(qname) as Element;
  }

  createAttributeNS(namespaceURI: string, qualifiedName: string): Attr {
    const qname = this.getDocumentFactory().createQName(qualifiedName, namespaceURI);
    return this.getDocumentFactory().createAttribute(null, qname, null) as Attr;
  }

  getElementById(elementId: string): Element | null {
    return DOMNodeHelper.asDOMElement(this.elementByID(elementId));
  }

  protected getDocumentFactory(): DocumentFactory {
    return super.getDocumentFactory() || DOMDocument.DOCUMENT_FACTORY;
  }

  getInputEncoding(): string | null {
    DOMNodeHelper.notSupported();
    return null;
  }

  getXmlEncoding(): string | null {
    DOMNodeHelper.notSupported();
    return null;
  }

  getXmlStandalone(): boolean {
    DOMNodeHelper.notSupported();
    return false;
  }

  setXmlStandalone(xmlStandalone: boolean): void {
    DOMNodeHelper.notSupported();
  }

  getXmlVersion(): string | null {
    DOMNodeHelper.notSupported();
    return null;
  }

  setXmlVersion(xmlVersion: string): void {
    DOMNodeHelper.notSupported();
  }

  getStrictErrorChecking(): boolean {
    DOMNodeHelper.notSupported();
    return false;
  }

  setStrictErrorChecking(strictErrorChecking: boolean): void {
    DOMNodeHelper.notSupported();
  }

  getDocumentURI(): string | null {
    DOMNodeHelper.notSupported();
    return null;
  }

  setDocumentURI(documentURI: string): void {
    DOMNodeHelper.notSupported();
  }

  adoptNode(source: Node): Node | null {
    DOMNodeHelper.notSupported();
    return null;
  }

  getDomConfig(): DOMConfiguration | null {
    DOMNodeHelper.notSupported();
    return null;
  }

  normalizeDocument(): void {
    DOMNodeHelper.notSupported();
  }

  renameNode(n: Node, namespaceURI: string, qualifiedName: string): Node | null {
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
    DOMNodeHelper.notSupported();
    return null;
  }
}