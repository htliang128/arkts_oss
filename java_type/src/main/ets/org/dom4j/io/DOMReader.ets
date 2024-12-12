export default class DOMReader {
  private factory: DocumentFactory;
  private namespaceStack: NamespaceStack;

  constructor() {
    this.factory = DocumentFactory.getInstance();
    this.namespaceStack = new NamespaceStack(this.factory);
  }

  constructor(factory: DocumentFactory) {
    this.factory = factory;
    this.namespaceStack = new NamespaceStack(factory);
  }

  getDocumentFactory(): DocumentFactory {
    return this.factory;
  }

  setDocumentFactory(docFactory: DocumentFactory): void {
    this.factory = docFactory;
    this.namespaceStack.setDocumentFactory(this.factory);
  }

  read(domDocument: org.w3c.dom.Document): Document {
    if (domDocument instanceof Document) {
      return domDocument;
    } else {
      const document = this.createDocument();
      this.clearNamespaceStack();
      const nodeList: NodeList = domDocument.getChildNodes();
      for (let i = 0; i < nodeList.getLength(); i++) {
        this.readTree(nodeList.item(i), document);
      }
      return document;
    }
  }

  protected readTree(node: Node, current: Branch): void {
    let element: Element | null = null;
    let document: Document | null = null;
    if (current instanceof Element) {
      element = current;
    } else {
      document = current;
    }

    switch (node.getNodeType()) {
      case 1:
        this.readElement(node, current);
        break;
      case 2:
      case 9:
      default:
        console.warn("WARNING: Unknown DOM node type: " + node.getNodeType());
        break;
      case 3:
        element?.addText(node.getNodeValue());
        break;
      case 4:
        element?.addCDATA(node.getNodeValue());
        break;
      case 5:
        const firstChild = node.getFirstChild();
        element?.addEntity(node.getNodeName(), firstChild ? firstChild.getNodeValue() : "");
        break;
      case 6:
        element?.addEntity(node.getNodeName(), node.getNodeValue());
        break;
      case 7:
        if (current instanceof Element) {
          const currentEl = current as Element;
          currentEl.addProcessingInstruction(node.getNodeName(), node.getNodeValue());
        } else {
          const currentDoc = current as Document;
          currentDoc.addProcessingInstruction(node.getNodeName(), node.getNodeValue());
        }
        break;
      case 8:
        if (current instanceof Element) {
          (current as Element).addComment(node.getNodeValue());
        } else {
          (current as Document).addComment(node.getNodeValue());
        }
        break;
      case 10:
        const domDocType = node as DocumentType;
        document?.addDocType(domDocType.getName(), domDocType.getPublicId(), domDocType.getSystemId());
    }
  }

  protected readElement(node: Node, current: Branch): void {
    const previouslyDeclaredNamespaces = this.namespaceStack.size();
    let namespaceUri = node.getNamespaceURI();
    let elementPrefix = node.getPrefix() || "";

    const attributeList: NamedNodeMap | null = node.getAttributes();
    if (attributeList && namespaceUri == null) {
      const attribute = attributeList.getNamedItem("xmlns");
      if (attribute) {
        namespaceUri = attribute.getNodeValue();
        elementPrefix = "";
      }
    }

    const qName: QName = this.namespaceStack.getQName(namespaceUri, node.getLocalName(), node.getNodeName());
    const element: Element = current.addElement(qName);
    if (attributeList) {
      const attributes: Node[] = [];
      for (let i = 0; i < attributeList.getLength(); i++) {
        const attribute = attributeList.item(i);
        const name = attribute.getNodeName();
        if (name.startsWith("xmlns")) {
          const prefix = this.getPrefix(name);
          const uri = attribute.getNodeValue();
          const namespace: Namespace = this.namespaceStack.addNamespace(prefix, uri);
          element.add(namespace);
        } else {
          attributes.push(attribute);
        }
      }

      for (const attribute of attributes) {
        const attributeQName: QName = this.namespaceStack.getQName(attribute.getNamespaceURI(), attribute.getLocalName(), attribute.getNodeName());
        element.addAttribute(attributeQName, attribute.getNodeValue());
      }
    }

    const children: NodeList = node.getChildNodes();
    for (let i = 0; i < children.getLength(); i++) {
      const attribute = children.item(i);
      this.readTree(attribute, element);
    }

    while (this.namespaceStack.size() > previouslyDeclaredNamespaces) {
      this.namespaceStack.pop();
    }
  }

  protected getNamespace(prefix: string, uri: string): Namespace {
    return this.getDocumentFactory().createNamespace(prefix, uri);
  }

  protected createDocument(): Document {
    return this.getDocumentFactory().createDocument();
  }

  protected clearNamespaceStack(): void {
    this.namespaceStack.clear();
    if (!this.namespaceStack.contains(Namespace.XML_NAMESPACE)) {
      this.namespaceStack.push(Namespace.XML_NAMESPACE);
    }
  }

  private getPrefix(xmlnsDecl: string): string {
    const index = xmlnsDecl.indexOf(':', 5);
    return index !== -1 ? xmlnsDecl.substring(index + 1) : "";
  }
}