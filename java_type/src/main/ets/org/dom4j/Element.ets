import Branch from "./Branch";

export default interface Element extends Branch {
  getQName(): QName;

  setQName(qname: QName): void;

  getNamespace(): Namespace;

  getQName(qualifiedName: string): QName;

  getNamespaceForPrefix(prefix: string): Namespace;

  getNamespaceForURI(uri: string): Namespace;

  getNamespacesForURI(uri: string): Namespace[];

  getNamespacePrefix(): string;

  getNamespaceURI(): string;

  getQualifiedName(): string;

  additionalNamespaces(): Namespace[];

  declaredNamespaces(): Namespace[];

  addAttribute(name: string, value: string): Element;

  addAttribute(qName: QName, value: string): Element;

  addComment(comment: string): Element;

  addCDATA(cdata: string): Element;

  addEntity(name: string, text: string): Element;

  addNamespace(prefix: string, uri: string): Element;

  addProcessingInstruction(target: string, text: string): Element;

  addProcessingInstruction(target: string, data: Map<string, string>): Element;

  addText(text: string): Element;

  add(attribute: Attribute): void;

  add(cdata: CDATA): void;

  add(entity: Entity): void;

  add(text: Text): void;

  add(namespace: Namespace): void;

  remove(attribute: Attribute): boolean;

  remove(cdata: CDATA): boolean;

  remove(entity: Entity): boolean;

  remove(namespace: Namespace): boolean;

  remove(text: Text): boolean;

  getText(): string;

  getTextTrim(): string;

  getStringValue(): string;

  getData(): any;

  setData(data: any): void;

  attributes(): Attribute[];

  setAttributes(attributes: Attribute[]): void;

  attributeCount(): number;

  attributeIterator(): Iterable<Attribute>;

  attribute(index: number): Attribute;

  attribute(name: string): Attribute;

  attribute(qName: QName): Attribute;

  attributeValue(name: string): string;

  attributeValue(name: string, defaultValue: string): string;

  attributeValue(qName: QName): string;

  attributeValue(qName: QName, defaultValue: string): string;

  setAttributeValue(name: string, value: string): void;

  setAttributeValue(qName: QName, value: string): void;

  element(name: string): Element;

  element(qName: QName): Element;

  elements(): Element[];

  elements(name: string): Element[];

  elements(qName: QName): Element[];

  elementIterator(): Iterable<Element>;

  elementIterator(name: string): Iterable<Element>;

  elementIterator(qName: QName): Iterable<Element>;

  isRootElement(): boolean;

  hasMixedContent(): boolean;

  isTextOnly(): boolean;

  appendAttributes(element: Element): void;

  createCopy(): Element;

  createCopy(name: string): Element;

  createCopy(qName: QName): Element;

  elementText(name: string): string;

  elementText(qname: QName): string;

  elementTextTrim(name: string): string;

  elementTextTrim(qname: QName): string;

  getXPathResult(index: number): Node;
}