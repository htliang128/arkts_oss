export default  class JAXBModifier extends JAXBSupport {
  private modifier: SAXModifier;
  private xmlWriter: XMLWriter;
  private pruneElements: boolean;
  private outputFormat: OutputFormat;
  private modifiers: Map<string, JAXBObjectModifier> = new Map();

  public constructor(contextPath: string);
  public constructor(contextPath: string, classloader: ClassLoader);
  public constructor(contextPath: string, outputFormat: OutputFormat);
  public constructor(contextPath: string, classloader: ClassLoader, outputFormat: OutputFormat);
  public constructor(arg1: string, arg2?: any) {
    super(arg1, arg2);
    this.outputFormat = new OutputFormat();
  }

  public modify(source: File): Document;
  public modify(source: File, charset: Charset): Document;
  public modify(source: InputSource): Document;
  public modify(source: InputStream): Document;
  public modify(source: InputStream, systemId: string): Document;
  public modify(reader: Reader): Document;
  public modify(source: Reader, systemId: string): Document;
  public modify(url: string): Document;
  public modify(source: URL): Document;

  public modify(arg: any): Document {
    try {
      return this.installModifier().modify(arg);
    } catch (error) {
      if (error instanceof JAXBRuntimeException) {
        const cause = error.getCause();
        throw new DocumentException(cause.getMessage(), cause);
      } else {
        throw new DocumentException(error.message, error);
      }
    }
  }

  public setOutput(file: File): void;
  public setOutput(outputStream: OutputStream): void;
  public setOutput(writer: Writer): void;

  public setOutput(arg: any): void {
    this.createXMLWriter().setOutputStream(arg instanceof File ? new FileOutputStream(arg) : arg);
  }

  public addObjectModifier(path: string, mod: JAXBObjectModifier): void {
    this.modifiers.set(path, mod);
  }

  public removeObjectModifier(path: string): void {
    this.modifiers.delete(path);
    this.getModifier().removeModifier(path);
  }

  public resetObjectModifiers(): void {
    this.modifiers.clear();
    this.getModifier().resetModifiers();
  }

  public isPruneElements(): boolean {
    return this.pruneElements;
  }

  public setPruneElements(pruneElements: boolean): void {
    this.pruneElements = pruneElements;
  }

  private installModifier(): SAXModifier {
    this.modifier = new SAXModifier(this.isPruneElements());
    this.modifier.resetModifiers();
    this.modifiers.forEach((mod, path) => {
      const elementModifier = new JAXBElementModifier(this, mod);
      this.getModifier().addModifier(path, elementModifier);
    });
    this.modifier.setXMLWriter(this.getXMLWriter());
    return this.modifier;
  }

  private getModifier(): SAXModifier {
    if (!this.modifier) {
      this.modifier = new SAXModifier(this.isPruneElements());
    }
    return this.modifier;
  }

  private getXMLWriter(): XMLWriter {
    return this.xmlWriter;
  }

  private createXMLWriter(): XMLWriter {
    if (!this.xmlWriter) {
      this.xmlWriter = new XMLWriter(this.outputFormat);
    }
    return this.xmlWriter;
  }

  private class JAXBElementModifier implements ElementModifier {
  private jaxbModifier: JAXBModifier;
  private objectModifier: JAXBObjectModifier;

  public constructor(jaxbModifier: JAXBModifier, objectModifier: JAXBObjectModifier) {
    this.jaxbModifier = jaxbModifier;
    this.objectModifier = objectModifier;
  }

  public modifyElement(element: Element): Element {
    const originalObject = this.jaxbModifier.unmarshal(element);
    const modifiedObject = this.objectModifier.modifyObject(originalObject);
    return this.jaxbModifier.marshal(modifiedObject);
  }
}
}