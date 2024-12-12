import Namespace from "./Namespace";
import Node from "./Node";
import QName from "./QName";

export default  interface Attribute extends Node {
  getQName(): QName;

  getNamespace(): Namespace;

  setNamespace(var1: Namespace): void;

  getNamespacePrefix(): string;

  getNamespaceURI(): string;

  getQualifiedName(): string;

  getValue(): string;

  setValue(var1: string): void;

  getData(): Object;

  setData(var1: Object): void;
}