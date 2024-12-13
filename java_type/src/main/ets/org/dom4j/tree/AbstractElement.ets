import DocumentFactory from "../DocumentFactory";
import Element from "../Element";
import Node from "../Node";
import QName from "../QName";
import AbstractBranch from "./AbstractBranch";

export default  abstract class AbstractElement extends AbstractBranch implements Element {
  private static readonly DOCUMENT_FACTORY = DocumentFactory.getInstance();

  constructor() {
    super();
  }

  public getNodeType(): number {
    return 1;
  }

  public isRootElement(): boolean {
    const document = this.getDocument();
    if (document) {
      const root = document.getRootElement();
      return root === this;
    }
    return false;
  }

  public setName(name: string): void {
    this.setQName(this.getDocumentFactory().createQName(name));
  }

  public setNamespace(namespace: Namespace): void {
    this.setQName(this.getDocumentFactory().createQName(this.getName(), namespace));
  }

  public getXPathNameStep(): string {
    const uri = this.getNamespaceURI();
    if (uri && uri.length !== 0) {
      const prefix = this.getNamespacePrefix();
      return prefix && prefix.length !== 0 ? this.getQualifiedName() : `*[name()='${this.getName()}']`;
    } else {
      return this.getName();
    }
  }

  public getPath(context: Element): string {
    if (this === context) {
      return ".";
    } else {
      const parent = this.getParent();
      if (parent === null) {
        return `/${this.getXPathNameStep()}`;
      } else {
        return parent === context ? this.getXPathNameStep() : `${parent.getPath(context)}/${this.getXPathNameStep()}`;
      }
    }
  }

  public getUniquePath(context: Element): string {
    const parent = this.getParent();
    if (parent === null) {
      return `/${this.getXPathNameStep()}`;
    } else {
      const buffer: string[] = [];
      if (parent !== context) {
        buffer.push(parent.getUniquePath(context));
        buffer.push("/");
      }

      buffer.push(this.getXPathNameStep());
      const mySiblings = parent.elements(this.getQName());
      if (mySiblings.length > 1) {
        let idx = mySiblings.indexOf(this);
        if (idx >= 0) {
          buffer.push("[");
          ++idx;
          buffer.push(idx.toString());
          buffer.push("]");
        }
      }

      return buffer.join('');
    }
  }

  public asXML(): string {
    try {
      const out = new StringWriter();
      const writer = new XMLWriter(out, new OutputFormat());
      writer.write(this);
      writer.flush();
      return out.toString();
    } catch (e) {
      throw new Error(`IOException while generating textual representation: ${e.message}`);
    }
  }

  public write(out: Writer): void {
    const writer = new XMLWriter(out, new OutputFormat());
    writer.write(this);
  }

  public accept(visitor: Visitor): void {
    visitor.visit(this);
    for (let i = 0, size = this.attributeCount(); i < size; ++i) {
      const attribute = this.attribute(i);
      visitor.visit(attribute);
    }

    for (let i = 0, size = this.nodeCount(); i < size; ++i) {
      const node = this.node(i);
      node.accept(visitor);
    }
  }

  public toString(): string {
    const uri = this.getNamespaceURI();
    return uri && uri.length > 0
      ? `${super.toString()} [Element: <${this.getQualifiedName()} uri: ${uri} attributes: ${this.attributeList()}/>]`
      : `${super.toString()} [Element: <${this.getQualifiedName()} attributes: ${this.attributeList()}/>]`;
  }

  public getNamespace(): Namespace {
    return this.getQName().getNamespace();
  }

  public getName(): string {
    return this.getQName().getName();
  }

  public getNamespacePrefix(): string {
    return this.getQName().getNamespacePrefix();
  }

  public getNamespaceURI(): string {
    return this.getQName().getNamespaceURI();
  }

  public getQualifiedName(): string {
    return this.getQName().getQualifiedName();
  }

  public getData(): any {
    return this.getText();
  }

  public setData(data: any): void {}

  public node(index: number): Node | null {
    if (index >= 0) {
      const list = this.contentList();
      if (index < list.length) {
        return list[index] || null;
      }
    }
    return null;
  }

  public indexOf(node: Node): number {
    return this.contentList().indexOf(node);
  }

  public nodeCount(): number {
    return this.contentList().length;
  }

  public nodeIterator(): Iterator<Node> {
    return this.contentList()[Symbol.iterator]();
  }

