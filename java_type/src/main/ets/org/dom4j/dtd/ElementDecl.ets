export default  class ElementDecl implements Decl {
  private name: string;
  private model: string;

  constructor();
  constructor(name: string, model: string);
  constructor(arg1?: string, model?: string) {
    if (arg1) {
      this.name = arg1;
      this.model = model!;
    }
  }

  getName(): string {
    return this.name;
  }

  setName(name: string): void {
    this.name = name;
  }

  getModel(): string {
    return this.model;
  }

  setModel(model: string): void {
    this.model = model;
  }

  toString(): string {
    return `<!ELEMENT ${this.name} ${this.model}>`;
  }
}
