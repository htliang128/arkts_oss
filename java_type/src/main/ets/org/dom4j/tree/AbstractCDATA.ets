export default  abstract class AbstractCDATA extends AbstractCharacterData implements CDATA {
  constructor() {
    super();
  }

  public getNodeType(): number {
    return 4;
  }

  public toString(): string {
    return super.toString() + ` [CDATA: "${this.getText()}"]`;
  }

  public asXML(): string {
    const writer = new StringWriter();

    try {
      this.write(writer);
    } catch (e) {
      // Handle exception
    }

    return writer.toString();
  }

  public write(writer: Writer): void {
    writer.write('<![CDATA[');
    if (this.getText() != null) {
      writer.write(this.getText());
    }
    writer.write(']]>');
  }

  public accept(visitor: Visitor): void {
    visitor.visit(this);
  }
}