export default  class DefaultComment extends FlyweightComment {
  private parent: Element | null;

  public constructor(text: string) {
    super(text);
  }

  public constructor(parent: Element, text: string) {
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