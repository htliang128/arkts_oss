export default  class XMLTableDefinition implements Serializable, VariableContext {
  private rowXPath?: XPath;
  private columns: XMLTableColumnDefinition[] = [];
  private columnArray?: XMLTableColumnDefinition[];
  private columnNameIndex?: Map<string, XMLTableColumnDefinition>;
  private variableContext?: VariableContext;
  private rowValue?: Object;

  constructor() {}

  public static load(definition: Document): XMLTableDefinition {
    return this.load(definition.getRootElement());
  }

  public static load(definition: Element): XMLTableDefinition {
    const answer = new XMLTableDefinition();
    answer.setRowExpression(definition.attributeValue("select"));
    const iter = definition.elementIterator("column");

    while (iter.hasNext()) {
      const element = iter.next() as Element;
      const expression = element.attributeValue("select");
      const name = element.getText();
      const typeName = element.attributeValue("type", "string");
      const columnXPath = element.attributeValue("columnNameXPath");
      const type = XMLTableColumnDefinition.parseType(typeName);
      if (columnXPath) {
        answer.addColumnWithXPathName(columnXPath, expression, type);
      } else {
        answer.addColumn(name, expression, type);
      }
    }

    return answer;
  }

  public getColumnClass(columnIndex: number): any {
    return this.getColumn(columnIndex).getColumnClass();
  }

  public getColumnCount(): number {
    return this.columns.length;
  }

  public getColumnName(columnIndex: number): string {
    return this.getColumn(columnIndex).getName();
  }

  public getColumnXPath(columnIndex: number): XPath {
    return this.getColumn(columnIndex).getXPath();
  }

  public getColumnNameXPath(columnIndex: number): XPath {
    return this.getColumn(columnIndex).getColumnNameXPath();
  }

  public getValueAt(row: Object, columnIndex: number): Object | null {
    const column = this.getColumn(columnIndex);
    let answer: Object | null = null;
    this.rowValue = row;
    answer = column.getValue(row);
    this.rowValue = null;
    return answer;
  }

  public addColumn(name: string, expression: string): void {
    this.addColumn(name, expression, 0);
  }

  public addColumn(name: string, expression: string, type: number): void {
    const xpath = this.createColumnXPath(expression);
    this.addColumn(new XMLTableColumnDefinition(name, xpath, type));
  }

  public addColumnWithXPathName(columnNameXPathExpression: string, expression: string, type: number): void {
    const columnNameXPath = this.createColumnXPath(columnNameXPathExpression);
    const xpath = this.createColumnXPath(expression);
    this.addColumn(new XMLTableColumnDefinition(columnNameXPath, xpath, type));
  }

  public addStringColumn(name: string, expression: string): void {
    this.addColumn(name, expression, 1);
  }

  public addNumberColumn(name: string, expression: string): void {
    this.addColumn(name, expression, 2);
  }

  public addColumn(column: XMLTableColumnDefinition): void {
    this.clearCaches();
    this.columns.push(column);
  }

  public removeColumn(column: XMLTableColumnDefinition): void {
    this.clearCaches();
    const index = this.columns.indexOf(column);
    if (index > -1) {
      this.columns.splice(index, 1);
    }
  }

  public clear(): void {
    this.clearCaches();
    this.columns = [];
  }

  public getColumn(index: number): XMLTableColumnDefinition {
    if (!this.columnArray) {
      this.columnArray = this.columns.slice();
    }
    return this.columnArray[index];
  }

  public getColumn(columnName: string): XMLTableColumnDefinition | undefined {
    if (!this.columnNameIndex) {
      this.columnNameIndex = new Map<string, XMLTableColumnDefinition>();
      for (const column of this.columns) {
        this.columnNameIndex.set(column.getName(), column);
      }
    }
    return this.columnNameIndex.get(columnName);
  }

  public getRowXPath(): XPath | undefined {
    return this.rowXPath;
  }

  public setRowXPath(rowXPath: XPath): void {
    this.rowXPath = rowXPath;
  }

  public setRowExpression(xpath: string): void {
    this.setRowXPath(this.createXPath(xpath));
  }

  public getVariableValue(namespaceURI: string, prefix: string, localName: string): Object | null {
    const column = this.getColumn(localName);
    return column ? column.getValue(this.rowValue) : null;
  }

  protected createXPath(expression: string): XPath {
    return DocumentHelper.createXPath(expression);
  }

  protected createColumnXPath(expression: string): XPath {
    const xpath = this.createXPath(expression);
    xpath.setVariableContext(this);
    return xpath;
  }

  protected clearCaches(): void {
    this.columnArray = undefined;
    this.columnNameIndex = undefined;
  }

  protected handleException(e: Exception): void {
    console.log("Caught: " + e);
  }
}