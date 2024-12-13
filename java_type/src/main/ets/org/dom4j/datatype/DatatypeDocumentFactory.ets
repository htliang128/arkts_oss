import Document from "../Document";
import SAXReader from "../io/SAXReader";
import Namespace from "../Namespace";
import QName from "../QName";
import DatatypeElementFactory from "./DatatypeElementFactory";
import InvalidSchemaException from "./InvalidSchemaException";
import SchemaParser from "./SchemaParser";

export default class DatatypeDocumentFactory extends DocumentFactory {
  private static singleton: DatatypeDocumentFactory = new DatatypeDocumentFactory();

  private static XSI_NAMESPACE: Namespace = Namespace.get("xsi", "http://www.w3.org/2001/XMLSchema-instance");

  private static XSI_SCHEMA_LOCATION: QName = QName.get("schemaLocation", DatatypeDocumentFactory.XSI_NAMESPACE);

  private static XSI_NO_SCHEMA_LOCATION: QName = QName.get("noNamespaceSchemaLocation", DatatypeDocumentFactory.XSI_NAMESPACE);

  private schemaBuilder: SchemaParser;

  private xmlSchemaReader: SAXReader = new SAXReader();

  private autoLoadSchema: boolean = true;

  constructor() {
    super();
    this.schemaBuilder = new SchemaParser(this);
  }

  static getInstance(): DocumentFactory {
    return DatatypeDocumentFactory.singleton;
  }

  loadSchema(schemaDocument: Document): void {
    this.schemaBuilder.build(schemaDocument);
  }

  loadSchemaWithNamespace(schemaDocument: Document, targetNamespace: Namespace): void {
    this.schemaBuilder.buildWithNamespace(schemaDocument, targetNamespace);
  }

  getElementFactory(elementQName: QName): DatatypeElementFactory | null {
    let result: DatatypeElementFactory | null = null;

    let factory = elementQName.getDocumentFactory();
    if (factory instanceof DatatypeElementFactory) {
      result = factory;
    }

    return result;
  }

  createAttribute(owner: Element, qname: QName, value: string): Attribute {
    if (this.autoLoadSchema && qname.equals(DatatypeDocumentFactory.XSI_NO_SCHEMA_LOCATION)) {
      let document = (owner !== null) ? owner.getDocument() : null;
      this.loadSchemaFromURI(document, value);
    } else if (this.autoLoadSchema && qname.equals(DatatypeDocumentFactory.XSI_SCHEMA_LOCATION)) {
      let document = (owner !== null) ? owner.getDocument() : null;
      let uri = value.substring(0, value.indexOf(' '));
      let namespace = owner.getNamespaceForURI(uri);
      this.loadSchemaFromURIWithNamespace(document, value.substring(value.indexOf(' ') + 1), namespace);
    }

    return super.createAttribute(owner, qname, value);
  }

  private loadSchemaFromURI(document: Document | null, schemaInstanceURI: string): void {
    try {
      let resolver = document?.getEntityResolver();

      if (!resolver) {
        throw new InvalidSchemaException("No EntityResolver available for resolving URI: " + schemaInstanceURI);
      }

      let inputSource = resolver.resolveEntity(null, schemaInstanceURI);

      if (!inputSource) {
        throw new InvalidSchemaException("Could not resolve the URI: " + schemaInstanceURI);
      }

      let schemaDocument = this.xmlSchemaReader.read(inputSource);
      this.loadSchema(schemaDocument);
    } catch (e) {
      console.error("Failed to load schema: " + schemaInstanceURI);
      console.error("Caught: " + e);
      throw new InvalidSchemaException("Failed to load schema: " + schemaInstanceURI);
    }
  }

  private loadSchemaFromURIWithNamespace(document: Document | null, schemaInstanceURI: string, namespace: Namespace): void {
    try {
      let resolver = document?.getEntityResolver();

      if (!resolver) {
        throw new InvalidSchemaException("No EntityResolver available for resolving URI: " + schemaInstanceURI);
      }

      let inputSource = resolver.resolveEntity(null, schemaInstanceURI);

      if (!inputSource) {
        throw new InvalidSchemaException("Could not resolve the URI: " + schemaInstanceURI);
      }

      let schemaDocument = this.xmlSchemaReader.read(inputSource);
      this.loadSchemaWithNamespace(schemaDocument, namespace);
    } catch (e) {
      console.error("Failed to load schema: " + schemaInstanceURI);
      console.error("Caught: " + e);
      throw new InvalidSchemaException("Failed to load schema: " + schemaInstanceURI);
    }
  }
}