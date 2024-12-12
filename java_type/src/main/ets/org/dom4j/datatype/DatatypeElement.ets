import QName from "../QName";
import DefaultElement from "../tree/DefaultElement";

export default class DatatypeElement extends DefaultElement {
  private datatype: XSDatatype;

  private data: any;

  constructor(qname: QName, datatype: XSDatatype, attributeCount?: number) {
    if (attributeCount !== undefined) {
      super(qname, attributeCount);
    } else {
      super(qname);
    }
    this.datatype = datatype;
  }

  toString(): string {
    return `${this.constructor.name}${this.hashCode()} [Element: <${this.getQualifiedName()} attributes: ${this.attributeList()} data: ${this.getData()} />]`;
  }

  getXSDatatype(): XSDatatype {
    return this.datatype;
  }

  getNamespacePrefix(uri: string): string | null {
    let namespace = this.getNamespaceForURI(uri);

    return (namespace !== null) ? namespace.getPrefix() : null;
  }

  getBaseUri(): string | null {
    return null;
  }

  isNotation(notationName: string): boolean {
    return false;
  }

  isUnparsedEntity(entityName: string): boolean {
    return true;
  }

  resolveNamespacePrefix(prefix: string): string | null {
    let namespace = this.getNamespaceForPrefix(prefix);

    if (namespace !== null) {
      return namespace.getURI();
    }

    return null;
  }

  getData(): any {
    if (this.data === null) {
      let text = this.getTextTrim();

      if ((text !== null) && (text.length > 0)) {
        if (this.datatype instanceof DatabindableDatatype) {
          this.data = this.datatype.createJavaObject(text, this);
        } else {
          this.data = this.datatype.createValue(text, this);
        }
      }
    }

    return this.data;
  }

  setData(data: any): void {
    let s = this.datatype.convertToLexicalValue(data, this);
    this.validate(s);
    this.data = data;
    this.setText(s);
  }

  addText(text: string): Element {
    this.validate(text);

    return super.addText(text);
  }

  setText(text: string): void {
    this.validate(text);
    super.setText(text);
  }

  protected childAdded(node: Node): void {
    this.data = null;
    super.childAdded(node);
  }

  protected childRemoved(node: Node): void {
    this.data = null;
    super.childRemoved(node);
  }

  protected validate(text: string): void {
    try {
      this.datatype.checkValid(text, this);
    } catch (e) {
      if (e instanceof DatatypeException) {
        throw new Error(e.getMessage());
      }
    }
  }
}