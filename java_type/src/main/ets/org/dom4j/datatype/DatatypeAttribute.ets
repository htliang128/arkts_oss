export default class DatatypeAttribute extends AbstractAttribute {
  private parent: Element | null;

  private qname: QName;

  private datatype: XSDatatype;

  private data: any;

  private text: string;

  constructor(qname: QName, datatype: XSDatatype, text?: string) {
    super();
    this.qname = qname;
    this.datatype = datatype;
    this.text = text || '';
    this.data = this.convertToValue(this.text);
  }

  toString(): string {
    return `${this.constructor.name}${this.hashCode()} [Attribute: name ${this.getQualifiedName()} value "${this.getValue()}" data: ${this.getData()}]`;
  }

  getXSDatatype(): XSDatatype {
    return this.datatype;
  }

  getNamespacePrefix(uri: string): string | null {
    let parentElement = this.getParent();

    if (parentElement !== null) {
      let namespace = parentElement.getNamespaceForURI(uri);

      if (namespace !== null) {
        return namespace.getPrefix();
      }
    }

    return null;
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
    if (prefix === this.getNamespacePrefix()) {
      return this.getNamespaceURI();
    } else {
      let parentElement = this.getParent();

      if (parentElement !== null) {
        let namespace = parentElement.getNamespaceForPrefix(prefix);

        if (namespace !== null) {
          return namespace.getURI();
        }
      }
    }

    return null;
  }

  getQName(): QName {
    return this.qname;
  }

  getValue(): string {
    return this.text;
  }

  setValue(value: string): void {
    this.validate(value);
    this.text = value;
    this.data = this.convertToValue(value);
  }

  getData(): any {
    return this.data;
  }

  setData(data: any): void {
    let s = this.datatype.convertToLexicalValue(data, this);
    this.validate(s);
    this.text = s;
    this.data = data;
  }

  getParent(): Element | null {
    return this.parent;
  }

  setParent(parent: Element): void {
    this.parent = parent;
  }

  supportsParent(): boolean {
    return true;
  }

  isReadOnly(): boolean {
    return false;
  }

  protected validate(txt: string): void {
    try {
      this.datatype.checkValid(txt, this);
    } catch (e) {
      if (e instanceof DatatypeException) {
        throw new Error(e.getMessage());
      }
    }
  }

  protected convertToValue(txt: string): any {
    if (this.datatype instanceof DatabindableDatatype) {
      return this.datatype.createJavaObject(txt, this);
    } else {
      return this.datatype.createValue(txt, this);
    }
  }
}