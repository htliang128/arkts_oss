import NodeFilter from "./NodeFilter";
import NamespaceContext from "../jaxen/NamespaceContext";
import VariableContext from "../jaxen/VariableContext";
import FunctionContext from "../jaxen/FunctionContext";
import Node from "./Node";

export default interface XPath extends NodeFilter {
  getText(): string;

  matches(var1: Node): boolean;

  evaluate(var1: ESObject): ESObject;

  selectESObject(var1: ESObject): ESObject;

  selectNodes(var1: ESObject): Node[];

  selectNodes(var1: ESObject, var2: XPath): Node[];

  selectNodes(var1: ESObject, var2: XPath, var3: boolean): Node[];

  selectSingleNode(var1: ESObject): Node;

  valueOf(var1: ESObject): string;

  numberValueOf(var1: ESObject): number;

  booleanValueOf(var1: ESObject): boolean;

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