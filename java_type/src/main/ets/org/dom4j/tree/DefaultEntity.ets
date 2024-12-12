export default  class DefaultEntity extends FlyweightEntity {
  private parent: Element | null = null;

  constructor(name: string);
  constructor(name: string, text: string);
  constructor(parent: Element, name: string, text: string);
  constructor(arg1: any, arg2?: string, arg3?: string) {
    if (typeof arg1 === 'string') {
      super(arg1, arg2);
    } else {
      super(arg2!, arg3);
      this.parent = arg1;
    }
  }

  public setName(name: string): void {
    this.name = name;
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