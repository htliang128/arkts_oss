export default class NamespaceCache {
  protected static cache: Map<string, Map<string, WeakReference<Namespace>>> = new Map();
  protected static noPrefixCache: Map<string, WeakReference<Namespace>> = new Map();

  public get(prefix: string, uri: string): Namespace | null {
    let uriCache = this.getURICache(uri);
    let ref = uriCache.get(prefix);
    let answer = null;
    if (ref !== undefined) {
      answer = ref.deref();
    }

    if (answer === null) {
      ref = uriCache.get(prefix);
      if (ref !== undefined) {
        answer = ref.deref();
      }

      if (answer === null) {
        answer = this.createNamespace(prefix, uri);
        uriCache.set(prefix, new WeakReference(answer));
      }
    }

    return answer;
  }

  public getNoPrefix(uri: string): Namespace | null {
    let ref = NamespaceCache.noPrefixCache.get(uri);
    let answer = null;
    if (ref !== undefined) {
      answer = ref.deref();
    }

    if (answer === null) {
      ref = NamespaceCache.noPrefixCache.get(uri);
      if (ref !== undefined) {
        answer = ref.deref();
      }

      if (answer === null) {
        answer = this.createNamespace("", uri);
        NamespaceCache.noPrefixCache.set(uri, new WeakReference(answer));
      }
    }

    return answer;
  }

  protected getURICache(uri: string): Map<string, WeakReference<Namespace>> {
    let answer = NamespaceCache.cache.get(uri);
    if (answer === undefined) {
      answer = new Map();
      NamespaceCache.cache.set(uri, answer);
    }

    return answer;
  }

  protected createNamespace(prefix: string, uri: string): Namespace {
    return { prefix: prefix, uri: uri };
  }
}
