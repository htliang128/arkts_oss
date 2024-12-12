export default  class NamespaceStack {
  private documentFactory: DocumentFactory;
  private namespaceStack: Namespace[] = [];
  private namespaceCacheList: Map<string, QName>[] = [];
  private currentNamespaceCache?: Map<string, QName>;
  private rootNamespaceCache: Map<string, QName> = new Map();
  private defaultNamespace?: Namespace;

  constructor(documentFactory?: DocumentFactory) {
    this.documentFactory = documentFactory || DocumentFactory.getInstance();
  }

  public push(namespace: Namespace): void {
    this.namespaceStack.push(namespace);
    this.namespaceCacheList.push(null);
    this.currentNamespaceCache = null;
    let prefix = namespace.getPrefix();
    if (!prefix) {
      this.defaultNamespace = namespace;
    }
  }

  public pop(): Namespace {
    return this.remove(this.namespaceStack.length - 1);
  }

  public size(): number {
    return this.namespaceStack.length;
  }

  public clear(): void {
    this.namespaceStack = [];
    this.namespaceCacheList = [];
    this.rootNamespaceCache.clear();
    this.currentNamespaceCache = null;
  }

  public getNamespace(index: number): Namespace {
    return this.namespaceStack[index];
  }

  public getNamespaceForPrefix(prefix: string): Namespace {
    if (!prefix) {
      prefix = "";
    }

    for(let i = this.namespaceStack.length - 1; i >= 0; i--) {
      let namespace = this.namespaceStack[i];
      if (prefix === namespace.getPrefix()) {
        return namespace;
      }
    }

    return null;
  }

  public getURI(prefix: string): string {
    let namespace = this.getNamespaceForPrefix(prefix);
    return namespace ? namespace.getURI() : null;
  }

  public contains(namespace: Namespace): boolean {
    let prefix = namespace.getPrefix();
    let current;
    if (prefix) {
      current = this.getNamespaceForPrefix(prefix);
    } else {
      current = this.getDefaultNamespace();
    }

    if (current == null) {
      return false;
    } else {
      return current === namespace ? true : namespace.getURI() === current.getURI();
    }
  }

  public getQName(namespaceURI: string, localName: string, qualifiedName: string): QName {
    if (!localName) {
      localName = qualifiedName;
    } else if (!qualifiedName) {
      qualifiedName = localName;
    }

    if (!namespaceURI) {
      namespaceURI = "";
    }

    let prefix = "";
    let index = qualifiedName.indexOf(":");
    if (index > 0) {
      prefix = qualifiedName.substring(0, index);
      if (localName.trim().length === 0) {
        localName = qualifiedName.substring(index + 1);
      }
    } else if (localName.trim().length === 0) {
      localName = qualifiedName;
    }

    let namespace = this.createNamespace(prefix, namespaceURI);
    return this.pushQName(localName, qualifiedName, namespace, prefix);
  }

  // ... rest of the methods
}
