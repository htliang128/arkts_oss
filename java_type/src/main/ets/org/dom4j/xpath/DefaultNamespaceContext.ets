export default  class DefaultNamespaceContext {
  private readonly element: Element | null;

  constructor(element: Element) {
    this.element = element;
  }

  public static create(node: Element | Document | Node): DefaultNamespaceContext | null {
    let element: Element | null = null;
    if (node instanceof Element) {
      element = node;
    } else if (node instanceof Document) {
      element = node.getRootElement();
    } else if (node instanceof Node) {
      element = node.getParent();
    }

    return element !== null ? new DefaultNamespaceContext(element) : null;
  }

  public translateNamespacePrefixToUri(prefix: string): string | null {
    if (prefix !== null && prefix.length > 0) {
      const ns: Namespace | null = this.element.getNamespaceForPrefix(prefix);
      if (ns !== null) {
        return ns.getURI();
      }
    }

    return null;
  }
}