export default  interface ElementPath {
  size(): number;

  getElement(var1: number): Element;

  getPath(): string;

  getCurrent(): Element;

  addHandler(var1: string, var2: ElementHandler): void;

  removeHandler(var1: string): void;
}