  public element(name: string): Element | null {
    for (const node of this.contentList()) {
      if (node instanceof Element && name === node.getName()) {
        return node;
      }
    }
    return null;
  }

  public element(qName: QName): Element | null {
    for (const node of this.contentList()) {
      if (node instanceof Element && qName.equals(node.getQName())) {
        return node;
      }
    }
    return null;
  }

  public element(name: string, namespace: Namespace): Element | null {
    return this.element(this.getDocumentFactory().createQName(name, namespace));
  }

  public elements(): List<Element> {
    const answer = this.createResultList<Element>();
    for (const node of this.contentList()) {
      if (node instanceof Element) {
        answer.addLocal(node);
      }
    }
    return answer;
  }

  public elements(name: string): List<Element> {
    const answer = this.createResultList<Element>();
    for (const node of this.contentList()) {
      if (node instanceof Element && name === node.getName()) {
        answer.addLocal(node);
      }
    }
    return answer;
  }

  public elements(qName: QName): List<Element> {
    const answer = this.createResultList<Element>();
    for (const node of this.contentList()) {
      if (node instanceof Element && qName.equals(node.getQName())) {
        answer.addLocal(node);
      }
    }
    return answer;
  }

  public elements(name: string, namespace: Namespace): List<Element> {
    return this.elements(this.getDocumentFactory().createQName(name, namespace));
  }

  public elementIterator(): Iterator<Element> {
    return this.elements()[Symbol.iterator]();
  }

  public elementIterator(name: string): Iterator<Element> {
    return this.elements(name)[Symbol.iterator]();
  }

  public elementIterator(qName: QName): Iterator<Element> {
    return this.elements(qName)[Symbol.iterator]();
  }

  public elementIterator(name: string, ns: Namespace): Iterator<Element> {
    return this.elementIterator(this.getDocumentFactory().createQName(name, ns));
  }

  public attributes(): List<Attribute> {
    return new ContentListFacade<Attribute>(this, this.attributeList());
  }

  public attributeIterator(): Iterator<Attribute> {
    return this.attributeList()[Symbol.iterator]();
  }

  public attribute(index: number): Attribute {
    return this.attributeList()[index];
  }

  public attributeCount(): number {
    return this.attributeList().length;
  }

  public attribute(name: string): Attribute | null {
    for (const attribute of this.attributeList()) {
      if (name === attribute.getName()) {
        return attribute;
      }
    }
    return null;
  }

  public attribute(qName: QName): Attribute | null {
    for (const attribute of this.attributeList()) {
      if (qName.equals(attribute.getQName())) {
        return attribute;
      }
    }
    return null;
  }

  public attribute(name: string, namespace: Namespace): Attribute | null {
    return this.attribute(this.getDocumentFactory().createQName(name, namespace));
  }

  public setAttributes(attributes: Attributes, namespaceStack: NamespaceStack, noNamespaceAttributes: boolean): void {
    const size = attributes.getLength();
    if (size > 0) {
      const factory = this.getDocumentFactory();
      if (size === 1) {
        const name = attributes.getQName(0);
        if (noNamespaceAttributes || !name.startsWith("xmlns")) {
          const attributeURI = attributes.getURI(0);
          const attributeName = attributes.getLocalName(0);
          const attributeValue = attributes.getValue(0);
          const attributeQName = namespaceStack.getAttributeQName(attributeURI, attributeName, name);
          this.add(factory.createAttribute(this, attributeQName, attributeValue));
        }
      } else {
        const list = this.attributeList(size);
        list.length = 0;

        for (let i = 0; i < size; ++i) {
          const attributeName = attributes.getQName(i);
          if (noNamespaceAttributes || !attributeName.startsWith("xmlns")) {
            const attributeURI = attributes.getURI(i);
            const attributeLocalName = attributes.getLocalName(i);
            const attributeValue = attributes.getValue(i);
            const attributeQName = namespaceStack.getAttributeQName(attributeURI, attributeLocalName, attributeName);
            const attribute = factory.createAttribute(this, attributeQName, attributeValue);
            list.push(attribute);
            this.childAdded(attribute);
          }
        }
      }
    }
  }

  public attributeValue(name: string): string | null {
    const attrib = this.attribute(name);
    return attrib ? attrib.getValue() : null;
  }

  public attributeValue(qName: QName): string | null {
    const attrib = this.attribute(qName);
    return attrib ? attrib.getValue() : null;
  }

