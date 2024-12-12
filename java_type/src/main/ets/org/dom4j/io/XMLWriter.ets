export default class XMLWriter extends XMLFilterImpl implements LexicalHandler {
  private static readonly PAD_TEXT = " ";
  protected static readonly LEXICAL_HANDLER_NAMES = [
    "http://xml.org/sax/properties/lexical-handler",
    "http://xml.org/sax/handlers/LexicalHandler"
  ];
  protected static readonly DEFAULT_FORMAT = new OutputFormat();

  private resolveEntityRefs: boolean;
  protected lastOutputNodeType: number;
  private lastElementClosed: boolean;
  protected preserve: boolean;
  protected writer: Writer;
  private namespaceStack: NamespaceStack;
  private format: OutputFormat;
  private escapeText: boolean;
  private indentLevel: number;
  private buffer: StringBuffer;
  private charsAdded: boolean;
  private lastChar: string;
  private autoFlush: boolean;
  private lexicalHandler: LexicalHandler | null;
  private showCommentsInDTDs: boolean;
  private inDTD: boolean;
  private namespacesMap: Map<string, string> | null;
  private maximumAllowedCharacter: number;

  constructor(writer: Writer);
  constructor(writer: Writer, format: OutputFormat);
  constructor();
  constructor(out?: OutputStream, format?: OutputFormat) {
    this.resolveEntityRefs = true;
    this.lastElementClosed = false;
    this.preserve = false;
    this.namespaceStack = new NamespaceStack();
    this.escapeText = true;
    this.indentLevel = 0;
    this.buffer = new StringBuffer();
    this.charsAdded = false;
    this.writer = writer || new BufferedWriter(new OutputStreamWriter(System.out));
    this.format = format || XMLWriter.DEFAULT_FORMAT;
    this.autoFlush = true;
    this.namespaceStack.push(Namespace.NO_NAMESPACE);
  }

  public setWriter(writer: Writer): void {
    this.writer = writer;
    this.autoFlush = false;
  }

  public setOutputStream(out: OutputStream): void {
    this.writer = this.createWriter(out, this.format.getEncoding());
    this.autoFlush = true;
  }

  public isEscapeText(): boolean {
    return this.escapeText;
  }

  public setEscapeText(escapeText: boolean): void {
    this.escapeText = escapeText;
  }

  public setIndentLevel(indentLevel: number): void {
    this.indentLevel = indentLevel;
  }

  public getMaximumAllowedCharacter(): number {
    if (this.maximumAllowedCharacter === 0) {
      this.maximumAllowedCharacter = this.defaultMaximumAllowedCharacter();
    }
    return this.maximumAllowedCharacter;
  }

  public setMaximumAllowedCharacter(maximumAllowedCharacter: number): void {
    this.maximumAllowedCharacter = maximumAllowedCharacter;
  }

  public flush(): void {
    this.writer.flush();
  }

  public close(): void {
    this.writer.close();
  }

  public println(): void {
    this.writer.write(this.format.getLineSeparator());
  }

  public write(attribute: Attribute): void {
    this.writeAttribute(attribute);
    if (this.autoFlush) {
      this.flush();
    }
  }

  public write(doc: Document): void {
    this.writeDeclaration();
    if (doc.getDocType() != null) {
      this.indent();
      this.writeDocType(doc.getDocType());
    }

    for (let i = 0; i < doc.nodeCount(); i++) {
      const node: Node = doc.node(i);
      this.writeNode(node);
    }

    this.writePrintln();
    if (this.autoFlush) {
      this.flush();
    }
  }

  public write(element: Element): void {
    this.writeElement(element);
    if (this.autoFlush) {
      this.flush();
    }
  }

  public write(cdata: CDATA): void {
    this.writeCDATA(cdata.getText());
    if (this.autoFlush) {
      this.flush();
    }
  }

  public write(comment: Comment): void {
    this.writeComment(comment.getText());
    if (this.autoFlush) {
      this.flush();
    }
  }

  public write(docType: DocumentType): void {
    this.writeDocType(docType);
    if (this.autoFlush) {
      this.flush();
    }
  }

  public write(entity: Entity): void {
    this.writeEntity(entity);
    if (this.autoFlush) {
      this.flush();
    }
  }

  public write(namespace: Namespace): void {
    this.writeNamespace(namespace);
    if (this.autoFlush) {
      this.flush();
    }
  }

  public write(processingInstruction: ProcessingInstruction): void {
    this.writeProcessingInstruction(processingInstruction);
    if (this.autoFlush) {
      this.flush();
    }
  }

  public write(text: string): void {
    this.writeString(text);
    if (this.autoFlush) {
      this.flush();
    }
  }

  public write(textNode: Text): void {
    this.writeString(textNode.getText());
    if (this.autoFlush) {
      this.flush();
    }
  }

  public write(node: Node): void {
    this.writeNode(node);
    if (this.autoFlush) {
      this.flush();
    }
  }

  public write(object: any): void {
    if (object instanceof Node) {
      this.write(object);
    } else if (typeof object === 'string') {
      this.write(object);
    } else if (Array.isArray(object)) {
      for (const item of object) {
        this.write(item);
      }
    } else if (object != null) {
      throw new IOException("Invalid object: " + object);
    }
  }

  public writeOpen(element: Element): void {
    this.writer.write("<");
    this.writer.write(element.getQualifiedName());
    this.writeNamespaces(element);
    this.writeAttributes(element);
    this.writer.write(">");
  }

  public writeClose(element: Element): void {
    this.writeClose(element.getQualifiedName());
  }

  public parse(source: InputSource): void {
    this.installLexicalHandler();
    super.parse(source);
  }

  public setProperty(name: string, value: any): void {
    for (const lexicalHandlerName of XMLWriter.LEXICAL_HANDLER_NAMES) {
      if (lexicalHandlerName === name) {
        this.setLexicalHandler(value as LexicalHandler);
        return;
      }
    }
    super.setProperty(name, value);
  }

  public getProperty(name: string): any {
    for (const lexicalHandlerName of XMLWriter.LEXICAL_HANDLER_NAMES) {
      if (lexicalHandlerName === name) {
        return this.getLexicalHandler();
      }
    }
    return super.getProperty(name);
  }

  public setLexicalHandler(handler: LexicalHandler): void {
    if (handler == null) {
      throw new Error("Null lexical handler");
    } else {
      this.lexicalHandler = handler;
    }
  }

  public getLexicalHandler(): LexicalHandler | null {
    return this.lexicalHandler;
  }

  public setDocumentLocator(locator: Locator): void {
    super.setDocumentLocator(locator);
  }

  public startDocument(): void {
    try {
      this.writeDeclaration();
      super.startDocument();
    } catch (e) {
      this.handleException(e);
    }
  }

  public endDocument(): void {
    super.endDocument();
    if (this.autoFlush) {
      try {
        this.flush();
      } catch (e) {}
    }
  }

  public startPrefixMapping(prefix: string, uri: string): void {
    if (this.namespacesMap == null) {
      this.namespacesMap = new Map();
    }
    this.namespacesMap.set(prefix, uri);
    super.startPrefixMapping(prefix, uri);
  }

  public endPrefixMapping(prefix: string): void {
    super.endPrefixMapping(prefix);
  }

  public startElement(namespaceURI: string, localName: string, qName: string, attributes: Attributes): void {
    try {
      this.charsAdded = false;
      this.writePrintln();
      this.indent();
      this.writer.write("<");
      this.writer.write(qName);
      this.writeNamespaces();
      this.writeAttributes(attributes);
      this.writer.write(">");
      this.indentLevel++;
      this.lastOutputNodeType = 1;
      this.lastElementClosed = false;
      super.startElement(namespaceURI, localName, qName, attributes);
    } catch (e) {
      this.handleException(e);
    }
  }

  public endElement(namespaceURI: string, localName: string, qName: string): void {
    try {
      this.charsAdded = false;
      this.indentLevel--;
      if (this.lastElementClosed) {
        this.writePrintln();
        this.indent();
      }

      const hadContent = true;
      if (hadContent) {
        this.writeClose(qName);
      } else {
        this.writeEmptyElementClose(qName);
      }

      this.lastOutputNodeType = 1;
      this.lastElementClosed = true;
      super.endElement(namespaceURI, localName, qName);
    } catch (e) {
      this.handleException(e);
    }
  }

  public characters(ch: string[], start: number, length: number): void {
    if (ch != null && ch.length !== 0 && length > 0) {
      try {
        let string: string = String.fromCharCode(...ch.slice(start, start + length));
        if (this.escapeText) {
          string = this.escapeElementEntities(string);
        }

        if (!this.format.isTrimText()) {
          this.writer.write(string);
        } else {
          if (this.lastOutputNodeType === 3 && !this.charsAdded) {
            this.writer.write(" ");
          } else if (this.charsAdded && /\s/.test(this.lastChar)) {
            this.writer.write(" ");
          } else if (this.lastOutputNodeType === 1 && this.format.isPadText() && this.lastElementClosed && /\s/.test(ch[0])) {
            this.writer.write(" ");
          }

          const tokens = string.split(/\s+/);
          for (const token of tokens) {
            this.writer.write(token);
          }
        }

        this.charsAdded = true;
        this.lastChar = ch[start + length - 1];
        this.lastOutputNodeType = 3;
        super.characters(ch, start, length);
      } catch (e) {
        this.handleException(e);
      }
    }
  }

  public ignorableWhitespace(ch: string[], start: number, length: number): void {
    super.ignorableWhitespace(ch, start, length);
  }

  public processingInstruction(target: string, data: string): void {
    try {
      this.indent();
      this.writer.write("<?");
      this.writer.write(target);
      this.writer.write(" ");
      this.writer.write(data);
      this.writer.write("?>");
      this.writePrintln();
      this.lastOutputNodeType = 7;
      super.processingInstruction(target, data);
    } catch (e) {
      this.handleException(e);
    }
  }

  public notationDecl(name: string, publicID: string, systemID: string): void {
    super.notationDecl(name, publicID, systemID);
  }

  public unparsedEntityDecl(name: string, publicID: string, systemID: string, notationName: string): void {
    super.unparsedEntityDecl(name, publicID, systemID, notationName);
  }

  public startDTD(name: string, publicID: string, systemID: string): void {
    this.inDTD = true;

    try {
      this.writeDocType(name, publicID, systemID);
    } catch (e) {
      this.handleException(e);
    }

    if (this.lexicalHandler != null) {
      this.lexicalHandler.startDTD(name, publicID, systemID);
    }
  }

  public endDTD(): void {
    this.inDTD = false;
    if (this.lexicalHandler != null) {
      this.lexicalHandler.endDTD();
    }
  }

  public startCDATA(): void {
    try {
      this.writer.write("<![CDATA[");
    } catch (e) {
      this.handleException(e);
    }

    if (this.lexicalHandler != null) {
      this.lexicalHandler.startCDATA();
    }
  }

  public endCDATA(): void {
    try {
      this.writer.write("]]>");
    } catch (e) {
      this.handleException(e);
    }

    if (this.lexicalHandler != null) {
      this.lexicalHandler.endCDATA();
    }
  }

  public startEntity(name: string): void {
    try {
      this.writeEntityRef(name);
    } catch (e) {
      this.handleException(e);
    }

    if (this.lexicalHandler != null) {
      this.lexicalHandler.startEntity(name);
    }
  }

  public endEntity(name: string): void {
    if (this.lexicalHandler != null) {
      this.lexicalHandler.endEntity(name);
    }
  }

  public comment(ch: string[], start: number, length: number): void {
    if (this.showCommentsInDTDs || !this.inDTD) {
      try {
        this.charsAdded = false;
        this.writeComment(new String(ch, start, length));
      } catch (e) {
        this.handleException(e);
      }
    }

    if (this.lexicalHandler != null) {
      this.lexicalHandler.comment(ch, start, length);
    }
  }

  protected writeElement(element: Element): void {
    const size = element.nodeCount();
    const qualifiedName = element.getQualifiedName();
    this.writePrintln();
    this.indent();
    this.writer.write("<");
    this.writer.write(qualifiedName);
    const previouslyDeclaredNamespaces = this.namespaceStack.size();
    const ns = element.getNamespace();
    if (this.isNamespaceDeclaration(ns)) {
      this.namespaceStack.push(ns);
      this.writeNamespace(ns);
    }

    let textOnly = true;

    for (let i = 0; i < size; i++) {
      const node: Node = element.node(i);
      if (node instanceof Namespace) {
        const additional = node as Namespace;
        if (this.isNamespaceDeclaration(additional)) {
          this.namespaceStack.push(additional);
          this.writeNamespace(additional);
        }
      } else if (node instanceof Element) {
        textOnly = false;
      } else if (node instanceof Comment) {
        textOnly = false;
      }
    }

    this.writeAttributes(element);
    this.lastOutputNodeType = 1;
    if (size <= 0) {
      this.writeEmptyElementClose(qualifiedName);
    } else {
      this.writer.write(">");
      if (textOnly) {
        this.writeElementContent(element);
      } else {
        this.indentLevel++;
        this.writeElementContent(element);
        this.indentLevel--;
        this.writePrintln();
        this.indent();
      }

      this.writer.write("</");
      this.writer.write(qualifiedName);
      this.writer.write(">");
    }

    while (this.namespaceStack.size() > previouslyDeclaredNamespaces) {
      this.namespaceStack.pop();
    }

    this.lastOutputNodeType = 1;
  }

  protected isElementSpacePreserved(element: Element): boolean {
    const attr = element.attribute("space");
    let preserveFound = this.preserve;
    if (attr != null) {
      preserveFound = "xml" === attr.getNamespacePrefix() && "preserve" === attr.getText();
    }

    return preserveFound;
  }

  protected writeElementContent(element: Element): void {
    const trim = this.format.isTrimText();
    const oldPreserve = this.preserve;
    if (trim) {
      this.preserve = this.isElementSpacePreserved(element);
      trim = !this.preserve;
    }

    if (trim) {
      let lastTextNode: Text | null = null;
      let buff: StringBuilder | null = null;
      let textOnly = true;

      for (const node of element.content()) {
        if (node instanceof Text) {
          if (lastTextNode == null) {
            lastTextNode = node;
          } else {
            if (buff == null) {
              buff = new StringBuilder(lastTextNode.getText());
            }

            buff.append(node.getText());
          }
        } else {
          if (!textOnly && this.format.isPadText()) {
            const endsWithWhitespace = buff != null ? StringUtils.startsWithWhitespace(buff) : lastTextNode != null ? StringUtils.startsWithWhitespace(lastTextNode.getText()) : false;

            if (endsWithWhitespace) {
              this.writer.write(" ");
            }
          }

          if (lastTextNode != null) {
            if (buff != null) {
              this.writeString(buff.toString());
              buff = null;
            } else {
              this.writeString(lastTextNode.getText());
            }

            if (this.format.isPadText()) {
              const endsWithWhitespace = buff != null ? StringUtils.endsWithWhitespace(buff) : StringUtils.endsWithWhitespace(lastTextNode.getText());

              if (endsWithWhitespace) {
                this.writer.write(" ");
              }
            }

            lastTextNode = null;
          }

          textOnly = false;
          this.writeNode(node);
        }
      }

      if (lastTextNode != null) {
        const startsWithWhitespace = buff != null ? StringUtils.startsWithWhitespace(buff) : StringUtils.startsWithWhitespace(lastTextNode.getText());

        if (!textOnly && this.format.isPadText() && startsWithWhitespace) {
          this.writer.write(" ");
        }

        if (buff != null) {
          this.writeString(buff.toString());
        } else {
          this.writeString(lastTextNode.getText());
        }

        lastTextNode = null;
      }
    } else {
      let lastTextNode: Node | null = null;

      for (const node of element.content()) {
        if (node instanceof Text) {
          this.writeNode(node);
          lastText