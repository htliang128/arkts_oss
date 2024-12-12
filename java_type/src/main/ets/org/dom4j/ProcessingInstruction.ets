export default interface ProcessingInstruction extends Node {
  getTarget(): string;
  setTarget(var1: string): void;
  getText(): string;
  getValue(var1: string): string;
  getValues(): Map<string, string>;
  setValue(var1: string, var2: string): void;
  setValues(var1: Map<string, string>): void;
  removeValue(var1: string): boolean;
}