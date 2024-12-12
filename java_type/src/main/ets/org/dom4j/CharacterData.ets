import Node from "./Node";

export default  interface CharacterData extends Node {
  appendText(text: string): void;
}