export default  class DefaultAttribute extends FlyweightAttribute {
  private parent: Element | null;

  constructor(qname: QName);
  constructor(qname: QName, value: string);
  constructor(parent: Element, qname: QName, value: string);
  constructor(name: string, value: string);
  constructor(name: string, value: string, namespace: Namespace);
  constructor(parent: Element, name: string, value: string, namespace: Namespace);
  constructor(...args: any[]) {
    if (args.length === 3) {
      this.parent = args[0];
      super(args[1], args[2]);
    } else if (args.length === 2) {
      super(args[0], args[1]);
      this.parent = null;
    } else {
      this.parent = null;
      super(args[0], args[1], args[2]);
    }
  }

  public setValue(value: string): void {
    this.value = value;
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