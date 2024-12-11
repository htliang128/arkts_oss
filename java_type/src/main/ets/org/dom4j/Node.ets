import Cloneable from "../../java/lang/Cloneable";

export enum NodeType {
  ANY_NODE = 0,
  ELEMENT_NODE = 1,
  ATTRIBUTE_NODE = 2,
  TEXT_NODE = 3,
  CDATA_SECTION_NODE = 4,
  ENTITY_REFERENCE_NODE = 5,
  PROCESSING_INSTRUCTION_NODE = 7,
  COMMENT_NODE = 8,
  DOCUMENT_NODE = 9,
  DOCUMENT_TYPE_NODE = 10,
  NAMESPACE_NODE = 13,
  UNKNOWN_NODE = 14,
  MAX_NODE_TYPE = 14
}


export default interface Node extends Cloneable {
  supportsParent(): boolean;
  getParent(): Element;
  setParent(parent: Element): void;
  getDocument(): Document;
  setDocument(document: Document): void;
  isReadOnly(): boolean;
  hasContent(): boolean;
  getName(): string;
  setName(name: string): void;
  getText(): string;
  setText(text: string): void;
  getStringValue(): string;
  getPath(): string;
  getUniquePath(): string;
  asXML(): string;
  write(writer: Writer): Promise<void>;
  getNodeType(): NodeType;
  getNodeTypeName(): string;
  detach(): Node;
  selectNodes(xpathExpression: string): Node[];
  selectObject(xpathExpression: string): Object;
  selectNodes(xpathExpression: string, comparisonXPathExpression: string): Node[];
  selectNodes(xpathExpression: string, comparisonXPathExpression: string, removeDuplicates: boolean): Node[];
  selectSingleNode(xpathExpression: string): Node;
  valueOf(xpathExpression: string): string;
  numberValueOf(xpathExpression: string): number;
  matches(xpathExpression: string): boolean;
  createXPath(xpathExpression: string): XPath;
  asXPathResult(parent: Element): Node;
  accept(visitor: Visitor): void;
  clone(): Node;
}