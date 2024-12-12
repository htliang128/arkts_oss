export default class SAXContentHandler extends DefaultHandler implements LexicalHandler, DeclHandler, DTDHandler {
  private documentFactory: DocumentFactory;
  private document: Document;
  private elementStack: ElementStack;
  private namespaceStack: NamespaceStack;
  private elementHandler: ElementHandler;
  private locator: Locator;
  private entity: string;
  private insideDTDSection: boolean;
  private insideCDATASection: boolean;
  private cdataText: StringBuffer;
  private internalDTDDeclarations: List<Decl>;
  private externalDTDDeclarations: List<Decl>;
  private declaredNamespaceIndex: number;
  private entityResolver: EntityResolver;
  private inputSource: InputSource;
  private currentElement: Element;
  private includeInternalDTDDeclarations: boolean;
  private includeExternalDTDDeclarations: boolean;
  private entityLevel: number;
  private internalDTDsubset: boolean;
  private mergeAdjacentText: boolean;
  private textInTextBuffer: boolean;
  private ignoreComments: boolean;
  private textBuffer: StringBuffer;
  private stripWhitespaceText: boolean;

  constructor() {
    this(DocumentFactory.getInstance());
  }

  constructor(documentFactory: DocumentFactory) {
    this(documentFactory, null);
  }

  constructor(documentFactory: DocumentFactory, elementHandler: ElementHandler) {
    this(documentFactory, elementHandler, null);
    this.elementStack = this.createElementStack();
  }

  constructor(documentFactory: DocumentFactory, elementHandler: ElementHandler, elementStack: ElementStack) {
    this.includeInternalDTDDeclarations = false;
    this.includeExternalDTDDeclarations = false;
    this.internalDTDsubset = false;
    this.mergeAdjacentText = false;
    this.textInTextBuffer = false;
    this.ignoreComments = false;
    this.stripWhitespaceText = false;
    this.documentFactory = documentFactory;
    this.elementHandler = elementHandler;
    this.elementStack = elementStack;
    this.namespaceStack = new NamespaceStack(documentFactory);
  }

  public getDocument(): Document {
    if (this.document == null) {
      this.document = this.createDocument();
    }
    return this.document;
  }

  public setDocumentLocator(documentLocator: Locator): void {
    this.locator = documentLocator;
  }

  public processingInstruction(target: string, data: string): void {
    if (this.mergeAdjacentText && this.textInTextBuffer) {
      this.completeCurrentTextNode();
    }

    if (this.currentElement != null) {
      this.currentElement.addProcessingInstruction(target, data);
    } else {
      this.getDocument().addProcessingInstruction(target, data);
    }
  }

  public startPrefixMapping(prefix: string, uri: string): void {
    this.namespaceStack.push(prefix, uri);
  }

  public endPrefixMapping(prefix: string): void {
    this.namespaceStack.pop(prefix);
    this.declaredNamespaceIndex = this.namespaceStack.size();
  }

  public startDocument(): void {
    this.document = null;
    this.currentElement = null;
    this.elementStack.clear();
    if (this.elementHandler != null && this.elementHandler instanceof DispatchHandler) {
      this.elementStack.setDispatchHandler(this.elementHandler);
    }
    this.namespaceStack.clear();
    this.declaredNamespaceIndex = 0;
    if (this.mergeAdjacentText && this.textBuffer == null) {
      this.textBuffer = new StringBuffer();
    }
    this.textInTextBuffer = false;
  }

  public endDocument(): void {
    this.namespaceStack.clear();
    this.elementStack.clear();
    this.currentElement = null;
    this.textBuffer = null;
  }

  public startElement(namespaceURI: string, localName: string, qualifiedName: string, attributes: Attributes): void {
    if (this.mergeAdjacentText && this.textInTextBuffer) {
      this.completeCurrentTextNode();
    }

    const qName: QName = this.namespaceStack.getQName(namespaceURI, localName, qualifiedName);
    let branch: Branch = this.currentElement;
    if (branch == null) {
      branch = this.getDocument();
    }

    const element: Element = branch.addElement(qName);
    this.addDeclaredNamespaces(element);
    this.addAttributes(element, attributes);
    this.elementStack.pushElement(element);
    this.currentElement = element;
    this.entity = null;
    if (this.elementHandler != null) {
      this.elementHandler.onStart(this.elementStack);
    }
  }

  public endElement(namespaceURI: string, localName: string, qName: string): void {
    if (this.mergeAdjacentText && this.textInTextBuffer) {
      this.completeCurrentTextNode();
    }

    if (this.elementHandler != null && this.currentElement != null) {
      this.elementHandler.onEnd(this.elementStack);
    }

    this.elementStack.popElement();
    this.currentElement = this.elementStack.peekElement();
  }

  public characters(ch: char[], start: number, end: number): void {
    if (end !== 0) {
      if (this.currentElement != null) {
        if (this.entity != null) {
          if (this.mergeAdjacentText && this.textInTextBuffer) {
            this.completeCurrentTextNode();
          }
          this.currentElement.addEntity(this.entity, new String(ch, start, end));
          this.entity = null;
        } else if (this.insideCDATASection) {
          if (this.mergeAdjacentText && this.textInTextBuffer) {
            this.completeCurrentTextNode();
          }
          this.cdataText.append(new String(ch, start, end));
        } else if (this.mergeAdjacentText) {
          this.textBuffer.append(ch, start, end);
          this.textInTextBuffer = true;
        } else {
          this.currentElement.addText(new String(ch, start, end));
        }
      }
    }
  }

  public warning(exception: SAXParseException): void {
  }

  public error(exception: SAXParseException): void {
    throw exception;
  }

  public fatalError(exception: SAXParseException): void {
    throw exception;
  }

  public startDTD(name: string, publicId: string, systemId: string): void {
    this.getDocument().addDocType(name, publicId, systemId);
    this.insideDTDSection = true;
    this.internalDTDsubset = true;
  }

  public endDTD(): void {
    this.insideDTDSection = false;
    const docType: DocumentType = this.getDocument().getDocType();
    if (docType != null) {
      if (this.internalDTDDeclarations != null) {
        docType.setInternalDeclarations(this.internalDTDDeclarations);
      }
      if (this.externalDTDDeclarations != null) {
        docType.setExternalDeclarations(this.externalDTDDeclarations);
      }
    }
    this.internalDTDDeclarations = null;
    this.externalDTDDeclarations = null;
  }

  public startEntity(name: string): void {
    this.entityLevel++;
    this.entity = null;
    if (!this.insideDTDSection && !this.isIgnorableEntity(name)) {
      this.entity = name;
    }
    this.internalDTDsubset = false;
  }

  public endEntity(name: string): void {
    this.entityLevel--;
    this.entity = null;
    if (this.entityLevel === 0) {
      this.internalDTDsubset = true;
    }
  }

  public startCDATA(): void {
    this.insideCDATASection = true;
    this.cdataText = new StringBuffer();
  }

  public endCDATA(): void {
    this.insideCDATASection = false;
    this.currentElement.addCDATA(this.cdataText.toString());
  }

  public comment(ch: char[], start: number, end: number): void {
    if (!this.ignoreComments) {
      if (this.mergeAdjacentText && this.textInTextBuffer) {
        this.completeCurrentTextNode();
      }
      const text: string = new String(ch, start, end);
      if (!this.insideDTDSection && text.length > 0) {
        if (this.currentElement != null) {
          this.currentElement.addComment(text);
        } else {
          this.getDocument().addComment(text);
        }
      }
    }
  }

  public elementDecl(name: string, model: string): void {
    if (this.internalDTDsubset) {
      if (this.includeInternalDTDDeclarations) {
        this.addDTDDeclaration(new ElementDecl(name, model));
      }
    } else if (this.includeExternalDTDDeclarations) {
      this.addExternalDTDDeclaration(new ElementDecl(name, model));
    }
  }

  public attributeDecl(eName: string, aName: string, type: string, valueDefault: string, val: string): void {
    if (this.internalDTDsubset) {
      if (this.includeInternalDTDDeclarations) {
        this.addDTDDeclaration(new AttributeDecl(eName, aName, type, valueDefault, val));
      }
    } else if (this.includeExternalDTDDeclarations) {
      this.addExternalDTDDeclaration(new AttributeDecl(eName, aName, type, valueDefault, val));
    }
  }

  public internalEntityDecl(name: string, value: string): void {
    if (this.internalDTDsubset) {
      if (this.includeInternalDTDDeclarations) {
        this.addDTDDeclaration(new InternalEntityDecl(name, value));
      }
    } else if (this.includeExternalDTDDeclarations) {
      this.addExternalDTDDeclaration(new InternalEntityDecl(name, value));
    }
  }

  public externalEntityDecl(name: string, publicId: string, sysId: string): void {
    const declaration: ExternalEntityDecl = new ExternalEntityDecl(name, publicId, sysId);
    if (this.internalDTDsubset) {
      if (this.includeInternalDTDDeclarations) {
        this.addDTDDeclaration(declaration);
      }
    } else if (this.includeExternalDTDDeclarations) {
      this.addExternalDTDDeclaration(declaration);
    }
  }

  public notationDecl(name: string, publicId: string, systemId: string): void {
  }

  public unparsedEntityDecl(name: string, publicId: string, systemId: string, notationName: string): void {
  }

  public getElementStack(): ElementStack {
    return this.elementStack;
  }

  public setElementStack(elementStack: ElementStack): void {
    this.elementStack = elementStack;
  }

  public getEntityResolver(): EntityResolver {
    return this.entityResolver;
  }

  public setEntityResolver(entityResolver: EntityResolver): void {
    this.entityResolver = entityResolver;
  }

  public getInputSource(): InputSource {
    return this.inputSource;
  }

  public setInputSource(inputSource: InputSource): void {
    this.inputSource = inputSource;
  }

  public isIncludeInternalDTDDeclarations(): boolean {
    return this.includeInternalDTDDeclarations;
  }

  public setIncludeInternalDTDDeclarations(include: boolean): void {
    this.includeInternalDTDDeclarations = include;
  }

  public isIncludeExternalDTDDeclarations(): boolean {
    return this.includeExternalDTDDeclarations;
  }

  public setIncludeExternalDTDDeclarations(include: boolean): void {
    this.includeExternalDTDDeclarations = include;
  }

  public isMergeAdjacentText(): boolean {
    return this.mergeAdjacentText;
  }

  public setMergeAdjacentText(mergeAdjacentText: boolean): void {
    this.mergeAdjacentText = mergeAdjacentText;
  }

  public isStripWhitespaceText(): boolean {
    return this.stripWhitespaceText;
  }

  public setStripWhitespaceText(stripWhitespaceText: boolean): void {
    this.stripWhitespaceText = stripWhitespaceText;
  }

  public isIgnoreComments(): boolean {
    return this.ignoreComments;
  }

  public setIgnoreComments(ignoreComments: boolean): void {
    this.ignoreComments = ignoreComments;
  }

  protected completeCurrentTextNode(): void {
    if (this.stripWhitespaceText) {
      let whitespace: boolean = true;
      for (let i: number = 0; i < this.textBuffer.length(); i++) {
        if (!Character.isWhitespace(this.textBuffer.charAt(i))) {
          whitespace = false;
          break;
        }
      }
      if (!whitespace) {
        this.currentElement.addText(this.textBuffer.toString());
      }
    } else {
      this.currentElement.addText(this.textBuffer.toString());
    }
    this.textBuffer.setLength(0);
    this.textInTextBuffer = false;
  }

  protected createDocument(): Document {
    const encoding: string = this.getEncoding();
    const doc: Document = this.documentFactory.createDocument(encoding);
    doc.setEntityResolver(this.entityResolver);
    if (this.inputSource != null) {
      doc.setName(this.inputSource.getSystemId());
    }
    return doc;
  }

  private getEncoding(): string {
    if (this.locator == null) {
      return null;
    } else {
      return this.locator instanceof Locator2 ? this.locator.getEncoding() : null;
    }
  }

  protected isIgnorableEntity(name: string): boolean {
    return name === "amp" || name === "apos" || name === "gt" || name === "lt" || name === "quot";
  }

  protected addDeclaredNamespaces(element: Element): void {
    const elementNamespace: Namespace = element.getNamespace();
    for (let size: number = this.namespaceStack.size(); this.declaredNamespaceIndex < size; this.declaredNamespaceIndex++) {
      const namespace: Namespace = this.namespaceStack.getNamespace(this.declaredNamespaceIndex);
      element.add(namespace);
    }
  }

  protected addAttributes(element: Element, attributes: Attributes): void {
    const noNamespaceAttributes: boolean = false;
    if (element instanceof AbstractElement) {
      const baseElement: AbstractElement = element as AbstractElement;
      baseElement.setAttributes(attributes, this.namespaceStack, noNamespaceAttributes);
    } else {
      const size: number = attributes.getLength();
      for (let i: number = 0; i < size; i++) {
        const attributeQName: string = attributes.getQName(i);
        if (noNamespaceAttributes || !attributeQName.startsWith("xmlns")) {
          const attributeURI: string = attributes.getURI(i);
          const attributeLocalName: string = attributes.getLocalName(i);
          const attributeValue: string = attributes.getValue(i);
          const qName: QName = this.namespaceStack.getAttributeQName(attributeURI, attributeLocalName, attributeQName);
          element.addAttribute(qName, attributeValue);
        }
      }
    }
  }

  protected addDTDDeclaration(declaration: Decl): void {
    if (this.internalDTDDeclarations == null) {
      this.internalDTDDeclarations = new ArrayList();
    }
    this.internalDTDDeclarations.add(declaration);
  }

  protected addExternalDTDDeclaration(declaration: Decl): void {
    if (this.externalDTDDeclarations == null) {
      this.externalDTDDeclarations = new ArrayList();
    }
    this.externalDTDDeclarations.add(declaration);
  }

  protected createElementStack(): ElementStack {
    return new ElementStack();
  }
}