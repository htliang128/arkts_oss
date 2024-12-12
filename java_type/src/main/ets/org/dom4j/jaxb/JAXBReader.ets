export default  class JAXBReader extends JAXBSupport {
  private reader: SAXReader | null = null;
  private pruneElements: boolean = false;

  constructor(contextPath: string);
  constructor(contextPath: string, classloader: ClassLoader);
  constructor(contextPath: string, classloader?: ClassLoader) {
    super(contextPath, classloader);
  }

  public read(source: File): Promise<Document> {
    return this.getReader().read(source);
  }

  public read(file: File, charset: Charset): Promise<Document> {
    try {
      const xmlReader = new InputStreamReader(new FileInputStream(file), charset);
      return this.getReader().read(xmlReader);
    } catch (var5) {
      const ex: JAXBRuntimeException = var5;
      const cause = ex.getCause();
      throw new DocumentException(cause.getMessage(), cause);
    } catch (var6) {
      const ex: FileNotFoundException = var6;
      throw new DocumentException(ex.getMessage(), ex);
    }
  }

  public read(source: InputSource): Promise<Document> {
    try {
      return this.getReader().read(source);
    } catch (var4) {
      const ex: JAXBRuntimeException = var4;
      const cause = ex.getCause();
      throw new DocumentException(cause.getMessage(), cause);
    }
  }

  public read(source: InputStream): Promise<Document> {
    try {
      return this.getReader().read(source);
    } catch (var4) {
      const ex: JAXBRuntimeException = var4;
      const cause = ex.getCause();
      throw new DocumentException(cause.getMessage(), cause);
    }
  }

  public read(source: InputStream, systemId: string): Promise<Document> {
    try {
      return this.getReader().read(source);
    } catch (var5) {
      const ex: JAXBRuntimeException = var5;
      const cause = ex.getCause();
      throw new DocumentException(cause.getMessage(), cause);
    }
  }

  public read(source: Reader): Promise<Document> {
    try {
      return this.getReader().read(source);
    } catch (var4) {
      const ex: JAXBRuntimeException = var4;
      const cause = ex.getCause();
      throw new DocumentException(cause.getMessage(), cause);
    }
  }

  public read(source: Reader, systemId: string): Promise<Document> {
    try {
      return this.getReader().read(source);
    } catch (var5) {
      const ex: JAXBRuntimeException = var5;
      const cause = ex.getCause();
      throw new DocumentException(cause.getMessage(), cause);
    }
  }

  public read(source: string): Promise<Document> {
    try {
      return this.getReader().read(source);
    } catch (var4) {
      const ex: JAXBRuntimeException = var4;
      const cause = ex.getCause();
      throw new DocumentException(cause.getMessage(), cause);
    }
  }

  public read(source: URL): Promise<Document> {
    try {
      return this.getReader().read(source);
    } catch (var4) {
      const ex: JAXBRuntimeException = var4;
      const cause = ex.getCause();
      throw new DocumentException(cause.getMessage(), cause);
    }
  }

  public addObjectHandler(path: string, handler: JAXBObjectHandler): void {
    const eHandler = new this.UnmarshalElementHandler(this, handler);
    this.getReader().addHandler(path, eHandler);
  }

  public removeObjectHandler(path: string): void {
    this.getReader().removeHandler(path);
  }

  public addHandler(path: string, handler: ElementHandler): void {
    this.getReader().addHandler(path, handler);
  }

  public removeHandler(path: string): void {
    this.getReader().removeHandler(path);
  }

  public resetHandlers(): void {
    this.getReader().resetHandlers();
  }

  public isPruneElements(): boolean {
    return this.pruneElements;
  }

  public setPruneElements(pruneElements: boolean): void {
    this.pruneElements = pruneElements;
    if (pruneElements) {
      this.getReader().setDefaultHandler(new this.PruningElementHandler());
    }
  }

  private getReader(): SAXReader {
    if (this.reader === null) {
      this.reader = new SAXReader();
    }
    return this.reader;
  }

  private class PruningElementHandler implements ElementHandler {
  public onStart(elementPath: ElementPath): void {
  }

  public onEnd(elementPath: ElementPath): void {
    let elem = elementPath.getCurrent();
    elem.detach();
    elem = null;
  }
}

private class UnmarshalElementHandler implements ElementHandler {
  private jaxbReader: JAXBReader;
  private handler: JAXBObjectHandler;

  constructor(documentReader: JAXBReader, handler: JAXBObjectHandler) {
    this.jaxbReader = documentReader;
    this.handler = handler;
  }

  public onStart(elementPath: ElementPath): void {
  }

  public onEnd(elementPath: ElementPath): void {
    try {
      const elem = elementPath.getCurrent();
      const jaxbObject = this.jaxbReader.unmarshal(elem);
      if (this.jaxbReader.isPruneElements()) {
        elem.detach();
      }
      this.handler.handleObject(jaxbObject);
    } catch (var4) {
      const ex: Exception = var4;
      throw new JAXBRuntimeException(ex);
    }
  }
}
}