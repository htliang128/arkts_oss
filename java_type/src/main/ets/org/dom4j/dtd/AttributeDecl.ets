import Decl from "./Decl";

export default class AttributeDecl implements Decl {
  private elementName: string;
  private attributeName: string;
  private type: string;
  private value: string;
  private valueDefault: string;

  constructor();
  constructor(elementName: string, attributeName: string, type: string, valueDefault: string, value: string);
  constructor(arg1?: string, attributeName?: string, type?: string, valueDefault?: string, value?: string) {
    if (arg1) {
      this.elementName = arg1;
      this.attributeName = attributeName!;
      this.type = type!;
      this.valueDefault = valueDefault!;
      this.value = value!;
    }
  }

  getElementName(): string {
    return this.elementName;
  }

  setElementName(elementName: string): void {
    this.elementName = elementName;
  }

  getAttributeName(): string {
    return this.attributeName;
  }

  setAttributeName(attributeName: string): void {
    this.attributeName = attributeName;
  }

  getType(): string {
    return this.type;
  }

  setType(type: string): void {
    this.type = type;
  }

  getValue(): string {
    return this.value;
  }

  setValue(value: string): void {
    this.value = value;
  }

  getValueDefault(): string {
    return this.valueDefault;
  }

  setValueDefault(valueDefault: string): void {
    this.valueDefault = valueDefault;
  }

  toString(): string {
    let buffer = "<!ATTLIST ";
    buffer += this.elementName + " ";
    buffer += this.attributeName + " ";
    buffer += this.type + " ";
    if (this.valueDefault != null) {
      buffer += this.valueDefault;
      if (this.valueDefault === "#FIXED") {
        buffer += ` "${this.value}"`;
      }
    } else {
      buffer += `"${this.value}"`;
    }
    buffer += ">";
    return buffer;
  }
}