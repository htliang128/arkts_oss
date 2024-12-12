export default  class SAXWriter implements XMLReader {
  protected static readonly LEXICAL_HANDLER_NAMES: string[] = [
    "http://xml.org/sax/properties/lexical-handler",
    "http://xml.org/sax/handlers/LexicalHandler"
  ];
  protected static readonly FEATURE_NAMESPACE_PREFIXES: string = "http://xml.org/sax/features/namespace-prefixes";
  protected static readonly FEATURE_NAMESPACES: string = "http://xml.org/sax/features/namespaces";

  private contentHandler: ContentHandler | null;
  private dtdHandler: DTDHandler | null;
  private entityResolver: EntityResolver | null;
  private errorHandler: ErrorHandler | null;
  private lexicalHandler: LexicalHandler | null;
  private attributes: AttributesImpl;
  private features: Map<string, boolean>;
  private properties: Map<string, any>;
  private declareNamespaceAttributes: boolean;

  constructor();
  constructor(contentHandler: ContentHandler);
  constructor(contentHandler: ContentHandler, lexicalHandler: LexicalHandler);
  constructor(contentHandler: ContentHandler, lexicalHandler: LexicalHandler, entityResolver: EntityResolver);
  constructor(contentHandler?: ContentHandler, lexicalHandler?: LexicalHandler, entityResolver?: EntityResolver) {
    this.attributes = new AttributesImpl();
    this.features = new Map();
    this.properties = new Map();
    this.properties.set("http://xml.org/sax/features/namespace-prefixes", false);
    this.properties.set("http://xml.org/sax/features/namespace-prefixes", true);
    this.contentHandler = contentHandler || null;
    this.lexicalHandler = lexicalHandler || null;
    this.entityResolver = entityResolver || null;
  }

  public write(node: Node): void {
    const nodeType = node.getNodeType();
    switch (nodeType) {
      case 1:
        this.write(node as Element);
        break;
      case 2:
        this.write(node as Node);
        break;
      case 3:
        this.write(node.getText());
        break;
      case 4:
        this.write(node as CDATA);
        break;
      case 5:
        this.write(node as Entity);
        break;
      case 6:
      case 11:
      case 12:
      default:
        throw new SAXException("Invalid node type: " + node);
      case 7:
        this.write(node as ProcessingInstruction);
        break;
      case 8:
        this.write(node as Comment);
        break;
      case 9:
        this.write(node as Document);
        break;
      case 10:
        this.write(node as Node);
        break;
      case 13:
        break;
    }
  }

  public write(document: Document): void {
    if (document !== null) {
      this.checkForNullHandlers();
      this.documentLocator(document);
      this.startDocument();
      this.entityResolver(document);
      this.dtdHandler(document);
      this.writeContent(document, new NamespaceStack());
      this.endDocument();
    }
  }

  public write(element: Element): void {
    this.write(element, new NamespaceStack());
  }

  public writeOpen(element: Element): void {
    this.startElement(element, null);
  }

  public writeClose(element: Element): void {
    this.endElement(element);
  }

  public write(text: string): void {
    if (text !== null) {
      const chars = text.toCharArray();
      this.contentHandler?.characters(chars, 0, chars.length);
    }
  }

  public write(cdata: CDATA): void {
    const text = cdata.getText();
    if (this.lexicalHandler !== null) {
      this.lexicalHandler.startCDATA();
      this.write(text);
      this.lexicalHandler.endCDATA();
    } else {
      this.write(text);
    }
  }

  public write(comment: Comment): void {
    if (this.lexicalHandler !== null) {
      const text = comment.getText();
      const chars = text.toCharArray();
      this.lexicalHandler.comment(chars, 0, chars.length);
    }
  }

  public write(entity: Entity): void {
    const text = entity.getText();
    if (this.lexicalHandler !== null) {
      const name = entity.getName();
      this.lexicalHandler.startEntity(name);
      this.write(text);
      this.lexicalHandler.endEntity(name);
    } else {
      this.write(text);
    }
  }

  public write(pi: ProcessingInstruction): void {
    const target = pi.getTarget();
    const text = pi.getText();
    this.contentHandler?.processingInstruction(target, text);
  }

  public isDeclareNamespaceAttributes(): boolean {
    return this.declareNamespaceAttributes;
  }

  public setDeclareNamespaceAttributes(declareNamespaceAttrs: boolean): void {
    this.declareNamespaceAttributes = declareNamespaceAttrs;
  }

  public getContentHandler(): ContentHandler | null {
    return this.contentHandler;
  }

  public setContentHandler(contentHandler: ContentHandler): void {
    this.contentHandler = contentHandler;
  }

  public getDTDHandler(): DTDHandler | null {
    return this.dtdHandler;
  }

  public setDTDHandler(handler: DTDHandler): void {
    this.dtdHandler = handler;
  }

  public getErrorHandler(): ErrorHandler | null {
    return this.errorHandler;
  }

  public setErrorHandler(errorHandler: ErrorHandler): void {
    this.errorHandler = errorHandler;
  }

  public getEntityResolver(): EntityResolver | null {
    return this.entityResolver;
  }

  public setEntityResolver(entityResolver: EntityResolver): void {
    this.entityResolver = entityResolver;
  }

  public getLexicalHandler(): LexicalHandler | null {
    return this.lexicalHandler;
  }

  public setLexicalHandler(lexicalHandler: LexicalHandler): void {
    this.lexicalHandler = lexicalHandler;
  }

  public setXMLReader(xmlReader: XMLReader): void {
    this.setContentHandler(xmlReader.getContentHandler());
    this.setDTDHandler(xmlReader.getDTDHandler());
    this.setEntityResolver(xmlReader.getEntityResolver());
    this.setErrorHandler(xmlReader.getErrorHandler());
  }

  public getFeature(name: string): boolean {
    const answer = this.features.get(name);
    return answer !== undefined ? answer : false;
  }

  public setFeature(name: string, value: boolean): void {
    if (name === "http://xml.org/sax/features/namespace-prefixes") {
      this.setDeclareNamespaceAttributes(value);
    } else if (name === "http://xml.org/sax/features/namespace-prefixes" && !value) {
      throw new SAXNotSupportedException("Namespace feature is always supported in dom4j");
    }
    this.features.set(name, value);
  }

  public setProperty(name: string, value: any): void {
    for (const lexicalHandlerName of SAXWriter.LEXICAL_HANDLER_NAMES) {
      if (lexicalHandlerName === name) {
        this.setLexicalHandler(value as LexicalHandler);
        return;
      }
    }
    this.properties.set(name, value);
  }

  public getProperty(name: string): any {
    for (const lexicalHandlerName of SAXWriter.LEXICAL_HANDLER_NAMES) {
      if (lexicalHandlerName === name) {
        return this.getLexicalHandler();
      }
    }
    return this.properties.get(name);
  }

  public parse(systemId: string): void {
    throw new SAXNotSupportedException("This XMLReader can only accept <dom4j> InputSource objects");
  }

  public parse(input: InputSource): void {
    if (input instanceof DocumentInputSource) {
      const documentInput = input as DocumentInputSource;
      const document = documentInput.getDocument();
      this.write(document);
    } else {
      throw new SAXNotSupportedException("This XMLReader can only accept <dom4j> InputSource objects");
    }
  }

  protected writeContent(branch: Branch, namespaceStack: NamespaceStack): void {
    const iter = branch.nodeIterator();
    while (iter.hasNext()) {
      const node = iter.next() as Node;
      if (node instanceof Element) {
        this.write(node as Element, namespaceStack);
      } else if (node instanceof CharacterData) {
        if (node instanceof Text) {
          const text = node as Text;
          this.write(text.getText());
        } else if (node instanceof CDATA) {
          this.write(node as CDATA);
        } else if (node instanceof Comment) {
          this.write(node as Comment);
        } else {
          throw new SAXException("Invalid Node in DOM4J content: " + node + " of type: " + node.getClass());
        }
      } else if (node instanceof Entity) {
        this.write(node as Entity);
      } else if (node instanceof ProcessingInstruction) {
        this.write(node as ProcessingInstruction);
      } else if (node instanceof Namespace) {
        this.write(node as Namespace);
      } else {
        throw new SAXException("Invalid Node in DOM4J content: " + node);
      }
    }
  }

  protected documentLocator(document: Document): void {
    const locator = new LocatorImpl();
    let publicID: string | null = null;
    let systemID: string | null = null;
    const docType = document.getDocType();
    if (docType !== null) {
      publicID = docType.getPublicID();
      systemID = docType.getSystemID();
    }
    if (publicID !== null) {
      locator.setPublicId(publicID);
    }
    if (systemID !== null) {
      locator.setSystemId(systemID);
    }
    locator.setLineNumber(-1);
    locator.setColumnNumber(-1);
    this.contentHandler?.setDocumentLocator(locator);
  }

  protected entityResolver(document: Document): void {
    if (this.entityResolver !== null) {
      const docType = document.getDocType();
      if (docType !== null) {
        const publicID = docType.getPublicID();
        const systemID = docType.getSystemID();
        if (publicID !== null || systemID !== null) {
          try {
            this.entityResolver.resolveEntity(publicID, systemID);
          } catch (e) {
            throw new SAXException("Could not resolve publicID: " + publicID + " systemID: " + systemID, e);
          }
        }
      }
    }
  }

  protected dtdHandler(document: Document): void {
    // No implementation needed
  }

  protected startDocument(): void {
    this.contentHandler?.startDocument();
  }

  protected endDocument(): void {
    this.contentHandler?.endDocument();
  }

  protected write(element: Element, namespaceStack: NamespaceStack): void {
    const stackSize = namespaceStack.size();
    const namespaceAttributes = this.startPrefixMapping(element, namespaceStack);
    this.startElement(element, namespaceAttributes);
    this.writeContent(element, namespaceStack);
    this.endElement(element);
    this.endPrefixMapping(namespaceStack, stackSize);
  }

  protected startPrefixMapping(element: Element, namespaceStack: NamespaceStack): AttributesImpl | null {
    let namespaceAttributes: AttributesImpl | null = null;
    const elementNamespace = element.getNamespace();
    if (elementNamespace !== null && !this.isIgnoreableNamespace(elementNamespace, namespaceStack)) {
      namespaceStack.push(elementNamespace);
      this.contentHandler?.startPrefixMapping(elementNamespace.getPrefix(), elementNamespace.getURI());
      namespaceAttributes = this.addNamespaceAttribute(namespaceAttributes, elementNamespace);
    }

    const declaredNamespaces = element.declaredNamespaces();
    for (const namespace of declaredNamespaces) {
      if (!this.isIgnoreableNamespace(namespace, namespaceStack)) {
        namespaceStack.push(namespace);
        this.contentHandler?.startPrefixMapping(namespace.getPrefix(), namespace.getURI());
        namespaceAttributes = this.addNamespaceAttribute(namespaceAttributes, namespace);
      }
    }

    return namespaceAttributes;
  }

  protected endPrefixMapping(stack: NamespaceStack, stackSize: number): void {
    while (stack.size() > stackSize) {
      const namespace = stack.pop();
      if (namespace !== null) {
        this.contentHandler?.endPrefixMapping(namespace.getPrefix());
      }
    }
  }

  protected startElement(element: Element, namespaceAttributes: AttributesImpl | null): void {
    this.contentHandler?.startElement(element.getNamespaceURI(), element.getName(), element.getQualifiedName(), this.createAttributes(element, namespaceAttributes));
  }

  protected endElement(element: Element): void {
    this.contentHandler?.endElement(element.getNamespaceURI(), element.getName(), element.getQualifiedName());
  }

  protected createAttributes(element: Element, namespaceAttributes: Attributes | null): Attributes {
    this.attributes.clear();
    if (namespaceAttributes !== null) {
      this.attributes.setAttributes(namespaceAttributes);
    }

    const iter = element.attributeIterator();
    while (iter.hasNext()) {
      const attribute = iter.next() as Attribute;
      this.attributes.addAttribute(attribute.getNamespaceURI(), attribute.getName(), attribute.getQualifiedName(), "CDATA", attribute.getValue());
    }

    return this.attributes;
  }

  protected addNamespaceAttribute(attrs: AttributesImpl | null, namespace: Namespace): AttributesImpl | null {
    if (this.declareNamespaceAttributes) {
      if (attrs === null) {
        attrs = new AttributesImpl();
      }

      const prefix = namespace.getPrefix();
      let qualifiedName = "xmlns";
      if (prefix !== null && prefix.length > 0) {
        qualifiedName = "xmlns:" + prefix;
      }

      const uri = "";
      const localName = prefix;
      const type = "CDATA";
      const value = namespace.getURI();
      attrs.addAttribute(uri, localName, qualifiedName, type, value);
    }

    return attrs;
  }

  protected isIgnoreableNamespace(namespace: Namespace, namespaceStack: NamespaceStack): boolean {
    if (!namespace.equals(Namespace.NO_NAMESPACE) && !namespace.equals(Namespace.XML_NAMESPACE)) {
      const uri = namespace.getURI();
      return uri !== null && uri.length > 0 ? namespaceStack.contains(namespace) : true;
    } else {
      return true;
    }
  }

  protected checkForNullHandlers(): void {
    // No implementation needed
  }
}