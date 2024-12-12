import Document from "../Document";
import Namespace from "../Namespace";
import QName from "../QName";
import DatatypeDocumentFactory from "./DatatypeDocumentFactory";
import InvalidSchemaException from "./InvalidSchemaException";

export default class SchemaParser {
  private static readonly XSD_NAMESPACE: Namespace = Namespace.get("xsd", "http://www.w3.org/2001/XMLSchema");

  // Use QNames for the elements
  private static readonly XSD_ELEMENT: QName = QName.get("element", SchemaParser.XSD_NAMESPACE);
  private static readonly XSD_ATTRIBUTE: QName = QName.get("attribute", SchemaParser.XSD_NAMESPACE);
  private static readonly XSD_SIMPLETYPE: QName = QName.get("simpleType", SchemaParser.XSD_NAMESPACE);
  private static readonly XSD_COMPLEXTYPE: QName = QName.get("complexType", SchemaParser.XSD_NAMESPACE);
  private static readonly XSD_RESTRICTION: QName = QName.get("restriction", SchemaParser.XSD_NAMESPACE);
  private static readonly XSD_SEQUENCE: QName = QName.get("sequence", SchemaParser.XSD_NAMESPACE);
  private static readonly XSD_CHOICE: QName = QName.get("choice", SchemaParser.XSD_NAMESPACE);
  private static readonly XSD_ALL: QName = QName.get("all", SchemaParser.XSD_NAMESPACE);
  private static readonly XSD_INCLUDE: QName = QName.get("include", SchemaParser.XSD_NAMESPACE);

  private documentFactory: DatatypeDocumentFactory;
  private dataTypeCache: Map<string, XSDatatype> = new Map<string, XSDatatype>();
  private namedTypeResolver: NamedTypeResolver;
  private targetNamespace: Namespace | null = null;

  constructor(documentFactory: DatatypeDocumentFactory = DatatypeDocumentFactory.singleton) {
    this.documentFactory = documentFactory;
    this.namedTypeResolver = new NamedTypeResolver(documentFactory);
  }

  public build(schemaDocument: Document, namespace?: Namespace): void {
    this.targetNamespace = namespace || null;
    this.internalBuild(schemaDocument);
  }

  private internalBuild(schemaDocument: Document): void {
    let root: Element | null = schemaDocument.getRootElement();

    if (root !== null) {
      for (let includeElement of root.elements(SchemaParser.XSD_INCLUDE)) {
        let inclSchemaInstanceURI: string | null = includeElement.attributeValue("schemaLocation");
        let resolver: any = schemaDocument.getEntityResolver(); // Replace 'any' with the type of your EntityResolver

        try {
          if (resolver === null) {
            throw new InvalidSchemaException("No EntityResolver available");
          }

          let inputSource: any = resolver.resolveEntity(null, inclSchemaInstanceURI); // Replace 'any' with the type of your InputSource

          if (inputSource === null) {
            throw new InvalidSchemaException("Could not resolve the schema URI: " + inclSchemaInstanceURI);
          }

          let reader: any = new SAXReader(); // Replace 'any' with the type of your SAXReader
          let inclSchemaDocument: Document = reader.read(inputSource);
          this.build(inclSchemaDocument);
        } catch (e) {
          console.error("Failed to load schema: " + inclSchemaInstanceURI);
          console.error("Caught: " + e);
          throw new InvalidSchemaException("Failed to load schema: " + inclSchemaInstanceURI);
        }
      }

      // handle elements
      for (let element of root.elements(SchemaParser.XSD_ELEMENT)) {
        this.onDatatypeElement(element, this.documentFactory);
      }

      // handle named simple types
      for (let element of root.elements(SchemaParser.XSD_SIMPLETYPE)) {
        this.onNamedSchemaSimpleType(element);
      }

      // handle named complex types
      for (let element of root.elements(SchemaParser.XSD_COMPLEXTYPE)) {
        this.onNamedSchemaComplexType(element);
      }

      this.namedTypeResolver.resolveNamedTypes();
    }
  }

  // ... (implement other methods similar to the ones above)
}