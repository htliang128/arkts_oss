import Comment from "./Comment";
import Element from "./Element";
import Node from "./Node";
import ProcessingInstruction from "./ProcessingInstruction";

export default interface Branch extends Node {
  node(index: number): Node;

  indexOf(node: Node): number;

  nodeCount(): number;

  elementByID(elementID: string): Element | null;

  content(): Node[];

  nodeIterator(): Iterable<Node>;

  setContent(content: Node[]): void;

  appendContent(branch: Branch): void;

  clearContent(): void;

  processingInstructions(): ProcessingInstruction[];

  processingInstructions(target: string): ProcessingInstruction[];

  processingInstruction(target: string): ProcessingInstruction | null;

  setProcessingInstructions(listOfPIs: ProcessingInstruction[]): void;

  addElement(name: string): Element;

  addElement(qname: QName): Element;

  addElement(qualifiedName: string, namespaceURI: string): Element;

  removeProcessingInstruction(target: string): boolean;

  add(node: Node): void;

  add(comment: Comment): void;

  add(element: Element): void;

  add(pi: ProcessingInstruction): void;

  remove(node: Node): boolean;

  remove(comment: Comment): boolean;

  remove(element: Element): boolean;

  remove(pi: ProcessingInstruction): boolean;

  normalize(): void;
}