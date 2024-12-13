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