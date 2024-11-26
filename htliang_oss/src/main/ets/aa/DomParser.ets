import Element from "./Element";

export default class DomParser {
  public static parseXmlElement(xml: string): Element | null {
    const tagMatch = xml.match(/^<([\w-]+)>/);
    if (!tagMatch) {
      return null;
    }

    const tagName = tagMatch[1];
    const element = new Element(tagName);

    const closingTag = `</${tagName}>`;
    const closingIndex = xml.indexOf(closingTag);

    if (closingIndex === -1) {
      return null;
    }

    const innerXml = xml.substring(tagMatch[0].length, closingIndex).trim();

    let lastIndex = 0;
    const childRegex = /<([\w-]+)>.*?<\/\1>/g;
    let childMatch: RegExpExecArray | null;

    while ((childMatch = childRegex.exec(innerXml)) !== null) {
      const childElement = DomParser.parseXmlElement(childMatch[0]);
      if (childElement) {
        element.children.push(childElement);
      }
      lastIndex = childMatch.index + childMatch[0].length;
    }

    if (lastIndex < innerXml.length) {
      element.text = innerXml.substring(lastIndex).trim();
    }

    return element;
  }

  public static getXmlRootElement(body: string): Element | null {
    const trimmedBody = body.trim();
    return DomParser.parseXmlElement(trimmedBody);
  }
}