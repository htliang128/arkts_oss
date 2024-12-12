export default  class XMLTableColumnDefinition implements Serializable {
  public static readonly OBJECT_TYPE = 0;
  public static readonly STRING_TYPE = 1;
  public static readonly NUMBER_TYPE = 2;
  public static readonly NODE_TYPE = 3;

  private type: number;
  private name: string;
  private xpath: XPath;
  private columnNameXPath: XPath;

  constructor();
  constructor(name: string, expression: string, type: number);
  constructor(name: string, xpath: XPath, type: number);
  constructor(columnXPath: XPath, xpath: XPath, type: number);
  constructor(nameOrXPath?: string | XPath, expressionOrXPath?: string | XPath, type?: number) {
    if (typeof nameOrXPath === 'string' && typeof expressionOrXPath === 'string' && typeof type === 'number') {
      this.name = nameOrXPath;
      this.type = type;
      this.xpath = this.createXPath(expressionOrXPath);
    } else if (typeof nameOrXPath === 'string' && expressionOrXPath instanceof XPath && typeof type === 'number') {
      this.name = nameOrXPath;
      this.xpath = expressionOrXPath;
      this.type = type;
    } else if (nameOrXPath instanceof XPath && expressionOrXPath instanceof XPath && typeof type === 'number') {
      this.columnNameXPath = nameOrXPath;
      this.xpath = expressionOrXPath;
      this.type = type;
    }
  }

  public static parseType(typeName: string): number {
    if (typeName) {
      if (typeName === 'string') return 1;
      if (typeName === 'number') return 2;
      if (typeName === 'node') return 3;
    }
    return 0;
  }

  public getColumnClass(): Function {
    switch (this.type) {
      case 1: return String;
      case 2: return Number;
      case 3: return Node;
      default: return Object;
    }
  }

  public getValue(row: any): any {
    switch (this.type) {
      case 1: return this.xpath.valueOf(row);
      case 2: return this.xpath.numberValueOf(row);
      case 3: return this.xpath.selectSingleNode(row);
      default: return this.xpath.evaluate(row);
    }
  }

  public getType(): number {
    return this.type;
  }

  public setType(type: number): void {
    this.type = type;
  }

  public getName(): string {
    return this.name;
  }

  public setName(name: string): void {
    this.name = name;
  }

  public getXPath(): XPath {
    return this.xpath;
  }

  public setXPath(xPath: XPath): void {
    this.xpath = xPath;
  }

  public getColumnNameXPath(): XPath {
    return this.columnNameXPath;
  }

  public setColumnNameXPath(columnNameXPath: XPath): void {
    this.columnNameXPath = columnNameXPath;
  }

  protected createXPath(expression: string): XPath {
    return DocumentHelper.createXPath(expression);
  }

  protected handleException(e: Error): void {
    console.log("Caught: " + e);
  }
}