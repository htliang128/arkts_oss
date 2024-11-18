export default class StackTraceElement {
  private lineNumber: number;
  
  private columnNumber: number;
  
  private methodName:string;
  
  private fileName:string;
  
  private isNativeMethod: boolean = false;

  constructor(methodName:string, fileName:string, lineNumber:number, columnNumber:number) {
    this.methodName = methodName;
    this.fileName = fileName;
    this.lineNumber = lineNumber;
    this.columnNumber = columnNumber;
  }

  public getMethodName():string {
    return this.methodName;
  }

  public getFileName():string {
    return this.fileName;
  }

  public getLineNumber():number {
    return this.lineNumber;
  }

  public getColumnNumber():number {
    return this.columnNumber;
  }

  public toString():string {
    return ``
  }
}