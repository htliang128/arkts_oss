export default class DOMWriter {
  private static loggedWarning = false;
  private static DEFAULT_DOM_DOCUMENT_CLASSES: string[] = [
    "org.apache.xerces.dom.DocumentImpl",
    "gnu.xml.dom.DomDocument",
    "org.apache.crimson.tree.XmlDocument",
    "com.sun.xml.tree.XmlDocument",
    "oracle.xml.parser.v2.XMLDocument",
    "oracle.xml.parser.XMLDocument",
    "org.dom4j.dom.DOMDocument"
  ];
  private domDocumentClass: any;
  private namespaceStack: NamespaceStack = new NamespaceStack();

  constructor();
  constructor(domDocumentClass: any);
  constructor(domDocumentClass: any = null) {
    this.domDocumentClass = domDocumentClass;
  }

  public getDomDocumentClass(): Promise<any> {
    return new Promise((resolve, reject) => {
      let result = this.domDocumentClass;
      if (result == null) {
        for (const name of DOMWriter.DEFAULT_DOM_DOCUMENT_CLASSES) {
          try {
            result = require(name);
            if (result) {
              break;
            }
          } catch (e) {
            // Ignore
          }
        }
      }
      resolve(result);
    });
  }

  public setDomDocumentClass(domDocumentClass: any): void {
    this.domDocumentClass = domDocumentClass;
  }

  public setDomDocumentClassName(name: string): Promise<void> {
    return new Promise((resolve, reject) => {
      try {
        this.domDocumentClass = require(name);
        resolve();
      } catch (e) {
        reject(new DocumentException(`Could not load the DOM Document class: ${name}`, e));
      }
    });
  }

  public async write(document: any): Promise<Document> {
    if (document instanceof Document) {
      return document;
    } else {
      this.resetNamespaceStack();
      const domDocument = await this.createDomDocument(document);
      this.appendDOMTree(domDocument, domDocument, document.content());
      this.namespaceStack.clear();
      return domDocument;
    }
  }

  public async writeWithDOMImpl(document: any, domImpl: DOMImplementation): Promise<Document> {
    if (document instanceof Document) {
      return document;
    } else {
      this.resetNamespaceStack();
      const domDocument = await this.createDomDocument(document, domImpl);
      this.appendDOMTree(domDocument, domDocument, document.content());
      this.namespaceStack.clear();
      return domDocument;
    }
  }

  protected appendDOMTree(domDocument: Document, domCurrent: Node, content: any[]): void {
    for (const node of content) {
      if (node instanceof Element) {
        this.appendDOMTree(domDocument, domCurrent, node);
      } else if (node instanceof Text) {
        this.appendDOMTree(domDocument, domCurrent, node.getText());
      } else if (node instanceof CDATA) {
        this.appendDOMTree(domDocument, domCurrent, node);
      } else if (node instanceof Comment) {
        this.appendDOMTree(domDocument, domCurrent, node);
      } else if (node instanceof Entity) {
        this.appendDOMTree(domDocument, domCurrent, node);
      } else if (node instanceof ProcessingInstruction) {
        this.appendDOMTree(domDocument, domCurrent, node);
      }
    }
  }

  protected appendDOMTree(domDocument: Document, domCurrent: Node, element: Element): void {
    const elUri = element.getNamespaceURI();
    const elName = element.getQualifiedName();
    const domElement = domDocument.createElementNS(elUri, elName);
    const stackSize = this.namespaceStack.size();
    const elementNamespace = element.getNamespace();
    if (this.isNamespaceDeclaration(elementNamespace)) {
      this.namespaceStack.push(elementNamespace);
      this.writeNamespace(domElement, elementNamespace);
    }

    const declaredNamespaces = element.declaredNamespaces();
    for (const namespace of declaredNamespaces) {
      if (this.isNamespaceDeclaration(namespace)) {
        this.namespaceStack.push(namespace);
        this.writeNamespace(domElement, namespace);
      }
    }

    for (const attribute of element.attributes()) {
      const attUri = attribute.getNamespaceURI();
      const attName = attribute.getQualifiedName();
      const value = attribute.getValue();
      domElement.setAttributeNS(attUri, attName, value);
    }

    this.appendDOMTree(domDocument, domElement, element.content());
    domCurrent.appendChild(domElement);

    while (this.namespaceStack.size() > stackSize) {
      this.namespaceStack.pop();
    }
  }

  protected appendDOMTree(domDocument: Document, domCurrent: Node, cdata: CDATA): void {
    const domCDATA = domDocument.createCDATASection(cdata.getText());
    domCurrent.appendChild(domCDATA);
  }

  protected appendDOMTree(domDocument: Document, domCurrent: Node, comment: Comment): void {
    const domComment = domDocument.createComment(comment.getText());
    domCurrent.appendChild(domComment);
  }

  protected appendDOMTree(domDocument: Document, domCurrent: Node, text: string): void {
    const domText = domDocument.createTextNode(text);
    domCurrent.appendChild(domText);
  }

  protected appendDOMTree(domDocument: Document, domCurrent: Node, entity: Entity): void {
    const domEntity = domDocument.createEntityReference(entity.getName());
    domCurrent.appendChild(domEntity);
  }

  protected appendDOMTree(domDoc: Document, domCurrent: Node, pi: ProcessingInstruction): void {
    const domPI = domDoc.createProcessingInstruction(pi.getTarget(), pi.getText());
    domCurrent.appendChild(domPI);
  }

  protected writeNamespace(domElement: any, namespace: Namespace): void {
    const attributeName = this.attributeNameForNamespace(namespace);
    domElement.setAttribute(attributeName, namespace.getURI());
  }

  protected attributeNameForNamespace(namespace: Namespace): string {
    const xmlns = "xmlns";
    const prefix = namespace.getPrefix();
    return prefix.length > 0 ? `${xmlns}:${prefix}` : xmlns;
  }

  protected async createDomDocument(document: any): Promise<Document> {
    let result: Document = null;
    if (this.domDocumentClass != null) {
      try {
        result = new this.domDocumentClass();
      } catch (e) {
        throw new DocumentException(`Could not instantiate an instance of DOM Document with class: ${this.domDocumentClass.getName()}`, e);
      }
    } else {
      result = await this.createDomDocumentViaJAXP();
      if (result == null) {
        const theClass = await this.getDomDocumentClass();
        try {
          result = new theClass();
        } catch (e) {
          throw new DocumentException(`Could not instantiate an instance of DOM Document with class: ${theClass.getName()}`, e);
        }
      }
    }
    return result;
  }

  protected async createDomDocumentViaJAXP(): Promise<Document> {
    try {
      return await JAXPHelper.createDocument(false, true);
    } catch (e) {
      if (!DOMWriter.loggedWarning) {
        DOMWriter.loggedWarning = true;
        if (SAXHelper.isVerboseErrorReporting()) {
          console.warn("Warning: Caught exception attempting to use JAXP to create a W3C DOM document");
          console.warn("Warning: Exception was: ", e);
        } else {
          console.warn("Warning: Error occurred using JAXP to create a DOM document.");
        }
      }
      return null;
    }
  }

  protected createDomDocument(document: any, domImpl: DOMImplementation): Document {
    const namespaceURI = null;
    const qualifiedName = null;
    const docType: DocumentType = null;
    return domImpl.createDocument(namespaceURI, qualifiedName, docType);
  }

  protected isNamespaceDeclaration(ns: Namespace): boolean {
    if (ns != null && ns !== Namespace.NO_NAMESPACE && ns !== Namespace.XML_NAMESPACE) {
      const uri = ns.getURI();
      if (uri != null && uri.length > 0 && !this.namespaceStack.contains(ns)) {
        return true;
      }
    }
    return false;
  }

  protected resetNamespaceStack(): void {
    this.namespaceStack.clear();
    this.namespaceStack.push(Namespace.XML_NAMESPACE);
  }
}