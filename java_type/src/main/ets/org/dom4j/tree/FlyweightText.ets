export default  class FlyweightText extends AbstractText implements Text {
  protected text: string;

  constructor(text: string) {
    super();
    this.text = text;
  }

  getText(): string {
    return this.text;
  }

  protected createXPathResult(parent: Element): Node {
    return new DefaultText(parent, this.getText());
  }
}