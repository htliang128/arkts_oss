export default  class DefaultCDATA extends FlyweightCDATA {
  private parent: Element | null;

  constructor(text: string) {
    super(text);
    this.parent = null;
  }

  constructor(parent: Element, text: string) {
    super(text);
    this.parent = parent;
  }

  public setText(text: string): void {
    this.text = text;
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