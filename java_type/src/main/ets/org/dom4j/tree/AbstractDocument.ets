export default  abstract class AbstractDocument extends AbstractBranch implements Document {
  protected encoding: string;

  constructor() {
    super();
  }

  public getNodeType(): number {
    return 9;
  }

  public getPath(context: Element): string {
    return "/";
  }

  public getUniquePath(context: Element): string {
    return "/";
  }

  public getDocument(): Document {
    return this;
  }

  public getXMLEncoding(): string | null {
    return null;
  }

  public getStringValue(): string {
    const root = this.getRootElement();
    return root != null ? root.getStringValue() : "";
  }

  public asXML(): string {
    const format = new OutputFormat();
    format.setEncoding(this.encoding);

    try {
      const out = new StringWriter();
      const writer = new XMLWriter(out, format);
      writer.write(this);
      writer.flush();
      return out.toString();
    } catch (var4) {
      const e: IOException = var4;
      throw new Error("IOException while generating textual representation: " + e.getMessage());
    }
  }

  public write(out: Writer): void {
    const format = new OutputFormat();
    format.setEncoding(this.encoding);
    const writer = new XMLWriter(out, format);
    writer.write(this);
  }

  public accept(visitor: Visitor): void {
    visitor.visit(this);
    const docType = this.getDocType();
    if (docType != null) {
      visitor.visit(docType);
    }

    const content: List<Node> = this.content();
    if (content != null) {
      const iterator: Iterator<Node> = content.iterator();
      while (iterator.hasNext()) {
        const node: Node = iterator.next();
        node.accept(visitor);
      }
    }
  }

  public toString(): string {
    return super.toString() + ` [Document: name ${this.getName()}]`;
  }

  public normalize(): void {
    const element = this.getRootElement();
    if (element != null) {
      element.normalize();
    }
  }

  public addComment(comment: string): Document {
    const node: Comment = this.getDocumentFactory().createComment(comment);
    this.add(node);
    return this;
  }

  public addProcessingInstruction(target: string, data: string): Document {
    const node: ProcessingInstruction = this.getDocumentFactory().createProcessingInstruction(target, data);
    this.add(node);
    return this;
  }

  public addProcessingInstruction(target: string, data: Map<string, string>): Document {
    const node: ProcessingInstruction = this.getDocumentFactory().createProcessingInstruction(target, data);
    this.add(node);
    return this;
  }

  public addElement(name: string): Element {
    const element: Element = this.getDocumentFactory().createElement(name);
    this.add(element);
    return element;
  }

  public addElement(qualifiedName: string, namespaceURI: string): Element {
    const element: Element = this.getDocumentFactory().createElement(qualifiedName, namespaceURI);
    this.add(element);
    return element;
  }

  public addElement(qName: QName): Element {
    const element: Element = this.getDocumentFactory().createElement(qName);
    this.add(element);
    return element;
  }

  public setRootElement(rootElement: Element): void {
    this.clearContent();
    if (rootElement != null) {
      super.add(rootElement);
      this.rootElementAdded(rootElement);
    }
  }

  public add(element: Element): void {
    this.checkAddElementAllowed(element);
    super.add(element);
    this.rootElementAdded(element);
  }

  public remove(element: Element): boolean {
    const answer = super.remove(element);
    const root = this.getRootElement();
    if (root != null && answer) {
      this.setRootElement(null);
    }

    element.setDocument(null);
    return answer;
  }

  public asXPathResult(parent: Element): Node {
    return this;
  }

  protected childAdded(node: Node): void {
    if (node != null) {
      node.setDocument(this);
    }
  }

  protected childRemoved(node: Node): void {
    if (node != null) {
      node.setDocument(null);
    }
  }

  protected checkAddElementAllowed(element: Element): void {
    const root = this.getRootElement();
    if (root != null) {
      throw new IllegalAddException(this, element, "Cannot add another element to this Document as it already has a root element of: " + root.getQualifiedName());
    }
  }

  protected abstract rootElementAdded(rootElement: Element): void;

  public setXMLEncoding(enc: string): void {
    this.encoding = enc;
  }
}