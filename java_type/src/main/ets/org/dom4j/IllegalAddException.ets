import IllegalArgumentException from "../../java/lang/IllegalArgumentException";
import Branch from "./Branch";
import Node from "./Node";

export default class IllegalAddException extends IllegalArgumentException {
  constructor(reason: string);

  constructor(parent: Branch, node: Node, reason: string);

  constructor(parentOrReason: Branch | string, node?: Node, reason?: string) {
    if (typeof parentOrReason === 'string') {
      super(parentOrReason);
    } else {
      super(`The node "${node?.toString()}" could not be added to the branch "${parentOrReason.getName()}" because: ${reason}`);
    }
  }
}