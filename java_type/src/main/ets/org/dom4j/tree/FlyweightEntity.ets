export default  class FlyweightEntity extends AbstractEntity {
  protected name: string;
  protected text: string | null;

  protected constructor() {
    super();
  }

  public constructor(name: string);
  public constructor(name: string, text: string);
  public constructor(name?: string, text?: string) {
    super();
    if (name) {
      this.name = name;
    }
    if (text) {
      this.text = text;
    }
  }

  public getName(): string {
    return this.name;
  }

  public getText(): string | null {
    return this.text;
  }

  public setText(text: string): void {
    if (this.text !== null) {
      this.text = text;
    } else {
      throw new Error("This Entity is read-only. It cannot be modified");
    }
  }

  protected createXPathResult(parent: Element): Node {
    return new DefaultEntity(parent, this.getName(), this.getText());
  }
}