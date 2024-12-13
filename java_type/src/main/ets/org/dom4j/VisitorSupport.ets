import Attribute from "./Attribute";
import CDATA from "./CDATA";
import Comment from "./Comment";
import Document from "./Document";
import DocumentType from "./DocumentType";
import Element from "./Element";
import Entity from "./Entity";
import Namespace from "./Namespace";
import ProcessingInstruction from "./ProcessingInstruction";
import Text from "./Text";

export default abstract class VisitorSupport {
  constructor() {
  }

  public visitDocument(document: Document): void {
  }

  public visitDocumentType(documentType: DocumentType): void {
  }

  public visitElement(node: Element): void {
  }

  public visitAttribute(node: Attribute): void {
  }

  public visitCDATA(node: CDATA): void {
  }

  public visitComment(node: Comment): void {
  }

  public visitEntity(node: Entity): void {
  }

  public visitNamespace(namespace: Namespace): void {
  }

  public visitProcessingInstruction(node: ProcessingInstruction): void {
  }

  public visitText(node: Text): void {
  }
}