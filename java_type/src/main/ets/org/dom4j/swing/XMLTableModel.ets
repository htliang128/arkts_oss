export default  class XMLTableModel extends AbstractTableModel {
  private definition: XMLTableDefinition;
  private source: any;
  private rows: Node[] | null = null;

  constructor(tableDefinition: Element, source: any);
  constructor(tableDefinition: Document, source: any);
  constructor(definition: XMLTableDefinition, source: any);
  constructor(arg1: Element | Document | XMLTableDefinition, source: any) {
    if (arg1 instanceof Element || arg1 instanceof Document) {
      this.definition = XMLTableDefinition.load(arg1);
      this.source = source;
    } else {
      this.definition = arg1;
      this.source = source;
    }
  }

  public getRowValue(rowIndex: number): Node {
    return this.getRows()[rowIndex];
  }

  public getRows(): Node[] {
    if (this.rows === null) {
      this.rows = this.definition.getRowXPath().selectNodes(this.source);
    }
    return this.rows;
  }

  public getColumnClass(columnIndex: number): any {
    return this.definition.getColumnClass(columnIndex);
  }

  public getColumnCount(): number {
    return this.definition.getColumnCount();
  }

  public getColumnName(columnIndex: number): string {
    const xpath = this.definition.getColumnNameXPath(columnIndex);
    if (xpath) {
      console.log(`Evaluating column xpath: ${xpath} value: ${xpath.valueOf(this.source)}`);
      return xpath.valueOf(this.source);
    } else {
      return this.definition.getColumnName(columnIndex);
    }
  }

  public getValueAt(rowIndex: number, columnIndex: number): any {
    try {
      const row = this.getRowValue(rowIndex);
      return this.definition.getValueAt(row, columnIndex);
    } catch (e) {
      this.handleException(e);
      return null;
    }
  }

  public getRowCount(): number {
    return this.getRows().length;
  }

  public getDefinition(): XMLTableDefinition {
    return this.definition;
  }

  public setDefinition(definition: XMLTableDefinition): void {
    this.definition = definition;
  }

  public getSource(): any {
    return this.source;
  }

  public setSource(source: any): void {
    this.source = source;
    this.rows = null;
  }

  protected handleException(e: Error): void {
    console.log(`Caught: ${e}`);
  }
}