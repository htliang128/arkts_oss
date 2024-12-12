import Document from "../Document";
import DocumentFactory from "../DocumentFactory";
import DocumentType from "../DocumentType";
import DOMAttribute from "./DOMAttribute";
import DOMCDATA from "./DOMCDATA";
import DOMComment from "./DOMComment";
import DOMDocument from "./DOMDocument";
import DOMDocumentType from "./DOMDocumentType";
import DOMElement from "./DOMElement";
import DOMText from "./DOMText";

export default class DOMDocumentFactory extends DocumentFactory implements DOMImplementation {
  private static singleton: SingletonStrategy<DOMDocumentFactory>;

  constructor() {
    super();
  }

  public static getInstance(): DocumentFactory {
    return DOMDocumentFactory.singleton.instance() as DocumentFactory;
  }

  public createDocument(): Document {
    const answer = new DOMDocument();
    answer.setDocumentFactory(this);
    return answer;
  }

  public createDocType(name: string, publicId: string, systemId: string): DocumentType {
    return new DOMDocumentType(name, publicId, systemId);
  }

  public createElement(qname: QName): Element {
    return new DOMElement(qname);
  }

  public createElement(qname: QName, attributeCount: number): Element {
    return new DOMElement(qname, attributeCount);
  }

  public createAttribute(owner: Element, qname: QName, value: string): Attribute {
    return new DOMAttribute(qname, value);
  }

  public createCDATA(text: string): CDATA {
    return new DOMCDATA(text);
  }

  public createComment(text: string): Comment {
    return new DOMComment(text);
  }

  public createText(text: string): Text {
    return new DOMText(text);
  }

  public createEntity(name: string): Entity {
    return new DOMEntityReference(name);
  }

  public createEntity(name: string, text: string): Entity {
    return new DOMEntityReference(name, text);
  }

  public createNamespace(prefix: string, uri: string): Namespace {
    return new DOMNamespace(prefix, uri);
  }

  public createProcessingInstruction(target: string, data: string): ProcessingInstruction {
    return new DOMProcessingInstruction(target, data);
  }

  public createProcessingInstruction(target: string, data: Map<string, string>): ProcessingInstruction {
    return new DOMProcessingInstruction(target, data);
  }

  public hasFeature(feat: string, version: string): boolean {
    if (!"XML".equalsIgnoreCase(feat) && !"Core".equalsIgnoreCase(feat)) {
      return false;
    } else {
      return version == null || version.length === 0 || "1.0" === version || "2.0" === version;
    }
  }

  public createDocumentType(qualifiedName: string, publicId: string, systemId: string): DocumentType {
    return new DOMDocumentType(qualifiedName, publicId, systemId);
  }

  public createDocument(namespaceURI: string, qualifiedName: string, docType: org.w3c.dom.DocumentType): Document {
    let document: DOMDocument;
    if (docType != null) {
      const documentType = this.asDocumentType(docType);
      document = new DOMDocument(documentType);
    } else {
      document = new DOMDocument();
    }

    document.addElement(this.createQName(qualifiedName, namespaceURI));
    return document;
  }

  protected asDocumentType(docType: org.w3c.dom.DocumentType): DOMDocumentType {
    return docType instanceof DOMDocumentType ? docType : new DOMDocumentType(docType.name, docType.publicId, docType.systemId);
  }

  public getFeature(feature: string, version: string): any {
    DOMNodeHelper.notSupported();
    return null;
  }

  static {
    try {
      const defaultSingletonClass = "org.dom4j.util.SimpleSingleton";
      let clazz: any = null;

      try {
        let singletonClass = defaultSingletonClass;
        singletonClass = System.getProperty("org.dom4j.dom.DOMDocumentFactory.singleton.strategy", singletonClass);
        clazz = Class.forName(singletonClass);
      } catch (e1) {
        try {
          const singletonClass = defaultSingletonClass;
          clazz = Class.forName(singletonClass);
        } catch (e2) {}
      }

      DOMDocumentFactory.singleton = clazz.newInstance() as SingletonStrategy<DOMDocumentFactory>;
      DOMDocumentFactory.singleton.setSingletonClassName(DOMDocumentFactory.name);
    } catch (e) {}
  }
}