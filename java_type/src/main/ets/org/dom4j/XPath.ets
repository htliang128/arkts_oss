import NodeFilter from "./NodeFilter";
import { Node } from "@kit.ArkGraphics3D";

export default  interface XPath extends NodeFilter {
  getText(): string;

  matches(var1: Node): boolean;

  evaluate(var1: Object): Object;

  selectObject(var1: Object): Object;

  selectNodes(var1: Object): Node[];

  selectNodes(var1: Object, var2: XPath): Node[];

  selectNodes(var1: Object, var2: XPath, var3: boolean): Node[];

  selectSingleNode(var1: Object): Node;

  valueOf(var1: Object): string;

  numberValueOf(var1: Object): number;

  booleanValueOf(var1: Object): boolean;

  sort(var1: Node[]): void;

  sort(var1: Node[], var2: boolean): void;

  getFunctionContext(): FunctionContext;

  setFunctionContext(var1: FunctionContext): void;

  getNamespaceContext(): NamespaceContext;

  setNamespaceContext(var1: NamespaceContext): void;

  setNamespaceURIs(var1: Map<string, string>): void;

  getVariableContext(): VariableContext;

  setVariableContext(var1: VariableContext): void;
}