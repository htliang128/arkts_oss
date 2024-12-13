import Document from "./Document";
import DocumentFactory from "./DocumentFactory";
import Element from "./Element";

export default  class DocumentHelper {
  private constructor() {}

  private static getDocumentFactory(): DocumentFactory {
    return DocumentFactory.getInstance();
  }

  public static createDocument(): Document {
    return this.getDocumentFactory().createDocument();
  }

  public static createDocument(rootElement: Element): Document {
    return this.getDocumentFactory().createDocument(rootElement);
  }

  public static createElement(qname: QName): Element {
    return this.getDocumentFactory().createElement(qname);
  }

  public static createElement(name: string): Element {
    return this.getDocumentFactory().createElement(name);
  }

  public static createAttribute(owner: Element, qname: QName, value: string): Attribute {
    return this.getDocumentFactory().createAttribute(owner, qname, value);
  }

  public static createAttribute(owner: Element, name: string, value: string): Attribute {
    return this.getDocumentFactory().createAttribute(owner, name, value);
  }

  public static createCDATA(text: string): CDATA {
    return DocumentFactory.getInstance().createCDATA(text);
  }

  public static createComment(text: string): Comment {
    return DocumentFactory.getInstance().createComment(text);
  }

  public static createText(text: string): Text {
    return DocumentFactory.getInstance().createText(text);
  }

  public static createEntity(name: string, text: string): Entity {
    return DocumentFactory.getInstance().createEntity(name, text);
  }

  public static createNamespace(prefix: string, uri: string): Namespace {
    return DocumentFactory.getInstance().createNamespace(prefix, uri);
  }

  public static createProcessingInstruction(pi: string, d: string): ProcessingInstruction {
    return this.getDocumentFactory().createProcessingInstruction(pi, d);
  }

  public static createProcessingInstruction(pi: string, data: Map<string, string>): ProcessingInstruction {
    return this.getDocumentFactory().createProcessingInstruction(pi, data);
  }

  public static createQName(localName: string, namespace: Namespace): QName {
    return this.getDocumentFactory().createQName(localName, namespace);
  }

  public static createQName(localName: string): QName {
    return this.getDocumentFactory().createQName(localName);
  }

  public static createXPath(xpathExpression: string): XPath {
    return this.getDocumentFactory().createXPath(xpathExpression);
  }

  public static createXPath(xpathExpression: string, context: VariableContext): XPath {
    return this.getDocumentFactory().createXPath(xpathExpression, context);
  }

  public static createXPathFilter(xpathFilterExpression: string): NodeFilter {
    return this.getDocumentFactory().createXPathFilter(xpathFilterExpression);
  }

  public static createPattern(xpathPattern: string): Pattern {
    return this.getDocumentFactory().createPattern(xpathPattern);
  }

  public static selectNodes(xpathFilterExpression: string, nodes: Node[]): Node[] {
    const xpath = this.createXPath(xpathFilterExpression);
    return xpath.selectNodes(nodes);
  }

  public static selectNodes(xpathFilterExpression: string, node: Node): Node[] {
    const xpath = this.createXPath(xpathFilterExpression);
    return xpath.selectNodes(node);
  }

  public static sort(list: Node[], xpathExpression: string): void {
    const xpath = this.createXPath(xpathExpression);
    xpath.sort(list);
  }

  public static sort(list: Node[], expression: string, distinct: boolean): void {
    const xpath = this.createXPath(expression);
    xpath.sort(list, distinct);
  }

  public static async parseText(text: string): Promise<Document> {
    const reader = SAXReader.createDefault();
    const encoding = this.getEncoding(text);
    const source = new InputSource(new StringReader(text));
    source.setEncoding(encoding);
    const result = await reader.read(source);
    if (result.getXMLEncoding() == null) {
      result.setXMLEncoding(encoding);
    }

    return result;
  }

  private static getEncoding(text: string): string {
    let result = null;
    const xml = text.trim();
    if (xml.startsWith("<?xml")) {
      const end = xml.indexOf("?>");
      const sub = xml.substring(0, end);
      const tokens = sub.split(" =\"'");

      for (let token of tokens) {
        if ("encoding" == token) {
          result = tokens[tokens.indexOf(token) + 1];
          break;
        }
      }
    }

    return result;
  }

  public static makeElement(source: Branch, path: string): Element {
    const tokens = path.split("/");
    let parent: Element;
    let name: string;
    if (source instanceof Document) {
      const document = source;
      parent = document.getRootElement();
      name = tokens.shift();
      if (parent == null) {
        parent = document.addElement(name);
      }
    } else {
      parent = source as Element;
    }

    let element: Element;
    for (element = null; tokens.length > 0; parent = element) {
      name = tokens.shift();
      if (name.indexOf(":") > 0) {
        element = parent.element(parent.getQName(name));
      } else {
        element = parent.element(name);
      }

      if (element == null) {
        element = parent.addElement(name);
      }
    }

    return element;
  }
}