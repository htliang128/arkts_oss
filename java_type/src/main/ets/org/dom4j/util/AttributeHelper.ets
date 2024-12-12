export default  class AttributeHelper {
  protected constructor() {}

  public static booleanValue(element: Element, attributeName: string): boolean {
    return this.booleanValueFromAttribute(element.attribute(attributeName));
  }

  public static booleanValueFromQName(element: Element, attributeQName: QName): boolean {
    return this.booleanValueFromAttribute(element.attribute(attributeQName));
  }

  protected static booleanValueFromAttribute(attribute: Attribute): boolean {
    if (attribute === null) {
      return false;
    } else {
      const value = attribute.getData();
      if (value === null) {
        return false;
      } else if (typeof value === 'boolean') {
        return value;
      } else {
        return value.toString().toLowerCase() === 'true';
      }
    }
  }
}