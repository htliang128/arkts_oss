import Node from "../Node";
import ContentListFacade from "./ContentListFacade";

export default  abstract class AbstractBranch extends AbstractNode implements Branch {
  protected static DEFAULT_CONTENT_LIST_SIZE: number = 5;

  public constructor() {}

  public isReadOnly(): boolean {
    return false;
  }

  public hasContent(): boolean {
    return this.nodeCount() > 0;
  }

  public content(): Node[] {
    const backingList = this.contentList();
    return new ContentListFacade(this, backingList);
  }

  public getText(): string {
    const content = this.contentList();
    if (content) {
      const size = content.length;
      if (size >= 1) {
        const first = content[0];
        const firstText = this.getContentAsText(first);
        if (size === 1) {
          return firstText;
        }

        const buffer = [firstText];

        for (let i = 1; i < size; i++) {
          const node = content[i];
          buffer.push(this.getContentAsText(node));
        }

        return buffer.join('');
      }
    }

    return '';
  }

  protected getContentAsText(content: any): string {
    if (content instanceof Node) {
      const node = content;
      switch (node.getNodeType()) {
        case 3:
        case 4:
        case 5:
          return node.getText();
      }
    } else if (typeof content === 'string') {
      return content;
    }

    return '';
  }

  protected getContentAsStringValue(content: any): string {
    if (content instanceof Node) {
      const node = content;
      switch (node.getNodeType()) {
        case 1:
        case 3:
        case 4:
        case 5:
          return node.getStringValue();
        case 2:
          break;
      }
    } else if (typeof content === 'string') {
      return content;
    }

    return '';
  }

  public getTextTrim(): string {
    const text = this.getText();
    const textContent: string[] = [];
    const tokenizer = text.split(/\s+/);

    for (const str of tokenizer) {
      textContent.push(str);
    }

    return textContent.join(' ');
  }

  public setProcessingInstructions(listOfPIs: ProcessingInstruction[]): void {
    for (const pi of listOfPIs) {
      this.addNode(pi);
    }
  }

  public addElement(name: string): Element {
    const node = this.getDocumentFactory().createElement(name);
    this.add(node);
    return node;
  }

  public addElement(qualifiedName: string, namespaceURI: string): Element {
    const node = this.getDocumentFactory().createElement(qualifiedName, namespaceURI);
    this.add(node);
    return node;
  }

  public addElement(qname: QName): Element {
    const node = this.getDocumentFactory().createElement(qname);
    this.add(node);
    return node;
  }

  public addElement(name: string, prefix: string, uri: string): Element {
    const namespace = Namespace.get(prefix, uri);
    const qName = this.getDocumentFactory().createQName(name, namespace);
    return this.addElement(qName);
  }

  public add(node: Node): void {
    switch (node.getNodeType()) {
      case 1:
        this.add(node as Element);
        break;
      case 7:
        this.add(node as ProcessingInstruction);
        break;
      case 8:
        this.add(node as Comment);
        break;
      default:
        this.invalidNodeTypeAddException(node);
    }
  }

  public remove(node: Node): boolean {
    switch (node.getNodeType()) {
      case 1:
        return this.remove(node as Element);
      case 7:
        return this.remove(node as ProcessingInstruction);
      case 8:
        return this.remove(node as Comment);
      default:
        this.invalidNodeTypeAddException(node);
        return false;
    }
  }

  public add(comment: Comment): void {
    this.addNode(comment);
  }

  public add(element: Element): void {
    this.addNode(element);
  }

  public add(pi: ProcessingInstruction): void {
    this.addNode(pi);
  }

  public remove(comment: Comment): boolean {
    return this.removeNode(comment);
  }

  public remove(element: Element): boolean {
    return this.removeNode(element);
  }

  public remove(pi: ProcessingInstruction): boolean {
    return this.removeNode(pi);
  }

  public elementByID(elementID: string): Element | null {
    for (let i = 0; i < this.nodeCount(); i++) {
      const node = this.node(i);
      if (node instanceof Element) {
        const element = node as Element;
        const id = this.elementID(element);
        if (id && id === elementID) {
          return element;
        }

        const foundElement = element.elementByID(elementID);
        if (foundElement) {
          return foundElement;
        }
      }
    }

    return null;
  }

  public appendContent(branch: Branch): void {
    for (let i = 0; i < branch.nodeCount(); i++) {
      const node = branch.node(i);
      this.add(node.clone() as Node);
    }
  }

  public node(index: number): Node {
    return this.contentList()[index];
  }

  public nodeCount(): number {
    return this.contentList().length;
  }

  public indexOf(node: Node): number {
    return this.contentList().indexOf(node);
  }

  public nodeIterator(): Iterator<Node> {
    return this.contentList()[Symbol.iterator]();
  }

  protected elementID(element: Element): string | null {
    return element.attributeValue('ID');
  }

  protected abstract contentList(): Node[];

  protected createContentList(): Node[] {
    return new Array<Node>(AbstractBranch.DEFAULT_CONTENT_LIST_SIZE);
  }

  protected createContentList(size: number): Node[] {
    return new Array<Node>(size);
  }

  protected createResultList<T extends Node>(): BackedList<T> {
    return new BackedList(this, this.contentList());
  }

  protected createSingleResultList<T extends Node>(result: T): List<T> {
    const list = new BackedList(this, this.contentList(), 1);
    list.addLocal(result);
    return list;
  }

  protected createEmptyList<T extends Node>(): List<T> {
    return new BackedList(this, this.contentList(), 0);
  }

  protected abstract addNode(node: Node): void;

  protected abstract addNode(index: number, node: Node): void;

  protected abstract removeNode(node: Node): boolean;

  protected abstract childAdded(node: Node): void;

  protected abstract childRemoved(node: Node): void;

  protected contentRemoved(): void {
    const content = this.contentList();
    for (const node of content) {
      this.childRemoved(node);
    }
  }

  protected invalidNodeTypeAddException(node: Node): void {
    throw new IllegalAddException(`Invalid node type. Cannot add node: ${node} to this branch: ${this}`);
  }
}