export default class JAXPHelper {
  protected constructor() {}

  public static createXMLReader(validating: boolean, namespaceAware: boolean): XMLReader {
    const factory: SAXParserFactory = SAXParserFactory.newInstance();
    factory.setValidating(validating);
    factory.setNamespaceAware(namespaceAware);
    const parser: SAXParser = factory.newSAXParser();
    return parser.getXMLReader();
  }

  public static createDocument(validating: boolean, namespaceAware: boolean): Document {
    const factory: DocumentBuilderFactory = DocumentBuilderFactory.newInstance();
    factory.setValidating(validating);
    factory.setNamespaceAware(namespaceAware);
    const builder: DocumentBuilder = factory.newDocumentBuilder();
    return builder.newDocument();
  }
}