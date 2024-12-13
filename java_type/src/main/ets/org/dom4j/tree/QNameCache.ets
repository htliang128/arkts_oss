import DocumentFactory from "../DocumentFactory";
import Namespace from "../Namespace";
import QName from "../QName";

export default class QNameCache {
  protected noNamespaceCache: Map<string, QName> = new Map<string, QName>();
  protected namespaceCache: Map<Namespace, Map<string, QName>> = new Map<Namespace, Map<string, QName>>();
  private documentFactory: DocumentFactory;

  constructor();

  constructor(documentFactory: DocumentFactory);

  constructor(documentFactory?: DocumentFactory) {
    this.documentFactory = documentFactory || new DocumentFactory();
  }

  public getQNames(): QName[] {
    let answer: QName[] = [];
    this.noNamespaceCache.forEach((v, k) => answer.push(v));

    for (const map of this.namespaceCache.values()) {
      for (const qName of map.values()) {
        answer.push(qName);
      }
    }

    return answer;
  }

  public get(name: string): QName;

  public get(name: string, namespace: Namespace): QName;

  public get(localName: string, namespace: Namespace, qName: string);

  public get(qualifiedName: string, uri: string): QName;

  public get(arg1: string, arg2?: string | Namespace, qName?: string): QName {
    if (!arg2) {
      let answer: QName | undefined = this.noNamespaceCache.get(arg1 || '');
      if (answer === undefined) {
        answer = this.createQName(arg1 || '');
        answer.setDocumentFactory(this.documentFactory);
        this.noNamespaceCache.set(arg1 || '', answer);
      }
      return answer;
    }

    if (typeof arg2 === 'string') {
      const index = arg1.indexOf(':');
      if (index < 0) {
        return this.get(arg1, Namespace.get(arg2));
      }
      if (index === 0) {
        throw new Error("Qualified name cannot start with ':'.");
      }

      const name = arg1.substring(index + 1);
      const prefix = arg1.substring(0, index);
      return this.get(name, Namespace.get(prefix, arg2));
    }

    if (!qName) {
      const cache = this.getNamespaceCache(arg2);
      let answer: QName | undefined = cache.get(arg1 || '');

      if (answer === undefined) {
        answer = this.createQName(arg1 || '', arg2);
        answer.setDocumentFactory(this.documentFactory);
        cache.set(arg1 || '', answer);
      }

      return answer;
    }

    const cache = this.getNamespaceCache(arg2);
    let answer: QName | undefined = cache.get(arg1 || '');

    if (answer === undefined) {
      answer = this.createQName(arg1 || '', arg2, qName);
      answer.setDocumentFactory(this.documentFactory);
      cache.set(arg1 || '', answer);
    }

    return answer;
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