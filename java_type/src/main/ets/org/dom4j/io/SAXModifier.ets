export default class SAXModifier {
  private xmlWriter: XMLWriter | undefined;
  private xmlReader: XMLReader | undefined;
  private pruneElements: boolean;
  private modifyReader: SAXModifyReader | undefined;
  private modifiers: Map<string, ElementModifier> = new Map();

  constructor(pruneElements?: boolean);
  constructor(xmlReader?: XMLReader, pruneElements?: boolean);
  constructor(xmlReaderOrPruneElements?: XMLReader | boolean, pruneElements?: boolean) {
    if (typeof xmlReaderOrPruneElements === 'boolean') {
      this.pruneElements = xmlReaderOrPruneElements;
    } else {
      this.xmlReader = xmlReaderOrPruneElements;
      this.pruneElements = pruneElements ?? false;
    }
  }

  public async modify(source: File | InputSource | InputStream | Reader | URL | string, systemId?: string): Promise<Document> {
    try {
      return await this.installModifyReader().read(source, systemId);
    } catch (ex) {
      if (ex instanceof SAXModifyException) {
        const cause = ex.getCause();
        throw new DocumentException(cause.message, cause);
      }
      throw ex;
    }
  }

  public addModifier(path: string, modifier: ElementModifier): void {
    this.modifiers.set(path, modifier);
  }

  public resetModifiers(): void {
    this.modifiers.clear();
    this.getSAXModifyReader().resetHandlers();
  }

  public removeModifier(path: string): void {
    this.modifiers.delete(path);
    this.getSAXModifyReader().removeHandler(path);
  }

  public getDocumentFactory(): DocumentFactory {
    return this.getSAXModifyReader().getDocumentFactory();
  }

  public setDocumentFactory(factory: DocumentFactory): void {
    this.getSAXModifyReader().setDocumentFactory(factory);
  }

  public getXMLWriter(): XMLWriter | undefined {
    return this.xmlWriter;
  }

  public setXMLWriter(writer: XMLWriter): void {
    this.xmlWriter = writer;
  }

  public isPruneElements(): boolean {
    return this.pruneElements;
  }

  private async installModifyReader(): Promise<SAXReader> {
    try {
      const reader = this.getSAXModifyReader();
      if (this.isPruneElements()) {
        this.modifyReader?.setDispatchHandler(new PruningDispatchHandler());
      }

      reader.resetHandlers();
      for (const [path, modifier] of this.modifiers.entries()) {
        const handler = new SAXModifyElementHandler(modifier);
        reader.addHandler(path, handler);
      }

      reader.setXMLWriter(this.getXMLWriter());
      reader.setXMLReader(await this.getXMLReader());
      return reader;
    } catch (ex) {
      if (ex instanceof SAXException) {
        throw new DocumentException(ex.message, ex);
      }
      throw ex;
    }
  }

  private async getXMLReader(): Promise<XMLReader> {
    if (!this.xmlReader) {
      this.xmlReader = await SAXHelper.createXMLReader(false);
    }
    return this.xmlReader;
  }

  private getSAXModifyReader(): SAXModifyReader {
    if (!this.modifyReader) {
      this.modifyReader = new SAXModifyReader();
    }
    return this.modifyReader;
  }
}