  public attributeValue(name: string, defaultValue: string): string {
    const answer = this.attributeValue(name);
    return answer !== null ? answer : defaultValue;
  }

  public attributeValue(qName: QName, defaultValue: string): string {
    const answer = this.attributeValue(qName);
    return answer !== null ? answer : defaultValue;
  }

  public setAttributeValue(name: string, value: string): void {
    this.addAttribute(name, value);
  }

  public setAttributeValue(qName: QName, value: string): void {
    this.addAttribute(qName, value);
  }

  public add(attribute: Attribute): void {
    if (attribute.getParent() !== null) {
      const message = `The Attribute already has an existing parent "${attribute.getParent().getQualifiedName()}"`;
      throw new IllegalAddException(this, attribute, message);
    } else {
      if (attribute.getValue() === null) {
        const oldAttribute = this.attribute(attribute.getQName());
        if (oldAttribute !== null) {
          this.remove(oldAttribute);
        }
      } else {
        this.attributeList().push(attribute);
        this.childAdded(attribute);
      }
    }
  }

  public remove(attribute: Attribute): boolean {
    const list = this.attributeList();
    let answer = list.splice(list.indexOf(attribute), 1).length > 0;
    if (answer) {
      this.childRemoved(attribute);
    } else {
      const copy = this.attribute(attribute.getQName());
      if (copy !== null) {
        list.splice(list.indexOf(copy), 1);
        answer = true;
      }
    }
    return answer;
  }

  public processingInstructions(): List<ProcessingInstruction> {
    const answer = this.createResultList<ProcessingInstruction>();
    for (const node of this.contentList()) {
      if (node instanceof ProcessingInstruction) {
        answer.addLocal(node);
      }
    }
    return answer;
  }

  public processingInstructions(target: string): List<ProcessingInstruction> {
    const answer = this.createResultList<ProcessingInstruction>();
    for (const node of this.contentList()) {
      if (node instanceof ProcessingInstruction && target === node.getName()) {
        answer.addLocal(node);
      }
    }
    return answer;
  }

  public processingInstruction(target: string): ProcessingInstruction | null {
    for (const node of this.contentList()) {
      if (node instanceof ProcessingInstruction && target === node.getName()) {
        return node;
      }
    }
    return null;
  }

  public removeProcessingInstruction(target: string): boolean {
    const iter = this.contentList();
    for (let i = 0; i < iter.length; i++) {
      const node = iter[i];
      if (node instanceof ProcessingInstruction && target === node.getName()) {
        iter.splice(i, 1);
        return true;
      }
    }
    return false;
  }

  public getXPathResult(index: number): Node | null {
    const answer = this.node(index);
    return answer && !answer.supportsParent() ? answer.asXPathResult(this) : answer;
  }

  public addAttribute(name: string, value: string): Element {
    let attribute = this.attribute(name);
    if (value !== null) {
      if (attribute === null) {
        this.add(this.getDocumentFactory().createAttribute(this, name, value));
      } else if (attribute.isReadOnly()) {
        this.remove(attribute);
        this.add(this.getDocumentFactory().createAttribute(this, name, value));
      } else {
        attribute.setValue(value);
      }
    } else if (attribute !== null) {
      this.remove(attribute);
    }
    return this;
  }

  public addAttribute(qName: QName, value: string): Element {
    let attribute = this.attribute(qName);
    if (value !== null) {
      if (attribute === null) {
        this.add(this.getDocumentFactory().createAttribute(this, qName, value));
      } else if (attribute.isReadOnly()) {
        this.remove(attribute);
        this.add(this.getDocumentFactory().createAttribute(this, qName, value));
      } else {
        attribute.setValue(value);
      }
    } else if (attribute !== null) {
      this.remove(attribute);
    }
    return this;
  }

  public addCDATA(cdata: string): Element {
    const node = this.getDocumentFactory().createCDATA(cdata);
    this.addNewNode(node);
    return this;
  }

  public addComment(comment: string): Element {
    const node = this.getDocumentFactory().createComment(comment);
    this.addNewNode(node);
    return this;
  }

  public addElement(name: string): Element {
    const factory = this.getDocumentFactory();
    let localName = name;
    let namespace: Namespace | null = null;
    const index = name.indexOf(":");
    if (index > 0) {
      const prefix = name.substring(0, index);
      localName = name.substring(index + 1);
      namespace = this.getNamespaceForPrefix(prefix);
      if (namespace === null) {
        throw new IllegalAddException(`No such namespace prefix: ${prefix} is in scope on: ${this} so cannot add element: ${name}`);
      }
    } else {
      namespace = this.getNamespaceForPrefix("");
    }

    let node: Element;
    if (namespace !== null) {
      const qname = factory.createQName(localName, namespace);
      node = factory.createElement(qname);
    } else {
      node = factory.createElement(name);
    }

    this.addNewNode(node);
    return node;
  }

