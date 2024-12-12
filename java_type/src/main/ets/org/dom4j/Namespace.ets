export default   class Namespace extends AbstractNode {
  protected static readonly CACHE = new NamespaceCache();
  public static readonly XML_NAMESPACE = Namespace.CACHE.get("xml", "http://www.w3.org/XML/1998/namespace");
  public static readonly NO_NAMESPACE = Namespace.CACHE.get("", "");

  private prefix: string;
  private uri: string;
  private hashCode: number = 0;

  constructor(prefix: string, uri: string) {
    super();
    this.prefix = prefix ?? "";
    this.uri = uri ?? "";
    if (this.prefix.length > 0) {
      QName.validateNCName(this.prefix);
    }
  }

  public static get(prefix: string, uri: string): Namespace {
    return Namespace.CACHE.get(prefix, uri);
  }

  public static get(uri: string): Namespace {
    return Namespace.CACHE.get(uri);
  }

  public getNodeType(): number {
    return 13;
  }

  public hashCode(): number {
    if (this.hashCode === 0) {
      this.hashCode = this.createHashCode();
    }

    return this.hashCode;
  }

  protected createHashCode(): number {
    let result = this.uri.hashCode() ^ this.prefix.hashCode();
    if (result === 0) {
      result = 47806;
    }

    return result;
  }

  public equals(object: any): boolean {
    if (this === object) {
      return true;
    } else {
      if (object instanceof Namespace) {
        let that = object as Namespace;
        if (this.hashCode() === that.hashCode()) {
          return this.uri === that.getURI() && this.prefix === that.getPrefix();
        }
      }

      return false;
    }
  }

  public getText(): string {
    return this.uri;
  }

  public getStringValue(): string {
    return this.uri;
  }

  public getPrefix(): string {
    return this.prefix;
  }

  public getURI(): string {
    return this.uri;
  }

  public getXPathNameStep(): string {
    return this.prefix && this.prefix !== "" ? "namespace::" + this.prefix : "namespace::*[name()='']";
  }

  public getPath(context: Element): string {
    let path = new Array<string>();
    let parent = this.getParent();
    if (parent && parent !== context) {
      path.push(parent.getPath(context));
      path.push('/');
    }

    path.push(this.getXPathNameStep());
    return path.join('');
  }

  public getUniquePath(context: Element): string {
    let path = new Array<string>();
    let parent = this.getParent();
    if (parent && parent !== context) {
      path.push(parent.getUniquePath(context));
      path.push('/');
    }

    path.push(this.getXPathNameStep());
    return path.join('');
  }

  public toString(): string {
    return super.toString() + " [Namespace: prefix " + this.getPrefix() + " mapped to URI \"" + this.getURI() + "\"]";
  }

  public asXML(): string {
    let asxml = new Array<string>();
    let pref = this.getPrefix();
    if (pref && pref.length > 0) {
      asxml.push("xmlns:");
      asxml.push(pref);
      asxml.push("=\"");
    } else {
      asxml.push("xmlns=\"");
    }

    asxml.push(this.getURI());
    asxml.push("\"");
    return asxml.join('');
  }

  public accept(visitor: Visitor): void {
    visitor.visit(this);
  }

  protected createXPathResult(parent: Element): DefaultNamespace {
    return new DefaultNamespace(parent, this.getPrefix(), this.getURI());
  }
}