export default  abstract class JAXBSupport {
  private contextPath: string;
  private classloader: ClassLoader;
  private jaxbContext: JAXBContext;
  private marshaller: Marshaller;
  private unmarshaller: Unmarshaller;

  public constructor(contextPath: string);
  public constructor(contextPath: string, classloader: ClassLoader);
  public constructor(arg1: string, arg2?: any) {
    this.contextPath = arg1;
    this.classloader = arg2;
  }

  protected marshal(element: javax.xml.bind.Element): Element {
    const doc = new DOMDocument();
    this.getMarshaller().marshal(element, doc);
    return doc.getRootElement();
  }

  protected unmarshal(element: Element): javax.xml.bind.Element {
    const source: Source = new StreamSource(new StringReader(element.asXML()));
    return this.getUnmarshaller().unmarshal(source) as javax.xml.bind.Element;
  }

  private getMarshaller(): Marshaller {
    if (!this.marshaller) {
      this.marshaller = this.getContext().createMarshaller();
    }
    return this.marshaller;
  }

  private getUnmarshaller(): Unmarshaller {
    if (!this.unmarshaller) {
      this.unmarshaller = this.getContext().createUnmarshaller();
    }
    return this.unmarshaller;
  }

  private getContext(): JAXBContext {
    if (!this.jaxbContext) {
      this.jaxbContext = this.classloader ?
      JAXBContext.newInstance(this.contextPath, this.classloader) :
      JAXBContext.newInstance(this.contextPath);
    }
    return this.jaxbContext;
  }
}