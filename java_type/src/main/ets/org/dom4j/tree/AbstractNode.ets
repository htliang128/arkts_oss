import Element from "../Element";

export default  abstract class AbstractNode {
  private static NODE_TYPE_NAMES = [
    "Node", "Element", "Attribute", "Text", "CDATA", "Entity", "Entity", "ProcessingInstruction", "Comment",
    "Document", "DocumentType", "DocumentFragment", "Notation", "Namespace", "Unknown"
  ];

  private static DOCUMENT_FACTORY = new DocumentFactory();

  getNodeType(): number {
    return -1; // UNKNOWN_NODE
  }

  getNodeTypeName(): string {
    let type = this.getNodeType();

    if (type < 0 || type >= AbstractNode.NODE_TYPE_NAMES.length) {
      return "Unknown";
    }

    return AbstractNode.NODE_TYPE_NAMES[type];
  }

  getDocument(): Document | null {
    let element = this.getParent();

    return element ? element.getDocument() : null;
  }

  setDocument(document: Document) {}

  getParent(): Element | null {
    return null;
  }

  setParent(parent: Element) {}

  supportsParent(): boolean {
    return false;
  }

  isReadOnly(): boolean {
    return true;
  }

  hasContent(): boolean {
    return false;
  }

  getPath(): string {
    return ""; // Return the path
  }

  getUniquePath(): string {
    return ""; // Return the unique path
  }

  clone(): AbstractNode {
    if (this.isReadOnly()) {
      return this;
    } else {
      let answer = Object.create(this);
      answer.setParent(null);
      answer.setDocument(null);

      return answer;
    }
  }

  detach(): AbstractNode {
    let parent = this.getParent();

    if (parent) {
      parent.remove(this); // Assuming you have a remove method in the parent
    } else {
      let document = this.getDocument();

      if (document) {
        document.remove(this); // Assuming you have a remove method in the document
      }
    }

    this.setParent(null);
    this.setDocument(null);

    return this;
  }

  getName(): string | null {
    return null;
  }

  setName(name: string) {
    throw new Error("This node cannot be modified");
  }

  getText(): string | null {
    return null;
  }

  getStringValue(): string | null {
    return this.getText();
  }

  setText(text: string) {
    throw new Error("This node cannot be modified");
  }

  write(writer: any): void {
    writer.write(this.asXML());
  }

  // XPath methods
  selectObject(xpathExpression: string): any {
    let xpath = this.createXPath(xpathExpression);

    return xpath.evaluate(this);
  }

  selectNodes(xpathExpression: string): AbstractNode[] {
    let xpath = this.createXPath(xpathExpression);

    return xpath.selectNodes(this);
  }

  selectSingleNode(xpathExpression: string): AbstractNode | null {
    let xpath = this.createXPath(xpathExpression);

    return xpath.selectSingleNode(this);
  }

  valueOf(xpathExpression: string): string {
    let xpath = this.createXPath(xpathExpression);

    return xpath.valueOf(this);
  }

  numberValueOf(xpathExpression: string): number {
    let xpath = this.createXPath(xpathExpression);

    return xpath.numberValueOf(this);
  }

  matches(patternText: string): boolean {
    let filter = this.createXPathFilter(patternText);

    return filter.matches(this);
  }

  createXPath(xpathExpression: string): XPath {
    return AbstractNode.DOCUMENT_FACTORY.createXPath(xpathExpression);
  }

  createXPathFilter(patternText: string): NodeFilter {
    return AbstractNode.DOCUMENT_FACTORY.createXPathFilter(patternText);
  }

  createPattern(patternText: string): Pattern {
    return AbstractNode.DOCUMENT_FACTORY.createPattern(patternText);
  }

  asXPathResult(parent: Element): AbstractNode {
    if (this.supportsParent()) {
      return this;
    }

    return this.createXPathResult(parent);
  }

  protected getDocumentFactory(): DocumentFactory {
    return AbstractNode.DOCUMENT_FACTORY;
  }

  protected createXPathResult(parent: Element): AbstractNode {
    throw new Error("asXPathResult() not yet implemented fully for: " + this);
  }

  abstract asXML(): string;
}
