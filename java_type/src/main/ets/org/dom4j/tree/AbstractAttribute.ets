export default  abstract class AbstractAttribute extends AbstractNode implements Attribute {
  constructor() {
    super();
  }

  public getNodeType(): number {
    return 2;
  }

  public setNamespace(namespace: Namespace): void {
    const msg = "This Attribute is read only and cannot be changed";
    throw new Error(msg);
  }

  public getText(): string {
    return this.getValue();
  }

  public setText(text: string): void {
    this.setValue(text);
  }

  public setValue(value: string): void {
    const msg = "This Attribute is read only and cannot be changed";
    throw new Error(msg);
  }

  public getData(): string {
    return this.getValue();
  }

  public setData(data: any): void {
    this.setValue(data == null ? null : data.toString());
  }

  public toString(): string {
    return super.toString() + ` [Attribute: name ${this.getQualifiedName()} value "${this.getValue()}"]`;
  }

  public asXML(): string {
    return `${this.getQualifiedName()}="${this.getValue()}"`;
  }

  public write(writer: Writer): void {
    writer.write(this.getQualifiedName());
    writer.write('="');
    writer.write(this.getValue());
    writer.write('"');
  }

  public accept(visitor: Visitor): void {
    visitor.visit(this);
  }

  public getNamespace(): Namespace {
    return this.getQName().getNamespace();
  }

  public getName(): string {
    return this.getQName().getName();
  }

  public getNamespacePrefix(): string {
    return this.getQName().getNamespacePrefix();
  }

  public getNamespaceURI(): string {
    return this.getQName().getNamespaceURI();
  }

  public getQualifiedName(): string {
    return this.getQName().getQualifiedName();
  }

  public getPath(context: Element): string {
    const result = [];
    const parent = this.getParent();
    if (parent != null && parent !== context) {
      result.push(parent.getPath(context));
      result.push('/');
    }

    result.push('@');
    const uri = this.getNamespaceURI();
    const prefix = this.getNamespacePrefix();
    if (uri && uri.length !== 0 && prefix && prefix.length !== 0) {
      result.push(this.getQualifiedName());
    } else {
      result.push(this.getName());
    }

    return result.join('');
  }

  public getUniquePath(context: Element): string {
    const result = [];
    const parent = this.getParent();
    if (parent != null && parent !== context) {
      result.push(parent.getUniquePath(context));
      result.push('/');
    }

    result.push('@');
    const uri = this.getNamespaceURI();
    const prefix = this.getNamespacePrefix();
    if (uri && uri.length !== 0 && prefix && prefix.length !== 0) {
      result.push(this.getQualifiedName());
    } else {
      result.push(this.getName());
    }

    return result.join('');
  }

  protected createXPathResult(parent: Element): Node {
    return new DefaultAttribute(parent, this.getQName(), this.getValue());
  }
}