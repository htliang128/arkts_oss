export default  abstract class AbstractProcessingInstruction extends AbstractNode implements ProcessingInstruction {
  constructor() {
    super();
  }

  public getNodeType(): number {
    return 7;
  }

  public getPath(context: Element): string {
    const parent = this.getParent();
    return parent != null && parent !== context ? parent.getPath(context) + "/processing-instruction()" : "processing-instruction()";
  }

  public getUniquePath(context: Element): string {
    const parent = this.getParent();
    return parent != null && parent !== context ? parent.getUniquePath(context) + "/processing-instruction()" : "processing-instruction()";
  }

  public toString(): string {
    return super.toString() + ` [ProcessingInstruction: &${this.getName()};]`;
  }

  public asXML(): string {
    return `<?${this.getName()} ${this.getText()}?>`;
  }

  public write(writer: Writer): void {
    writer.write("<?");
    writer.write(this.getName());
    writer.write(" ");
    writer.write(this.getText());
    writer.write("?>");
  }

  public accept(visitor: Visitor): void {
    visitor.visit(this);
  }

  public setValue(name: string, value: string): void {
    throw new Error("This PI is read-only and cannot be modified");
  }

  public setValues(data: Map<string, string>): void {
    throw new Error("This PI is read-only and cannot be modified");
  }

  public getName(): string {
    return this.getTarget();
  }

  public setName(name: string): void {
    this.setTarget(name);
  }

  public removeValue(name: string): boolean {
    return false;
  }

  protected toString(values: Map<string, string>): string {
    const buffer: string[] = [];
    for (const [name, value] of values) {
      buffer.push(`${name}="${value}" `);
    }
    return buffer.join('').trim();
  }

  protected parseValues(text: string): Map<string, string> {
    const data: Map<string, string> = new Map();
    const tokenizer = new StringTokenizer(text, " ='\"", true);

    while (tokenizer.hasMoreTokens()) {
      const name = this.getName(tokenizer);
      if (tokenizer.hasMoreTokens()) {
        const value = this.getValue(tokenizer);
        data.set(name, value);
      }
    }

    return data;
  }

  private getName(tokenizer: StringTokenizer): string {
    let token = tokenizer.nextToken();
    const name: string[] = [token];

    while (tokenizer.hasMoreTokens()) {
      token = tokenizer.nextToken();
      if (token === "=") {
        break;
      }
      name.push(token);
    }

    return name.join('').trim();
  }

  private getValue(tokenizer: StringTokenizer): string {
    let token = tokenizer.nextToken();
    const value: string[] = [];

    let quote: string;
    while (tokenizer.hasMoreTokens() && token !== "'" && token !== "\"") {
      token = tokenizer.nextToken();
    }

    quote = token;

    while (tokenizer.hasMoreTokens()) {
      token = tokenizer.nextToken();
      if (quote === token) {
        break;
      }
      value.push(token);
    }

    return value.join('');
  }
}