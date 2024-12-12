export default  abstract class ProxyDocumentFactory {
  private proxy: DocumentFactory;

  constructor(proxy?: DocumentFactory) {
    this.proxy = proxy || DocumentFactory.getInstance();
  }

  createDocument(): Document {
    return this.proxy.createDocument();
  }

  createDocumentWithRootElement(rootElement: Element): Document {
    return this.proxy.createDocument(rootElement);
  }

  createDocType(name: string, publicId: string, systemId: string): DocumentType {
    return this.proxy.createDocType(name, publicId, systemId);
  }

  createElement(qname: QName): Element {
    return this.proxy.createElement(qname);
  }

  createElementWithName(name: string): Element {
    return this.proxy.createElement(name);
  }

  createAttribute(owner: Element, qname: QName, value: string): Attribute {
    return this.proxy.createAttribute(owner, qname, value);
  }

  createAttributeWithName(owner: Element, name: string, value: string): Attribute {
    return this.proxy.createAttribute(owner, name, value);
  }

  createCDATA(text: string): CDATA {
    return this.proxy.createCDATA(text);
  }

  createComment(text: string): Comment {
    return this.proxy.createComment(text);
  }

  createText(text: string): Text {
    return this.proxy.createText(text);
  }

  createEntity(name: string, text: string): Entity {
    return this.proxy.createEntity(name, text);
  }

  createNamespace(prefix: string, uri: string): Namespace {
    return this.proxy.createNamespace(prefix, uri);
  }

  createProcessingInstruction(target: string, data: string): ProcessingInstruction {
    return this.proxy.createProcessingInstruction(target, data);
  }

  createProcessingInstructionWithMap(target: string, data: Map<string, string>): ProcessingInstruction {
    return this.proxy.createProcessingInstruction(target, data);
  }

  createQName(localName: string, namespace: Namespace): QName {
    return this.proxy.createQName(localName, namespace);
  }

  createQNameWithName(localName: string): QName {
    return this.proxy.createQName(localName);
  }

  createQNameWithPrefix(name: string, prefix: string, uri: string): QName {
    return this.proxy.createQName(name, prefix, uri);
  }

  createQNameWithQualifiedName(qualifiedName: string, uri: string): QName {
    return this.proxy.createQName(qualifiedName, uri);
  }

  createXPath(xpathExpression: string): XPath {
    return this.proxy.createXPath(xpathExpression);
  }

  createXPathWithVariableContext(xpathExpression: string, variableContext: VariableContext): XPath {
    return this.proxy.createXPath(xpathExpression, variableContext);
  }

  createXPathFilter(xpathFilterExpression: string, variableContext: VariableContext): NodeFilter {
    return this.proxy.createXPathFilter(xpathFilterExpression, variableContext);
  }

  createXPathFilterWithExpression(xpathFilterExpression: string): NodeFilter {
    return this.proxy.createXPathFilter(xpathFilterExpression);
  }

  createPattern(xpathPattern: string): Pattern {
    return this.proxy.createPattern(xpathPattern);
  }

  protected getProxy(): DocumentFactory {
    return this.proxy;
  }

  protected setProxy(proxy: DocumentFactory) {
    this.proxy = proxy || DocumentFactory.getInstance();
  }
}