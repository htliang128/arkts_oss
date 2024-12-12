import DocumentFactory from "../DocumentFactory";

export default class SAXReader {
  private static readonly SAX_STRING_INTERNING = "http://xml.org/sax/features/string-interning";
  private static readonly SAX_DECL_HANDLER = "http://xml.org/sax/properties/declaration-handler";
  private static readonly SAX_LEXICAL_HANDLER = "http://xml.org/sax/properties/lexical-handler";
  private static readonly SAX_LEXICALHANDLER = "http://xml.org/sax/handlers/LexicalHandler";

  private factory: DocumentFactory | undefined;
  private xmlReader: XMLReader | undefined;
  private validating: boolean = false;
  private dispatchHandler: DispatchHandler | undefined;
  private errorHandler: ErrorHandler | undefined;
  private entityResolver: EntityResolver | undefined;
  private stringInternEnabled: boolean = true;
  private includeInternalDTDDeclarations: boolean = false;
  private includeExternalDTDDeclarations: boolean = false;
  private mergeAdjacentText: boolean = false;
  private stripWhitespaceText: boolean = false;
  private ignoreComments: boolean = false;
  private encoding: string | null = null;
  private xmlFilter: XMLFilter | undefined;

  public static createDefault(): SAXReader {
    const reader = new SAXReader();
    try {
      reader.setFeature("http://apache.org/xml/features/nonvalidating/load-external-dtd", false);
      reader.setFeature("http://xml.org/sax/features/external-general-entities", false);
      reader.setFeature("http://xml.org/sax/features/external-parameter-entities", false);
    } catch (e) {
      // Handle exception
    }
    return reader;
  }

  constructor();
  constructor(validating: boolean);
  constructor(factory: DocumentFactory);
  constructor(factory: DocumentFactory, validating: boolean);
  constructor(xmlReader: XMLReader);
  constructor(xmlReader: XMLReader, validating: boolean);
  constructor(xmlReaderClassName: string);
  constructor(xmlReaderClassName: string, validating: boolean);
  constructor(arg1?: any, arg2?: boolean) {
    if (typeof arg1 === 'boolean') {
      this.validating = arg1;
    } else if (arg1 instanceof DocumentFactory) {
      this.factory = arg1;
      this.validating = arg2 ?? false;
    } else if (typeof arg1 === 'string') {
      this.xmlReader = XMLReaderFactory.createXMLReader(arg1);
      this.validating = arg2 ?? false;
    } else if (arg1 instanceof XMLReader) {
      this.xmlReader = arg1;
      this.validating = arg2 ?? false;
    }
  }

  public setProperty(name: string, value: any): void {
    this.getXMLReader().setProperty(name, value);
  }

  public setFeature(name: string, value: boolean): void {
    this.getXMLReader().setFeature(name, value);
  }

  public async read(file: File): Promise<Document> {
    try {
      const source = new InputSource(new FileInputStream(file));
      if (this.encoding) {
        source.setEncoding(this.encoding);
      }
      const path = file.getAbsolutePath();
      if (path) {
        const sb = `file://${!path.startsWith(File.separator) ? '/' : ''}${path.replace('\\', '/')}`;
        source.setSystemId(sb);
      }
      return await this.read(source);
    } catch (e) {
      if (e instanceof FileNotFoundException) {
        throw new DocumentException(e.message, e);
      }
      throw e;
    }
  }

  public async read(url: URL): Promise<Document> {
    const systemID = url.toExternalForm();
    const source = new InputSource(systemID);
    if (this.encoding) {
      source.setEncoding(this.encoding);
    }
    return await this.read(source);
  }

  public async read(systemId: string): Promise<Document> {
    const source = new InputSource(systemId);
    if (this.encoding) {
      source.setEncoding(this.encoding);
    }
    return await this.read(source);
  }

  public async read(inStream: InputStream): Promise<Document> {
    const source = new InputSource(inStream);
    if (this.encoding) {
      source.setEncoding(this.encoding);
    }
    return await this.read(source);
  }

  public async read(reader: Reader): Promise<Document> {
    const source = new InputSource(reader);
    if (this.encoding) {
      source.setEncoding(this.encoding);
    }
    return await this.read(source);
  }

  public async read(inStream: InputStream, systemId: string): Promise<Document> {
    const source = new InputSource(inStream);
    source.setSystemId(systemId);
    if (this.encoding) {
      source.setEncoding(this.encoding);
    }
    return await this.read(source);
  }

  public async read(reader: Reader, systemId: string): Promise<Document> {
    const source = new InputSource(reader);
    source.setSystemId(systemId);
    if (this.encoding) {
      source.setEncoding(this.encoding);
    }
    return await this.read(source);
  }

  public async read(inSource: InputSource): Promise<Document> {
    try {
      let reader = this.getXMLReader();
      reader = this.installXMLFilter(reader);
      let thatEntityResolver = this.entityResolver;
      if (!thatEntityResolver) {
        thatEntityResolver = this.createDefaultEntityResolver(inSource.getSystemId());
        this.entityResolver = thatEntityResolver;
      }
      reader.setEntityResolver(thatEntityResolver);
      const contentHandler = this.createContentHandler(reader);
      contentHandler.setEntityResolver(thatEntityResolver);
      contentHandler.setInputSource(inSource);
      contentHandler.setIncludeInternalDTDDeclarations(this.includeInternalDTDDeclarations);
      contentHandler.setIncludeExternalDTDDeclarations(this.includeExternalDTDDeclarations);
      contentHandler.setMergeAdjacentText(this.mergeAdjacentText);
      contentHandler.setStripWhitespaceText(this.stripWhitespaceText);
      contentHandler.setIgnoreComments(this.ignoreComments);
      reader.setContentHandler(contentHandler);
      this.configureReader(reader, contentHandler);
      reader.parse(inSource);
      return contentHandler.getDocument();
    } catch (e) {
      if (e instanceof SAXParseException) {
        const systemId = e.getSystemId() ?? "";
        const message = `Error on line ${e.getLineNumber()} of document ${systemId} : ${e.getMessage()}`;
        throw new DocumentException(message, e);
      } else {
        throw new DocumentException(e.message, e);
      }
    }
  }

