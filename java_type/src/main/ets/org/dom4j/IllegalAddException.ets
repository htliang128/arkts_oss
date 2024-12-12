export default  class IllegalAddException extends Error {
  constructor(reason: string);
  constructor(parent: Element, node: Node, reason: string);
  constructor(parent: Branch, node: Node, reason: string);
  constructor(parentOrReason: Element | Branch | string, node?: Node, reason?: string) {
    if (typeof parentOrReason === 'string') {
      super(parentOrReason);
    } else if (parentOrReason instanceof Element) {
      super(`The node "${node.toString()}" could not be added to the element "${parentOrReason.getQualifiedName()}" because: ${reason}`);
    } else {
      super(`The node "${node.toString()}" could not be added to the branch "${parentOrReason.getName()}" because: ${reason}`);
    }
  }
}