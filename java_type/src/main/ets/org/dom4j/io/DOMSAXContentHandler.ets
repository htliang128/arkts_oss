export default class DOMSAXContentHandler extends DefaultHandler implements LexicalHandler {
  private documentFactory: DOMDocumentFactory;
  private document: Document | null;
  private elementStack: ElementStack;
  private namespaceStack: NamespaceStack;
  private locator: Locator | null;
  private insideCDATASection: boolean;
  private cdataText: StringBuffer;
  private declaredNamespaceIndex: number;
  private inputSource: InputSource | null;
  private currentElement: Element | null;
  private entityResolver: EntityResolver | null;
  private mergeAdjacentText: boolean;
  private textInTextBuffer: boolean;
  private ignoreComments: boolean;
  private textBuffer: StringBuffer | null;
  private stripWhitespaceText: boolean;

  constructor();
  constructor(documentFactory: DOMDocumentFactory);
  constructor(arg1?: DOMDocumentFactory) {
    this.mergeAdjacentText = false;
    this.textInTextBuffer = false;
    this.ignoreComments = false;
    this.stripWhitespaceText = false;
    this.documentFactory = arg1 || DOMDocumentFactory.getInstance();
    this.elementStack = this.createElementStack();
    this.namespaceStack = new NamespaceStack(this.documentFactory);
    this.document = null;
    this.locator = null;
    this.insideCDATASection = false;
    this.cdataText = new StringBuffer();
    this.declaredNamespaceIndex = 0;
    this.inputSource = null;
    this.currentElement = null;
    this.entityResolver = null;
    this.textBuffer = null;
  }

  getDocument(): Document {
    if (this.document === null) {
      this.document = this.createDocument();
    }
    return this.document;
  }

  setDocumentLocator(documentLocator: Locator): void {
    this.locator = documentLocator;
  }

  processingInstruction(target: string, data: string): void {
    if (this.mergeAdjacentText && this.textInTextBuffer) {
      this.completeCurrentTextNode();
    }

    const pi: ProcessingInstruction = this.documentFactory.createProcessingInstruction(target, data);
    if (this.currentElement !== null) {
      this.currentElement.appendChild(pi);
    } else {
      this.getDocument().appendChild(pi);
    }
  }

  startPrefixMapping(prefix: string, uri: string): void {
    this.namespaceStack.push(prefix, uri);
  }

  endPrefixMapping(prefix: string): void {
    this.namespaceStack.pop(prefix);
    this.declaredNamespaceIndex = this.namespaceStack.size();
  }

  startDocument(): void {
    this.document = null;
    this.currentElement = null;
    this.elementStack.clear();
    this.namespaceStack.clear();
    this.declaredNamespaceIndex = 0;
    if (this.mergeAdjacentText && this.textBuffer === null) {
      this.textBuffer = new StringBuffer();
    }
    this.textInTextBuffer = false;
  }

  endDocument(): void {
    this.namespaceStack.clear();
    this.elementStack.clear();
    this.currentElement = null;
    this.textBuffer = null;
  }

  startElement(namespaceURI: string, localName: string, qualifiedName: string, attributes: Attributes): void {
    if (this.mergeAdjacentText && this.textInTextBuffer) {
      this.completeCurrentTextNode();
    }

    const qName: QName = this.namespaceStack.getQName(namespaceURI, localName, qualifiedName);
    let branch: Branch | null = this.currentElement;
    if (branch === null) {
      branch = this.getDocument();
    }

    const element: Element = new DOMElement(qName);
    branch.add(element);
    this.addDeclaredNamespaces(element);
    this.addAttributes(element, attributes);
    this.elementStack.pushElement(element);
    this.currentElement = element;
  }

  endElement(namespaceURI: string, localName: string, qName: string): void {
    if (this.mergeAdjacentText && this.textInTextBuffer) {
      this.completeCurrentTextNode();
    }

    this.elementStack.popElement();
    this.currentElement = this.elementStack.peekElement();
  }

  characters(ch: string[], start: number, end: number): void {
    if (end !== 0) {
      if (this.currentElement !== null) {
        if (this.insideCDATASection) {
          if (this.mergeAdjacentText && this.textInTextBuffer) {
            this.completeCurrentTextNode();
          }
          this.cdataText.append(ch.join('').substring(start, end));
        } else if (this.mergeAdjacentText) {
          this.textBuffer!.append(ch.join('').substring(start, end));
          this.textInTextBuffer = true;
        } else {
          const text: DOMText = new DOMText(ch.join('').substring(start, end));
          this.currentElement.add(text);
        }
      }
    }
  }

  warning(exception: SAXParseException): void {}

  error(exception: SAXParseException): void {
    throw exception;
  }

  fatalError(exception: SAXParseException): void {
    throw exception;
  }

  startDTD(name: string, publicId: string, systemId: string): void {}

  endDTD(): void {}

  startEntity(name: string): void {}

  endEntity(name: string): void {}

  startCDATA(): void {
    this.insideCDATASection = true;
    this.cdataText = new StringBuffer();
  }

  endCDATA(): void {
    this.insideCDATASection = false;
    const cdata: DOMCDATA = new DOMCDATA(this.cdataText.toString());
    this.currentElement!.add(cdata);
  }

  comment(ch: string[], start: number, end: number): void {
    if (!this.ignoreComments) {
      if (this.mergeAdjacentText && this.textInTextBuffer) {
        this.completeCurrentTextNode();
      }

      const text: string = ch.join('').substring(start, end);
      if (text.length > 0) {
        const domComment: DOMComment = new DOMComment(text);
        if (this.currentElement !== null) {
          this.currentElement.add(domComment);
        } else {
          this.getDocument().appendChild(domComment);
        }
      }
    }
  }

  getElementStack(): ElementStack {
    return this.elementStack;
  }

  setElementStack(elementStack: ElementStack): void {
    this.elementStack = elementStack;
  }

  getEntityResolver(): EntityResolver | null {
    return this.entityResolver;
  }

  setEntityResolver(entityResolver: EntityResolver): void {
    this.entityResolver = entityResolver;
  }

  getInputSource(): InputSource | null {
    return this.inputSource;
  }

  setInputSource(inputSource: InputSource): void {
    this.inputSource = inputSource;
  }

  isMergeAdjacentText(): boolean {
    return this.mergeAdjacentText;
  }

  setMergeAdjacentText(mergeAdjacentText: boolean): void {
    this.mergeAdjacentText = mergeAdjacentText;
  }

  isStripWhitespaceText(): boolean {
    return this.stripWhitespaceText;
  }

  setStripWhitespaceText(stripWhitespaceText: boolean): void {
    this.stripWhitespaceText = stripWhitespaceText;
  }

  isIgnoreComments(): boolean {
    return this.ignoreComments;
  }

  setIgnoreComments(ignoreComments: boolean): void {
    this.ignoreComments = ignoreComments;
  }

  protected completeCurrentTextNode(): void {
    if (this.stripWhitespaceText) {
      let whitespace: boolean = true;
      for (let i = 0; i < this.textBuffer!.length; i++) {
        if (!Character.isWhitespace(this.textBuffer!.charAt(i))) {
          whitespace = false;
          break;
        }
      }
      if (!whitespace) {
        const domText: DOMText = new DOMText(this.textBuffer!.toString());
        this.currentElement!.add(domText);
      }
    } else {
      const domText: DOMText = new DOMText(this.textBuffer!.toString());
      this.currentElement!.add(domText);
    }

    this.textBuffer!.setLength(0);
    this.textInTextBuffer = false;
  }

  protected createDocument(): Document {
    const encoding: string | null = this.getEncoding();
    const doc: Document = this.documentFactory.createDocument(encoding);
    doc.setEntityResolver(this.entityResolver);
    if (this.inputSource !== null) {
      doc.setName(this.inputSource.getSystemId());
    }
    return doc;
  }

  private getEncoding(): string | null {
    if (this.locator === null) {
      return null;
    } else {
      return this.locator instanceof Locator2 ? (this.locator as Locator2).getEncoding() : null;
    }
  }

  protected addDeclaredNamespaces(element: Element): void {
    for (let size = this.namespaceStack.size(); this.declaredNamespaceIndex < size; this.declaredNamespaceIndex++) {
      const namespace: Namespace = this.namespaceStack.getNamespace(this.declaredNamespaceIndex);
      const attributeName: string = this.attributeNameForNamespace(namespace);
      element.setAttribute(attributeName, namespace.getURI());
    }
  }

  protected addAttributes(element: Element, attributes: Attributes): void {
    const size: number = attributes.getLength();
    for (let i = 0; i < size; i++) {
      const attributeQName: string = attributes.getQName(i);
      if (!attributeQName.startsWith("xmlns")) {
        const attributeURI: string = attributes.getURI(i);
        const attributeLocalName: string = attributes.getLocalName(i);
        const attributeValue: string = attributes.getValue(i);
        const qName: QName = this.namespaceStack.getAttributeQName(attributeURI, attributeLocalName, attributeQName);
        const domAttribute: DOMAttribute = new DOMAttribute(qName, attributeValue);
        element.setAttributeNode(domAttribute);
      }
    }
  }

  protected createElementStack(): ElementStack {
    return new ElementStack();
  }

  protected attributeNameForNamespace(namespace: Namespace): string {
    const xmlns: string = "xmlns";
    const prefix: string = namespace.getPrefix();
    return prefix.length > 0 ? `${xmlns}:${prefix}` : xmlns;
  }
}
