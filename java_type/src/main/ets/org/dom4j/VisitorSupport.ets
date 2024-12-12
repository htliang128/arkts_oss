export default  abstract class VisitorSupport {
  constructor() {}

  public visitDocument(document: Document): void {}

  public visitDocumentType(documentType: DocumentType): void {}

  public visitElement(node: Element): void {}

  public visitAttribute(node: Attribute): void {}

  public visitCDATA(node: CDATA): void {}

  public visitComment(node: Comment): void {}

  public visitEntity(node: Entity): void {}

  public visitNamespace(namespace: Namespace): void {}

  public visitProcessingInstruction(node: ProcessingInstruction): void {}

  public visitText(node: Text): void {}
}