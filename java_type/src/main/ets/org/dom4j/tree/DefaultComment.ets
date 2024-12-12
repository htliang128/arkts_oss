export default  class DefaultComment extends FlyweightComment {
  private parent: Element | null;

  constructor(text: string);
  constructor(parent: Element, text: string);
  constructor(arg1: Element | string, arg2?: string) {
    if (typeof arg1 === 'string') {
      super(arg1);
      this.parent = null;
    } else {
      super(arg2!);
      this.parent = arg1;
    }
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