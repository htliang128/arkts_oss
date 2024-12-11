export default interface Visitor {
  visit(document: Document): void;
  visit(documentType: DocumentType): void;
  visit(node: Element): void;
  visit(node: Attribute): void;
  visit(node: CDATA): void;
  visit(node: Comment): void;
  visit(node: Entity): void;
  visit(namespace: Namespace): void;
  visit(node: ProcessingInstruction): void;
  visit(node: Text): void;
}