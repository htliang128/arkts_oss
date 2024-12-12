export default  class JAXBWriter extends JAXBSupport {
  private xmlWriter: XMLWriter | null = null;
  private outputFormat: OutputFormat;

  constructor(contextPath: string);
  constructor(contextPath: string, outputFormat: OutputFormat);
  constructor(contextPath: string, classloader: ClassLoader);
  constructor(contextPath: string, classloader: ClassLoader, outputFormat: OutputFormat);
  constructor(contextPath: string, arg2?: any) {
    super(contextPath, arg2 instanceof ClassLoader ? arg2 : undefined);
    if (arg2 instanceof OutputFormat) {
      this.outputFormat = arg2;
    } else {
      this.outputFormat = new OutputFormat();
    }
  }

  public getOutputFormat(): OutputFormat {
    return this.outputFormat;
  }

  public setOutput(file: File): void {
    this.getWriter().setOutputStream(new FileOutputStream(file));
  }

  public setOutput(outputStream: OutputStream): void {
    this.getWriter().setOutputStream(outputStream);
  }

  public setOutput(writer: Writer): void {
    this.getWriter().setWriter(writer);
  }

  public startDocument(): void {
    this.getWriter().startDocument();
  }

  public endDocument(): void {
    this.getWriter().endDocument();
  }

  public write(jaxbObject: Element): void {
    this.getWriter().write(this.marshal(jaxbObject));
  }

  public writeClose(jaxbObject: Element): void {
    this.getWriter().writeClose(this.marshal(jaxbObject));
  }

  public writeOpen(jaxbObject: Element): void {
    this.getWriter().writeOpen(this.marshal(jaxbObject));
  }

  public writeElement(element: org.dom4j.Element): void {
    this.getWriter().write(element);
  }

  public writeCloseElement(element: org.dom4j.Element): void {
    this.getWriter().writeClose(element);
  }

  public writeOpenElement(element: org.dom4j.Element): void {
    this.getWriter().writeOpen(element);
  }

  private getWriter(): XMLWriter {
    if (this.xmlWriter === null) {
      this.xmlWriter = this.outputFormat ? new XMLWriter(this.outputFormat) : new XMLWriter();
    }
    return this.xmlWriter;
  }
}