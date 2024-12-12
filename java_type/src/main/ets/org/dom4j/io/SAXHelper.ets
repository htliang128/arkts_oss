export default class SAXHelper {
  private static loggedWarning: boolean = true;

  protected constructor() {}

  public static setParserProperty(reader: XMLReader, propertyName: string, value: any): boolean {
    try {
      reader.setProperty(propertyName, value);
      return true;
    } catch (e) {
      // Handle SAXNotSupportedException and SAXNotRecognizedException
    }
    return false;
  }

  public static setParserFeature(reader: XMLReader, featureName: string, value: boolean): boolean {
    try {
      reader.setFeature(featureName, value);
      return true;
    } catch (e) {
      // Handle SAXNotSupportedException and SAXNotRecognizedException
    }
    return false;
  }

  public static createXMLReader(validating: boolean): XMLReader {
    let reader: XMLReader | null = null;

    if (reader === null) {
      reader = this.createXMLReaderViaJAXP(validating, true);
    }

    if (reader === null) {
      try {
        reader = XMLReaderFactory.createXMLReader();
      } catch (e) {
        if (this.isVerboseErrorReporting()) {
          console.warn("Warning: Caught exception attempting to use SAX to load a SAX XMLReader");
          console.warn("Warning: Exception was:", e);
          console.warn("Warning: I will print the stack trace then carry on using the default SAX parser");
          console.error(e);
        }
        throw new SAXException(e);
      }
    }

    if (reader === null) {
      throw new SAXException("Couldn't create SAX reader");
    } else {
      this.setParserFeature(reader, "http://xml.org/sax/features/namespaces", true);
      this.setParserFeature(reader, "http://xml.org/sax/features/namespace-prefixes", false);
      this.setParserFeature(reader, "http://xml.org/sax/properties/external-general-entities", false);
      this.setParserFeature(reader, "http://xml.org/sax/properties/external-parameter-entities", false);
      this.setParserFeature(reader, "http://apache.org/xml/features/nonvalidating/load-external-dtd", false);
      this.setParserFeature(reader, "http://xml.org/sax/features/use-locator2", true);
      return reader;
    }
  }

  protected static createXMLReaderViaJAXP(validating: boolean, namespaceAware: boolean): XMLReader | null {
    try {
      return JAXPHelper.createXMLReader(validating, namespaceAware);
    } catch (e) {
      if (!this.loggedWarning) {
        this.loggedWarning = true;
        if (this.isVerboseErrorReporting()) {
          console.warn("Warning: Caught exception attempting to use JAXP to load a SAX XMLReader");
          console.warn("Warning: Exception was:", e);
          console.error(e);
        }
      }
      return null;
    }
  }

  protected static isVerboseErrorReporting(): boolean {
    try {
      const flag = process.env['org.dom4j.verbose'];
      return flag != null && flag.toLowerCase() === "true";
    } catch (e) {
      return true;
    }
  }
}