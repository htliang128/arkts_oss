export default  class DefaultNamespace extends Namespace {
  private parent: Element | null;

  constructor(prefix: string, uri: string);
  constructor(parent: Element, prefix: string, uri: string);
  constructor(...args: any[]) {
    if (args.length === 2) {
      this.parent = null;
      super(args[0], args[1]);
    } else {
      this.parent = args[0];
      super(args[1], args[2]);
    }
  }

  protected createHashCode(): number {
    let hashCode = super.createHashCode();
    if (this.parent) {
      hashCode ^= this.parent.hashCode();
    }
    return hashCode;
  }

  public equals(object: any): boolean {
    if (object instanceof DefaultNamespace) {
      const that = object as DefaultNamespace;
      if (that.parent === this.parent) {
        return super.equals(object);
      }
    }
    return false;
  }

  public hashCode(): number {
    return super.hashCode();
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