  public addEntity(name: string, text: string): Element {
    const node = this.getDocumentFactory().createEntity(name, text);
    this.addNewNode(node);
    return this;
  }

  public addNamespace(prefix: string, uri: string): Element {
    const node = this.getDocumentFactory().createNamespace(prefix, uri);
    this.addNewNode(node);
    return this;
  }

  public addProcessingInstruction(target: string, data: string): Element {
    const node = this.getDocumentFactory().createProcessingInstruction(target, data);
    this.addNewNode(node);
    return this;
  }

  public addProcessingInstruction(target: string, data: Map<string, string>): Element {
    const node = this.getDocumentFactory().createProcessingInstruction(target, data);
    this.addNewNode(node);
    return this;
  }

  public addText(text: string): Element {
    const node = this.getDocumentFactory().createText(text);
    this.addNewNode(node);
    return this;
  }

  public add(node: Node): void {
    switch (node.getNodeType()) {
      case 1:
        this.add(node as Element);
        break;
      case 2:
        this.add(node as Attribute);
        break;
      case 3:
        this.add(node as Text);
        break;
      case 4:
        this.add(node as CDATA);
        break;
      case 5:
        this.add(node as Entity);
        break;
      case 7:
        this.add(node as ProcessingInstruction);
        break;
      case 8:
        this.add(node as Comment);
        break;
      case 13:
        this.add(node as Namespace);
        break;
      default:
        this.invalidNodeTypeAddException(node);
        break;
    }
  }

  public remove(node: Node): boolean {
    switch (node.getNodeType()) {
      case 1:
        return this.remove(node as Element);
      case 2:
        return this.remove(node as Attribute);
      case 3:
        return this.remove(node as Text);
      case 4:
        return this.remove(node as CDATA);
      case 5:
        return this.remove(node as Entity);
      case 7:
        return this.remove(node as ProcessingInstruction);
      case 8:
        return this.remove(node as Comment);
      case 13:
        return this.remove(node as Namespace);
      default:
        return false;
    }
  }

  public add(cdata: CDATA): void {
    this.addNode(cdata);
  }

  public add(comment: Comment): void {
    this.addNode(comment);
  }

  public add(element: Element): void {
    this.addNode(element);
  }

  public add(entity: Entity): void {
    this.addNode(entity);
  }

  public add(namespace: Namespace): void {
    this.addNode(namespace);
  }

  public add(pi: ProcessingInstruction): void {
    this.addNode(pi);
  }

  public add(text: Text): void {
    this.addNode(text);
  }

  public remove(cdata: CDATA): boolean {
    return this.removeNode(cdata);
  }

  public remove(comment: Comment): boolean {
    return this.removeNode(comment);
  }

  public remove(element: Element): boolean {
    return this.removeNode(element);
  }

  public remove(entity: Entity): boolean {
    return this.removeNode(entity);
  }

  public remove(namespace: Namespace): boolean {
    return this.removeNode(namespace);
  }

  public remove(pi: ProcessingInstruction): boolean {
    return this.removeNode(pi);
  }

  public remove(text: Text): boolean {
    return this.removeNode(text);
  }

  protected addNewNode(node: Node): void {
    this.addNode(node);
  }

  protected invalidNodeTypeAddException(node: Node): void {
    throw new Error(`Invalid node type. Cannot add node: ${node}`);
  }

  protected abstract attributeList(): List<Attribute>;

  protected abstract contentList(): List<Node>;

  protected abstract attributeList(size: number): List<Attribute>;

  protected abstract createResultList<T>(): List<T>;

  protected abstract getDocumentFactory(): DocumentFactory;

  protected abstract addNode(node: Node): void;

  protected abstract removeNode(node: Node): boolean;

  protected abstract childAdded(node: Node): void;

  protected abstract childRemoved(node: Node): void;

  protected abstract getQName(): QName;

  protected abstract setQName(qName: QName): void;

  protected abstract getNamespaceForPrefix(prefix: string): Namespace | null;

  protected abstract getParent(): Element | null;

  protected abstract getDocument(): Document | null;
}
