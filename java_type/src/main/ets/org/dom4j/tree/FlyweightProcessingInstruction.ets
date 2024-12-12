export default  class FlyweightProcessingInstruction extends AbstractProcessingInstruction {
  protected target: string;
  protected text: string;
  protected values: Map<string, string>;

  constructor();
  constructor(target: string, values: Map<string, string>);
  constructor(target: string, text: string);
  constructor(target?: string, valuesOrText?: Map<string, string> | string) {
    super();
    if (typeof valuesOrText === "string") {
      this.target = target;
      this.text = valuesOrText;
      this.values = this.parseValues(valuesOrText);
    } else if (valuesOrText instanceof Map) {
      this.target = target;
      this.text = this.toString(valuesOrText);
      this.values = valuesOrText;
    }
  }

  public getTarget(): string {
    return this.target;
  }

  public setTarget(target: string): never {
    throw new Error("This PI is read-only and cannot be modified");
  }

  public getText(): string {
    return this.text;
  }

  public getValue(name: string): string {
    const answer = this.values.get(name);
    return answer === undefined ? "" : answer;
  }

  public getValues(): Map<string, string> {
    return new Map(this.values);
  }

  protected createXPathResult(parent: Element): DefaultProcessingInstruction {
    return new DefaultProcessingInstruction(parent, this.getTarget(), this.getText());
  }

  // You'll need to provide TypeScript implementations of parseValues and toString
  protected abstract parseValues(text: string): Map<string, string>;
  protected abstract toString(values: Map<string, string>): string;
}