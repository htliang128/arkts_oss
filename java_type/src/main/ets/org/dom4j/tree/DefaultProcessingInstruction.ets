export default  class DefaultProcessingInstruction extends FlyweightProcessingInstruction {
  private parent: Element | null;

  constructor(target: string, values: Map<string, string>) {
    super(target, values);
    this.parent = null;
  }

  constructor(target: string, values: string) {
    super(target, values);
    this.parent = null;
  }

  constructor(parent: Element, target: string, values: string) {
    super(target, values);
    this.parent = parent;
  }

  public setTarget(target: string): void {
    this.target = target;
  }

  public setText(text: string): void {
    this.text = text;
    this.values = this.parseValues(text);
  }

  public setValues(values: Map<string, string>): void {
    this.values = values;
    this.text = this.toString(values);
  }

  public setValue(name: string, value: string): void {
    this.values.set(name, value);
  }

  public getParent(): Element | null {
    return this.parent;
  }

  public setParent(parent: Element): void {
    this.parent = parent;
  }

  public supportsParent(): boolean {
    return true;
  }

  public isReadOnly(): boolean {
    return false;
  }
}