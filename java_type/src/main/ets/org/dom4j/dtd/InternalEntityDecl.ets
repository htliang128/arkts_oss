import Decl from "./Decl";

export default class InternalEntityDecl implements Decl {
  private name: string;
  private value: string;

  constructor();

  constructor(name: string, value: string);

  constructor(name?: string, value?: string) {
    this.name = name || '';
    this.value = value || '';
  }

  getName(): string {
    return this.name;
  }

  setName(name: string): void {
    this.name = name;
  }

  getValue(): string {
    return this.value;
  }

  setValue(value: string): void {
    this.value = value;
  }

  toString(): string {
    let buffer = "<!ENTITY ";
    if (this.name.startsWith("%")) {
      buffer += "% " + this.name.substring(1);
    } else {
      buffer += this.name;
    }

    buffer += " \"" + this.escapeEntityValue(this.value) + "\">";
    return buffer;
  }

  private escapeEntityValue(text: string): string {
    let result = "";

    for (let i = 0; i < text.length; ++i) {
      const c = text.charAt(i);
      switch (c) {
        case '"':
          result += "&#34;";
          break;
        case '&':
          result += "&#38;#38;";
          break;
        case '\'':
          result += "&#39;";
          break;
        case '<':
          result += "&#38;#60;";
          break;
        case '>':
          result += "&#62;";
          break;
        default:
          if (c < ' ') {
            result += "&#" + c.charCodeAt(0) + ";";
          } else {
            result += c;
          }
      }
    }

    return result;
  }
}
