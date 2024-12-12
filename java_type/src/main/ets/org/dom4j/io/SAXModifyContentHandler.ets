export default class SAXModifyContentHandler extends SAXContentHandler {
  private xmlWriter: XMLWriter | null = null;

  constructor();
  constructor(documentFactory: DocumentFactory);
  constructor(documentFactory: DocumentFactory, elementHandler: ElementHandler);
  constructor(documentFactory: DocumentFactory, elementHandler: ElementHandler, elementStack: ElementStack);
  constructor(documentFactory?: DocumentFactory, elementHandler?: ElementHandler, elementStack?: ElementStack) {
    super(documentFactory, elementHandler, elementStack);
  }

  public setXMLWriter(writer: XMLWriter): void {
    this.xmlWriter = writer;
  }

  public startCDATA(): void {
    super.startCDATA();
    if (!this.activeHandlers() && this.xmlWriter) {
      this.xmlWriter.startCDATA();
    }
  }

  public startDTD(name: string, publicId: string, systemId: string): void {
    super.startDTD(name, publicId, systemId);
    if (this.xmlWriter) {
      this.xmlWriter.startDTD(name, publicId, systemId);
    }
  }

  public endDTD(): void {
    super.endDTD();
    if (this.xmlWriter) {
      this.xmlWriter.endDTD();
    }
  }

  public comment(characters: string, parm2: number, parm3: number): void {
    super.comment(characters, parm2, parm3);
    if (!this.activeHandlers() && this.xmlWriter) {
      this.xmlWriter.comment(characters, parm2, parm3);
    }
  }

  public startEntity(name: string): void {
    super.startEntity(name);
    if (this.xmlWriter) {
      this.xmlWriter.startEntity(name);
    }
  }

  public endCDATA(): void {
    super.endCDATA();
    if (!this.activeHandlers() && this.xmlWriter) {
      this.xmlWriter.endCDATA();
    }
  }

  public endEntity(name: string): void {
    super.endEntity(name);
    if (this.xmlWriter) {
      this.xmlWriter.endEntity(name);
    }
  }

  public unparsedEntityDecl(name: string, publicId: string, systemId: string, notation: string): void {
    super.unparsedEntityDecl(name, publicId, systemId, notation);
    if (!this.activeHandlers() && this.xmlWriter) {
      this.xmlWriter.unparsedEntityDecl(name, publicId, systemId, notation);
    }
  }

  public notationDecl(name: string, publicId: string, systemId: string): void {
    super.notationDecl(name, publicId, systemId);
    if (this.xmlWriter) {
      this.xmlWriter.notationDecl(name, publicId, systemId);
    }
  }

  public startElement(uri: string, localName: string, qName: string, atts: any): void {
    super.startElement(uri, localName, qName, atts);
    if (!this.activeHandlers() && this.xmlWriter) {
      this.xmlWriter.startElement(uri, localName, qName, atts);
    }
  }

  public startDocument(): void {
    super.startDocument();
    if (this.xmlWriter) {
      this.xmlWriter.startDocument();
    }
  }

  public ignorableWhitespace(characters: string, parm2: number, parm3: number): void {
    super.ignorableWhitespace(characters, parm2, parm3);
    if (!this.activeHandlers() && this.xmlWriter) {
      this.xmlWriter.ignorableWhitespace(characters, parm2, parm3);
    }
  }

  public processingInstruction(target: string, data: string): void {
    super.processingInstruction(target, data);
    if (!this.activeHandlers() && this.xmlWriter) {
      this.xmlWriter.processingInstruction(target, data);
    }
  }

  public setDocumentLocator(locator: any): void {
    super.setDocumentLocator(locator);
    if (this.xmlWriter) {
      this.xmlWriter.setDocumentLocator(locator);
    }
  }

  public skippedEntity(name: string): void {
    super.skippedEntity(name);
    if (!this.activeHandlers() && this.xmlWriter) {
      this.xmlWriter.skippedEntity(name);
    }
  }

  public endDocument(): void {
    super.endDocument();
    if (this.xmlWriter) {
      this.xmlWriter.endDocument();
    }
  }

  public startPrefixMapping(prefix: string, uri: string): void {
    super.startPrefixMapping(prefix, uri);
    if (this.xmlWriter) {
      this.xmlWriter.startPrefixMapping(prefix, uri);
    }
  }

  public endElement(uri: string, localName: string, qName: string): void {
    const currentHandler = this.getElementStack().getDispatchHandler().getHandler(this.getElementStack().getPath());
    super.endElement(uri, localName, qName);
    if (!this.activeHandlers() && this.xmlWriter) {
      if (currentHandler === null) {
        this.xmlWriter.endElement(uri, localName, qName);
      } else if (currentHandler instanceof SAXModifyElementHandler) {
        const modifyHandler = currentHandler as SAXModifyElementHandler;
        const modifiedElement = modifyHandler.getModifiedElement();

        try {
          this.xmlWriter.write(modifiedElement);
        } catch (error) {
          throw new SAXModifyException(error);
        }
      }
    }
  }

  public endPrefixMapping(prefix: string): void {
    super.endPrefixMapping(prefix);
    if (this.xmlWriter) {
      this.xmlWriter.endPrefixMapping(prefix);
    }
  }

  public characters(characters: string, parm2: number, parm3: number): void {
    super.characters(characters, parm2, parm3);
    if (!this.activeHandlers() && this.xmlWriter) {
      this.xmlWriter.characters(characters, parm2, parm3);
    }
  }

  protected getXMLWriter(): XMLWriter | null {
    return this.xmlWriter;
  }

  private activeHandlers(): boolean {
    const handler = this.getElementStack().getDispatchHandler();
    return handler.getActiveHandlerCount() > 0;
  }
}