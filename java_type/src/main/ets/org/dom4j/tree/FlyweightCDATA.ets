export default  class FlyweightCDATA extends AbstractCDATA implements CDATA {
  protected text: string;

  constructor(text: string) {
    super();
    this.text = text;
  }

  public getText(): string {
    return this.text;
  }

  protected createXPathResult(parent: Element): Node {
    return new DefaultCDATA(parent, this.getText());
  }
}