  public isValidating(): boolean {
    return this.validating;
  }

  public setValidation(validation: boolean): void {
    this.validating = validation;
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

  public isStringInternEnabled(): boolean {
    return this.stringInternEnabled;
  }

  public setStringInternEnabled(stringInternEnabled: boolean): void {
    this.stringInternEnabled = stringInternEnabled;
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

  public getDocumentFactory(): DocumentFactory {
    if (!this.factory) {
      this.factory = DocumentFactory.getInstance();
    }
    return this.factory;
  }

  public setDocumentFactory(documentFactory: DocumentFactory): void {
    this.factory = documentFactory;
  }

  public getErrorHandler(): ErrorHandler | undefined {
    return this.errorHandler;
  }

  public setErrorHandler(errorHandler: ErrorHandler): void {
    this.errorHandler = errorHandler;
  }

  public getEntityResolver(): EntityResolver | undefined {
    return this.entityResolver;
  }

  public setEntityResolver(entityResolver: EntityResolver): void {
    this.entityResolver = entityResolver;
  }

  public getXMLReader(): XMLReader {
    if (!this.xmlReader) {
      this.xmlReader = this.createXMLReader();
    }
    return this.xmlReader;
  }

  public setXMLReader(reader: XMLReader): void {
    this.xmlReader = reader;
  }

  public getEncoding(): string | null {
    return this.encoding;
  }

  public setEncoding(encoding: string): void {
    this.encoding = encoding;
  }

  public setXMLReaderClassName(xmlReaderClassName: string): void {
    this.setXMLReader(XMLReaderFactory.createXMLReader(xmlReaderClassName));
  }

  public addHandler(path: string, handler: ElementHandler): void {
    this.getDispatchHandler().addHandler(path, handler);
  }

  public removeHandler(path: string): void {
    this.getDispatchHandler().removeHandler(path);
  }

  public setDefaultHandler(handler: ElementHandler): void {
    this.getDispatchHandler().setDefaultHandler(handler);
  }

  public resetHandlers(): void {
    this.getDispatchHandler().resetHandlers();
  }

  public getXMLFilter(): XMLFilter | undefined {
    return this.xmlFilter;
  }

  public setXMLFilter(filter: XMLFilter): void {
    this.xmlFilter = filter;
  }

  protected installXMLFilter(reader: XMLReader): XMLReader {
    const filter = this.getXMLFilter();
    if (!filter) {
      return reader;
    } else {
      let root = filter;
      while (true) {
        const parent = root.getParent();
        if (!(parent instanceof XMLFilter)) {
          root.setParent(reader);
          return filter;
        }
        root = parent;
      }
    }
  }

  protected getDispatchHandler(): DispatchHandler {
    if (!this.dispatchHandler) {
      this.dispatchHandler = new DispatchHandler();
    }
    return this.dispatchHandler;
  }

  protected setDispatchHandler(dispatchHandler: DispatchHandler): void {
    this.dispatchHandler = dispatchHandler;
  }

  protected createXMLReader(): XMLReader {
    return SAXHelper.createXMLReader(this.isValidating());
  }

  protected configureReader(reader: XMLReader, handler: DefaultHandler): void {
    SAXHelper.setParserProperty(reader, SAXReader.SAX_LEXICALHANDLER, handler);
    SAXHelper.setParserProperty(reader, SAXReader.SAX_LEXICAL_HANDLER, handler);
    if (this.includeInternalDTDDeclarations || this.includeExternalDTDDeclarations) {
      SAXHelper.setParserProperty(reader, SAXReader.SAX_DECL_HANDLER, handler);
    }
    SAXHelper.setParserFeature(reader, SAXReader.SAX_STRING_INTERNING, this.isStringInternEnabled());

    try {
      reader.setFeature("http://xml.org/sax/features/validation", this.isValidating());
      reader.setErrorHandler(this.errorHandler || handler);
    } catch (e) {
      if (this.isValidating()) {
        throw new DocumentException(`Validation not supported for XMLReader: ${reader}`, e);
      }
    }
  }

  protected createContentHandler(reader: XMLReader): SAXContentHandler {
    return new SAXContentHandler(this.getDocumentFactory(), this.getDispatchHandler());
  }

  protected createDefaultEntityResolver(systemId: string | null): EntityResolver {
    let prefix: string | undefined;
    if (systemId && systemId.length > 0) {
      const idx = systemId.lastIndexOf('/');
      if (idx > 0) {
        prefix = systemId.substring(0, idx + 1);
      }
    }
    return new SAXReader.SAXEntityResolver(prefix);
  }

  protected static class SAXEntityResolver implements EntityResolver, Serializable {
  protected uriPrefix: string | undefined;

  constructor(uriPrefix: string | undefined) {
    this.uriPrefix = uriPrefix;
  }

  public resolveEntity(publicId: string | null, systemId: string | null): InputSource {
    if (systemId && systemId.length > 0 && this.uriPrefix && systemId.indexOf(':') <= 0) {
      systemId = this.uriPrefix + systemId;
    }
    return new InputSource(systemId);
  }
}
}