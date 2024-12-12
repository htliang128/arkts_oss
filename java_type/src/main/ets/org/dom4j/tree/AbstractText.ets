export default  abstract class AbstractText extends AbstractCharacterData implements Text {
  constructor() {
    super();
  }

  public getNodeType(): number {
    return 3;
  }

  public toString(): string {
    return super.toString() + ` [Text: "${this.getText()}"]`;
  }

  public asXML(): string {
    return this.getText();
  }

  public write(writer: Writer): void {
    writer.write(this.getText());
  }

  public accept(visitor: Visitor): void {
    visitor.visit(this);
  }
}