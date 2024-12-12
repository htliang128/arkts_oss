export default  class QNameCache {
  protected noNamespaceCache: Map<string, QName> = new WeakHashMap();
  protected namespaceCache: Map<Namespace, Map<string, QName>> = new WeakHashMap();
  private documentFactory: DocumentFactory;

  constructor();
  constructor(documentFactory: DocumentFactory);
  constructor(documentFactory?: DocumentFactory) {
    this.documentFactory = documentFactory || new DocumentFactory();
  }

  public getQNames(): Array<QName> {
    let answer: Array<QName> = [];
    answer = [...this.noNamespaceCache.values()];

    for (const map of this.namespaceCache.values()) {
      answer = [...answer, ...map.values()];
    }

    return answer;
  }

  public get(name: string): QName {
    let answer: QName | undefined = this.noNamespaceCache.get(name || '');

    if (answer === undefined) {
      answer = this.createQName(name || '');
      answer.setDocumentFactory(this.documentFactory);
      this.noNamespaceCache.set(name || '', answer);
    }

    return answer;
  }

  public getWithNamespace(name: string, namespace: Namespace): QName {
    const cache = this.getNamespaceCache(namespace);
    let answer: QName | undefined = cache.get(name || '');

    if (answer === undefined) {
      answer = this.createQName(name || '', namespace);
      answer.setDocumentFactory(this.documentFactory);
      cache.set(name || '', answer);
    }

    return answer;
  }

  public getWithQualifiedName(localName: string, namespace: Namespace, qName: string): QName {
    const cache = this.getNamespaceCache(namespace);
    let answer: QName | undefined = cache.get(localName || '');

    if (answer === undefined) {
      answer = this.createQName(localName || '', namespace, qName);
      answer.setDocumentFactory(this.documentFactory);
      cache.set(localName || '', answer);
    }

    return answer;
  }

  public getWithURI(qualifiedName: string, uri: string): QName {
    const index = qualifiedName.indexOf(':');
    if (index < 0) {
      return this.get(qualifiedName, Namespace.get(uri));
    } else if (index === 0) {
      throw new Error("Qualified name cannot start with ':'.");
    } else {
      const name = qualifiedName.substring(index + 1);
      const prefix = qualifiedName.substring(0, index);
      return this.get(name, Namespace.get(prefix, uri));
    }
  }

  public intern(qname: QName): QName {
    return this.getWithQualifiedName(qname.getName(), qname.getNamespace(), qname.getQualifiedName());
  }

  protected getNamespaceCache(namespace: Namespace): Map<string, QName> {
    if (namespace === Namespace.NO_NAMESPACE) {
      return this.noNamespaceCache;
    } else {
      let answer: Map<string, QName> | undefined = this.namespaceCache.get(namespace);

      if (answer === undefined) {
        answer = this.createMap();
        this.namespaceCache.set(namespace, answer);
      }

      return answer;
    }
  }

  protected createMap(): Map<string, QName> {
    return new Map();
  }

  protected createQName(name: string): QName {
    return new QName(name);
  }

  protected createQName(name: string, namespace: Namespace): QName {
    return new QName(name, namespace);
  }

  protected createQName(name: string, namespace: Namespace, qualifiedName: string): QName {
    return new QName(name, namespace, qualifiedName);
  }
}