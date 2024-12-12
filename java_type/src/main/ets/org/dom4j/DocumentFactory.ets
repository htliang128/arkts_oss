export default class  DocumentFactory implements Serializable {
  private static singleton: SingletonStrategy<DocumentFactory> | null = null;
  protected cache: QNameCache;
  private xpathNamespaceURIs: Map<string, string>;

  private static createSingleton(): SingletonStrategy<DocumentFactory> {
    let documentFactoryClassName: string;
    try {
    documentFactoryClassName = System.getProperty("org.dom4j.factory", "org.dom4j.DocumentFactory");
  } catch (e) {
    documentFactoryClassName = "org.dom4j.DocumentFactory";
  }

  let result: SingletonStrategy;
  try {
    let singletonClass = System.getProperty("org.dom4j.DocumentFactory.singleton.strategy", "org.dom4j.util.SimpleSingleton");
    let clazz = Class.forName(singletonClass);
    result = clazz.newInstance();
  } catch (e) {
    result = new SimpleSingleton();
  }

  result.setSingletonClassName(documentFactoryClassName);
  return result;
}

constructor() {
  this.init();
}

public static getInstance(): DocumentFactory {
  if (this.singleton == null) {
    this.singleton = this.createSingleton();
  }

  return this.singleton.instance();
}

public createDocument(): Document {
  let answer = new DefaultDocument();
  answer.setDocumentFactory(this);
  return answer;
}

public createDocument(encoding: string): Document {
  let answer = this.createDocument();
  answer.setXMLEncoding(encoding);
  return answer;
}

public createDocument(rootElement: Element): Document {
  let answer = this.createDocument();
  answer.setRootElement(rootElement);
  return answer;
}

public createDocType(name: string, publicId: string, systemId: string): DocumentType {
  return new DefaultDocumentType(name, publicId, systemId);
}

public createElement(qname: QName): Element {
  return new DefaultElement(qname);
}

public createElement(name: string): Element {
  return this.createElement(this.createQName(name));
}

public createElement(qualifiedName: string, namespaceURI: string): Element {
  return this.createElement(this.createQName(qualifiedName, namespaceURI));
}

public createAttribute(owner: Element, qname: QName, value: string): Attribute {
  return new DefaultAttribute(qname, value);
}

public createAttribute(owner: Element, name: string, value: string): Attribute {
  return this.createAttribute(owner, this.createQName(name), value);
}

public createCDATA(text: string): CDATA {
  return new DefaultCDATA(text);
}

public createComment(text: string): Comment {
  return new DefaultComment(text);
}

public createText(text: string): Text {
  if (text == null) {
    let msg = "Adding text to an XML document must not be null";
    throw new IllegalArgumentException(msg);
  } else {
    return new DefaultText(text);
  }
}

public createEntity(name: string, text: string): Entity {
  return new DefaultEntity(name, text);
}

public createNamespace(prefix: string, uri: string): Namespace {
  return Namespace.get(prefix, uri);
}

public createProcessingInstruction(target: string, data: string): ProcessingInstruction {
  return new DefaultProcessingInstruction(target, data);
}

public createProcessingInstruction(target: string, data: Map<string, string>): ProcessingInstruction {
  return new DefaultProcessingInstruction(target, data);
}

public createQName(localName: string, namespace: Namespace): QName {
  return this.cache.get(localName, namespace);
}

public createQName(localName: string): QName {
  return this.cache.get(localName);
}

public createQName(name: string, prefix: string, uri: string): QName {
  return this.cache.get(name, Namespace.get(prefix, uri));
}

public createQName(qualifiedName: string, uri: string): QName {
  return this.cache.get(qualifiedName, uri);
}

public createXPath(xpathExpression: string): XPath {
  let xpath = new DefaultXPath(xpathExpression);
  if (this.xpathNamespaceURIs != null) {
    xpath.setNamespaceURIs(this.xpathNamespaceURIs);
  }

  return xpath;
}

public createXPath(xpathExpression: string, variableContext: VariableContext): XPath {
  let xpath = this.createXPath(xpathExpression);
  xpath.setVariableContext(variableContext);
  return xpath;
}

public createXPathFilter(xpathFilterExpression: string, variableContext: VariableContext): NodeFilter {
  let answer = this.createXPath(xpathFilterExpression);
  answer.setVariableContext(variableContext);
  return answer;
}

public createXPathFilter(xpathFilterExpression: string): NodeFilter {
  return this.createXPath(xpathFilterExpression);
}

public createPattern(xpathPattern: string): Pattern {
  return new XPathPattern(xpathPattern);
}

public getQNames(): List<QName> {
  return this.cache.getQNames();
}

public getXPathNamespaceURIs(): Map<string, string> {
  return this.xpathNamespaceURIs;
}

public setXPathNamespaceURIs(namespaceURIs: Map<string, string>): void {
  this.xpathNamespaceURIs = namespaceURIs;
}

protected static createSingleton(className: string): DocumentFactory {
  try {
    let theClass = Class.forName(className, true, DocumentFactory.class.getClassLoader());
    return theClass.newInstance();
  } catch (e) {
    console.log("WARNING: Cannot load DocumentFactory: " + className);
    return new DocumentFactory();
  }
}

protected intern(qname: QName): QName {
  return this.cache.intern(qname);
}

protected createQNameCache(): QNameCache {
  return new QNameCache(this);
}

private readObject(in: ObjectInputStream): void {
  in.defaultReadObject();
  this.init();
}

protected init(): void {
  this.cache = this.createQNameCache();
}
}