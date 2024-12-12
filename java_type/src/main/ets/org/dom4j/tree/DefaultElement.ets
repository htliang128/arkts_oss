export default  class DefaultElement extends AbstractElement {
  private static readonly DOCUMENT_FACTORY = DocumentFactory.getInstance();
  private qname: QName;
  private parentBranch: Branch | null;
  private content: any;
  private attributes: any;

  public constructor(name: string);
  public constructor(qname: QName);
  public constructor(qname: QName, attributeCount: number);
  public constructor(name: string, namespace: Namespace);
  public constructor(...args: any[]) {
    if (typeof args[0] === 'string') {
      this.qname = DefaultElement.DOCUMENT_FACTORY.createQName(args[0]);
    } else {
      this.qname = args[0];
      if (args.length > 1 && args[1] > 1) {
        this.attributes = new Array(args[1]);
      }
    }
  }

  public getParent(): Element | null {
    return this.parentBranch instanceof Element ? this.parentBranch : null;
  }

  public setParent(parent: Element | null): void {
    if (this.parentBranch instanceof Element || parent !== null) {
      this.parentBranch = parent;
    }
  }

  public getDocument(): Document | null {
    if (this.parentBranch instanceof Document) {
      return this.parentBranch;
    } else if (this.parentBranch instanceof Element) {
      return (this.parentBranch as Element).getDocument();
    } else {
      return null;
    }
  }

  public setDocument(document: Document | null): void {
    if (this.parentBranch instanceof Document || document !== null) {
      this.parentBranch = document;
    }
  }

  public supportsParent(): boolean {
    return true;
  }

  public getQName(): QName {
    return this.qname;
  }

  public setQName(name: QName): void {
    this.qname = name;
  }

  public getText(): string {
    const contentShadow = this.content;
    if (Array.isArray(contentShadow)) {
      return super.getText();
    } else {
      return contentShadow !== null ? this.getContentAsText(contentShadow) : "";
    }
  }

  public getStringValue(): string {
    const contentShadow = this.content;
    if (Array.isArray(contentShadow)) {
      const size = contentShadow.length;
      if (size > 0) {
        if (size === 1) {
          return this.getContentAsStringValue(contentShadow[0]);
        }

        const buffer: string[] = [];
        for (const node of contentShadow) {
          const string = this.getContentAsStringValue(node);
          if (string.length > 0) {
            buffer.push(string);
          }
        }

        return buffer.join('');
      }
    } else if (contentShadow !== null) {
      return this.getContentAsStringValue(contentShadow);
    }

    return "";
  }

  public clone(): DefaultElement {
    const answer = super.clone() as DefaultElement;
    if (answer !== this) {
      answer.content = null;
      answer.attributes = null;
      answer.appendAttributes(this);
      answer.appendContent(this);
    }

    return answer;
  }

  public getNamespaceForPrefix(prefix: string | null): Namespace | null {
    if (prefix === null) {
      prefix = "";
    }

    if (prefix === this.getNamespacePrefix()) {
      return this.getNamespace();
    } else if (prefix === "xml") {
      return Namespace.XML_NAMESPACE;
    } else {
      const contentShadow = this.content;
      let answer: Namespace | null = null;
      if (Array.isArray(contentShadow)) {
        for (const node of contentShadow) {
          if (node instanceof Namespace) {
            const namespace = node as Namespace;
            if (prefix === namespace.getPrefix()) {
              return namespace;
            }
          }
        }
      } else if (contentShadow instanceof Namespace) {
        answer = contentShadow as Namespace;
        if (prefix === answer.getPrefix()) {
          return answer;
        }
      }

      const parent = this.getParent();
      if (parent !== null) {
        answer = parent.getNamespaceForPrefix(prefix);
        if (answer !== null) {
          return answer;
        }
      }

      return prefix.length <= 0 ? Namespace.NO_NAMESPACE : null;
    }
  }

  public getNamespaceForURI(uri: string | null): Namespace | null {
    if (uri && uri.length > 0) {
      if (uri === this.getNamespaceURI()) {
        return this.getNamespace();
      } else {
        const contentShadow = this.content;
        if (Array.isArray(contentShadow)) {
          for (const node of contentShadow) {
            if (node instanceof Namespace) {
              const namespace = node as Namespace;
              if (uri === namespace.getURI()) {
                return namespace;
              }
            }
          }
        } else if (contentShadow instanceof Namespace) {
          const namespace = contentShadow as Namespace;
          if (uri === namespace.getURI()) {
            return namespace;
          }
        }

        const parent = this.getParent();
        return parent !== null ? parent.getNamespaceForURI(uri) : null;
      }
    } else {
      return Namespace.NO_NAMESPACE;
    }
  }

  public declaredNamespaces(): Namespace[] {
    const answer = this.createResultList<Namespace>();
    const contentShadow = this.content;
    if (Array.isArray(contentShadow)) {
      for (const node of contentShadow) {
        if (node instanceof Namespace) {
          answer.addLocal(node as Namespace);
        }
      }
    } else if (contentShadow instanceof Namespace) {
      answer.addLocal(contentShadow as Namespace);
    }

    return answer;
  }

  public additionalNamespaces(): Namespace[] {
    const contentShadow = this.content;
    if (Array.isArray(contentShadow)) {
      const answer = this.createResultList<Namespace>();
      for (const node of contentShadow) {
        if (node instanceof Namespace) {
          const namespace = node as Namespace;
          if (!namespace.equals(this.getNamespace())) {
            answer.addLocal(namespace);
          }
        }
      }

      return answer;
    } else if (contentShadow instanceof Namespace) {
      const namespace = contentShadow as Namespace;
      return namespace.equals(this.getNamespace()) ? this.createEmptyList() : this.createSingleResultList(namespace);
    } else {
      return this.createEmptyList();
    }
  }

  public additionalNamespaces(defaultNamespaceURI: string): Namespace[] {
    const contentShadow = this.content;
    if (Array.isArray(contentShadow)) {
      const answer = this.createResultList<Namespace>();
      for (const node of contentShadow) {
        if (node instanceof Namespace) {
          const namespace = node as Namespace;
          if (namespace.getURI() !== defaultNamespaceURI) {
            answer.addLocal(namespace);
          }
        }
      }

      return answer;
    } else {
      if (contentShadow instanceof Namespace) {
        const namespace = contentShadow as Namespace;
        if (namespace.getURI() !== defaultNamespaceURI) {
          return this.createSingleResultList(namespace);
        }
      }

      return this.createEmptyList();
    }
  }

  public processingInstructions(): ProcessingInstruction[] {
    const contentShadow = this.content;
    if (Array.isArray(contentShadow)) {
      const answer = this.createResultList<ProcessingInstruction>();
      for (const node of contentShadow) {
        if (node instanceof ProcessingInstruction) {
          answer.addLocal(node as ProcessingInstruction);
        }
      }

      return answer;
    } else {
      return contentShadow instanceof ProcessingInstruction ? this.createSingleResultList(contentShadow as ProcessingInstruction) : this.createEmptyList();
    }
  }

  public processingInstructions(target: string): ProcessingInstruction[] {
    const shadow = this.content;
    if (Array.isArray(shadow)) {
      const answer = this.createResultList<ProcessingInstruction>();
      for (const node of shadow) {
        if (node instanceof ProcessingInstruction) {
          const pi = node as ProcessingInstruction;
          if (target === pi.getName()) {
            answer.addLocal(pi);
          }
        }
      }

      return answer;
    } else {
      if (shadow instanceof ProcessingInstruction) {
        const pi = shadow as ProcessingInstruction;
        if (target === pi.getName()) {
          return this.createSingleResultList(pi);
        }
      }

      return this.createEmptyList();
    }
  }

  public processingInstruction(target: string): ProcessingInstruction | null {
    const shadow = this.content;
    if (Array.isArray(shadow)) {
      for (const node of shadow) {
        if (node instanceof ProcessingInstruction) {
          const pi = node as ProcessingInstruction;
          if (target === pi.getName()) {
            return pi;
          }
        }
      }
    } else if (shadow instanceof ProcessingInstruction) {
      const pi = shadow as ProcessingInstruction;
      if (target === pi.getName()) {
        return pi;
      }
    }

    return null;
  }

  public removeProcessingInstruction(target: string): boolean {
    const shadow = this.content;
    if (Array.isArray(shadow)) {
      const iter = shadow[Symbol.iterator]();
      let result = false;
      let next;
      while (!(next = iter.next()).done) {
        const node = next.value;
        if (node instanceof ProcessingInstruction) {
          const pi = node as ProcessingInstruction;
          if (target === pi.getName()) {
            iter.remove();
            result = true;
          }
        }
      }
      return result;
    } else if (shadow instanceof ProcessingInstruction) {
      const pi = shadow as ProcessingInstruction;
      if (target === pi.getName()) {
        this.content = null;
        return true;
      }
    }

    return false;
  }

  public element(name: string): Element | null {
    const contentShadow = this.content;
    if (Array.isArray(contentShadow)) {
      for (const node of contentShadow) {
        if (node instanceof Element) {
          const element = node as Element;
          if (name === element.getName()) {
            return element;
          }
        }
      }
    } else if (contentShadow instanceof Element) {
      const element = contentShadow as Element;
      if (name === element.getName()) {
        return element;
      }
    }

    return null;
  }

  public element(qName: QName): Element | null {
    const contentShadow = this.content;
    if (Array.isArray(contentShadow)) {
      for (const node of contentShadow) {
        if (node instanceof Element) {
          const element = node as Element;
          if (qName.equals(element.getQName())) {
            return element;
          }
        }
      }
    } else if (contentShadow instanceof Element) {
      const element = contentShadow as Element;
      if (qName.equals(element.getQName())) {
        return element;
      }
    }

    return null;
  }

  public element(name: string, namespace: Namespace): Element | null {
    return this.element(this.getDocumentFactory().createQName(name, namespace));
  }

  public setContent(content: Node[]): void {
    this.contentRemoved();
    if (content instanceof ContentListFacade) {
      content = (content as ContentListFacade).getBackingList();
    }

    if (content === null) {
      this.content = null;
    } else {
      const size = content.length;
      const newContent = this.createContentList(size);
      for (const node of content) {
        const parent = node.getParent();
        if (parent !== null && parent !== this) {
          node = node.clone();
        }

        newContent.push(node);
        this.childAdded(node);
      }

      this.content = newContent;
    }
  }

  public clearContent(): void {
    if (this.content !== null) {
      this.contentRemoved();
      this.content = null;
    }
  }

  public node(index: number): Node | null {
    if (index >= 0) {
      const contentShadow = this.content;
      let node: Node | null;
      if (Array.isArray(contentShadow)) {
        if (index >= contentShadow.length) {
          return null;
        }

        node = contentShadow[index];
      } else {
        node = index === 0 ? (contentShadow as Node) : null;
      }

      return node;
    } else {
      return null;
    }
  }

  public indexOf(node: Node): number {
    const contentShadow = this.content;
    if (Array.isArray(contentShadow)) {
      return contentShadow.indexOf(node);
    } else {
      return contentShadow !== null && contentShadow === node ? 0 : -1;
    }
  }

  public nodeCount(): number {
    const contentShadow = this.content;
    if (Array.isArray(contentShadow)) {
      return contentShadow.length;
    } else {
      return contentShadow !== null ? 1 : 0;
    }
  }

  public nodeIterator(): Iterator<Node> {
    const contentShadow = this.content;
    if (Array.isArray(contentShadow)) {
      return contentShadow[Symbol.iterator]();
    } else {
      return contentShadow !== null ? this.createSingleIterator(contentShadow as Node) : [] [Symbol.iterator]();
    }
  }

  public attributes(): Attribute[] {
    return new ContentListFacade(this, this.attributeList());
  }

  public setAttributes(attributes: Attribute[]): void {
    if (attributes instanceof ContentListFacade) {
      attributes = (attributes as ContentListFacade).getBackingList();
    }

    this.attributes = attributes;
  }

  public attributeIterator(): Iterator<Attribute> {
    const attributesShadow = this.attributes;
    if (Array.isArray(attributesShadow)) {
      return attributesShadow[Symbol.iterator]();
    } else {
      return attributesShadow !== null ? this.createSingleIterator(attributesShadow as Attribute) : [] [Symbol.iterator]();
    }
  }

  public attribute(index: number): Attribute | null {
    const attributesShadow = this.attributes;
    if (Array.isArray(attributesShadow)) {
      return attributesShadow[index] as Attribute;
    } else {
      return attributesShadow !== null && index === 0 ? (attributesShadow as Attribute) : null;
    }
  }

  public attributeCount(): number {
    const attributesShadow = this.attributes;
    if (Array.isArray(attributesShadow)) {
      return attributesShadow.length;
    } else {
      return attributesShadow !== null ? 1 : 0;
    }
  }

  public attribute(name: string): Attribute | null {
    const attributesShadow = this.attributes;
    if (Array.isArray(attributesShadow)) {
      for (const attribute of attributesShadow) {
        if (name === attribute.getName()) {
          return attribute;
        }
      }
    } else if (attributesShadow !== null) {
      const attribute = attributesShadow as Attribute;
      if (name === attribute.getName()) {
        return attribute;
      }
    }

    return null;
  }

  public attribute(qName: QName): Attribute | null {
    const attributesShadow = this.attributes;
    if (Array.isArray(attributesShadow)) {
      for (const attribute of attributesShadow) {
        if (qName.equals(attribute.getQName())) {
          return attribute;
        }
      }
    } else if (attributesShadow !== null) {
      const attribute = attributesShadow as Attribute;
      if (qName.equals(attribute.getQName())) {
        return attribute;
      }
    }

    return null;
  }

  public attribute(name: string, namespace: Namespace): Attribute | null {
    return this.attribute(this.getDocumentFactory().createQName(name, namespace));
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
        if (this.attributes === null) {
          this.attributes = attribute;
        } else {
          this.attributeList().push(attribute);
        }

        this.childAdded(attribute);
      }
    }
  }

  public remove(attribute: Attribute): boolean {
    let answer = false;
    const attributesShadow = this.attributes;
    if (Array.isArray(attributesShadow)) {
      answer = attributesShadow.remove(attribute);
      if (!answer) {
        const copy = this.attribute(attribute.getQName());
        if (copy !== null) {
          attributesShadow.remove(copy);
          answer = true;
        }
      }
    } else if (attributesShadow !== null) {
      if (attribute === attributesShadow) {
        this.attributes = null;
        answer = true;
      } else {
        const other = attributesShadow as Attribute;
        if (attribute.getQName().equals(other.getQName())) {
          this.attributes = null;
          answer = true;
        }
      }
    }

    if (answer) {
      this.childRemoved(attribute);
    }

    return answer;
  }

  protected addNewNode(node: Node): void {
    const contentShadow = this.content;
    if (contentShadow === null) {
      this.content = node;
    } else {
      let list: Node[];
      if (Array.isArray(contentShadow)) {
        list = contentShadow;
        list.push(node);
      } else {
        list = this.createContentList();
        list.push(contentShadow as Node);
        list.push(node);
        this.content = list;
      }
    }

    this.childAdded(node);
  }

  protected removeNode(node: Node): boolean {
    let answer = false;
    const contentShadow = this.content;
    if (contentShadow !== null) {
      if (contentShadow === node) {
        this.content = null;
        answer = true;
      } else if (Array.isArray(contentShadow)) {
        const list = contentShadow;
        answer = list.remove(node);
      }
    }

    if (answer) {
      this.childRemoved(node);
    }

    return answer;
  }

  protected contentList(): Node[] {
    const contentShadow = this.content;
    if (Array.isArray(contentShadow)) {
      return contentShadow;
    } else {
      const list: Node[] = this.createContentList();
      if (contentShadow !== null) {
        list.push(contentShadow as Node);
      }
      return list;
    }
  }

  protected attributeList(): Attribute[] {
    const attributesShadow = this.attributes;
    if (Array.isArray(attributesShadow)) {
      return attributesShadow;
    } else {
      const list: Attribute[] = this.createAttributeList();
      if (attributesShadow !== null) {
        list.push(attributesShadow as Attribute);
      }
      return list;
    }
  }

  protected contentRemoved(): void {
    const contentShadow = this.content;
    if (Array.isArray(contentShadow)) {
      for (const node of contentShadow) {
        this.childRemoved(node);
      }
    } else if (contentShadow !== null) {
      this.childRemoved(contentShadow as Node);
    }
  }

  protected childAdded(node: Node): void {
    // Implement child added logic here if needed
  }

  protected childRemoved(node: Node): void {
    // Implement child removed logic here if needed
  }

  protected createContentList(size?: number): Node[] {
    return size ? new Array(size) : [];
  }

  protected createAttributeList(size?: number): Attribute[] {
    return size ? new Array(size) : [];
  }

  protected createSingleResultList<T>(item: T): T[] {
    return [item];
  }

  protected createEmptyList<T>(): T[] {
    return [];
  }

  protected createSingleIterator<T>(item: T): Iterator<T> {
    let done = false;
    return {
      next(): IteratorResult<T> {
        if (done) {
          return { done: true, value: undefined as any };
        }
        done = true;
        return { done: false, value: item };
      },
    };
  }

  protected getContentAsText(node: Node): string {
    // Implement conversion of node to text
    return '';
  }

  protected getContentAsStringValue(node: Node): string {
    // Implement conversion of node to string value
    return '';
  }

  protected getNamespaceURI(): string {
    // Implement logic to get namespace URI
    return '';
  }

  protected getNamespacePrefix(): string {
    // Implement logic to get namespace prefix
    return '';
  }

  protected getNamespace(): Namespace | null {
    // Implement logic to get the namespace
    return null;
  }

  protected getDocumentFactory(): DocumentFactory {
    return DefaultElement.DOCUMENT_FACTORY;
  }
}
