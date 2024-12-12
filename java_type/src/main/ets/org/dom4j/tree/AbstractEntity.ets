export default  abstract class AbstractEntity extends AbstractNode implements Entity {
  constructor() {
    super();
  }

  public getNodeType(): number {
    return 5;
  }

  public getPath(context: Element): string {
    const parent = this.getParent();
    return parent && parent !== context ? parent.getPath(context) + "/text()" : "text()";
  }

  public getUniquePath(context: Element): string {
    const parent = this.getParent();
    return parent && parent !== context ? parent.getUniquePath(context) + "/text()" : "text()";
  }

  public toString(): string {
    return super.toString() + ` [Entity: &${this.getName()};]`;
  }

  public getStringValue(): string {
    return `&${this.getName()};`;
  }

  public asXML(): string {
    return `&${this.getName()};`;
  }

  public write(writer: Writer): void {
    writer.write("&");
    writer.write(this.getName());
    writer.write(";");
  }

  public accept(visitor: Visitor): void {
    visitor.visit(this);
  }
}