export default class OutputFormat implements Cloneable {
  protected static readonly STANDARD_INDENT = "  ";
  private suppressDeclaration: boolean = false;
  private newLineAfterDeclaration: boolean = true;
  private encoding: string = "UTF-8";
  private omitEncoding: boolean = false;
  private indent: string | null = null;
  private expandEmptyElements: boolean = false;
  private newlines: boolean = false;
  private lineSeparator: string = "\n";
  private trimText: boolean = false;
  private padText: boolean = false;
  private doXHTML: boolean = false;
  private newLineAfterNTags: number = 0;
  private attributeQuoteChar: string = '"';

  constructor();
  constructor(indent: string);
  constructor(indent: string | null = null) {
    this.indent = indent;
  }

  public getLineSeparator(): string {
    return this.lineSeparator;
  }

  public setLineSeparator(separator: string): void {
    this.lineSeparator = separator;
  }

  public isNewlines(): boolean {
    return this.newlines;
  }

  public setNewlines(newlines: boolean): void {
    this.newlines = newlines;
  }

  public getEncoding(): string {
    return this.encoding;
  }

  public setEncoding(encoding: string | null): void {
    if (encoding != null) {
      this.encoding = encoding;
    }
  }

  public isOmitEncoding(): boolean {
    return this.omitEncoding;
  }

  public setOmitEncoding(omitEncoding: boolean): void {
    this.omitEncoding = omitEncoding;
  }

  public setSuppressDeclaration(suppressDeclaration: boolean): void {
    this.suppressDeclaration = suppressDeclaration;
  }

  public isSuppressDeclaration(): boolean {
    return this.suppressDeclaration;
  }

  public setNewLineAfterDeclaration(newLineAfterDeclaration: boolean): void {
    this.newLineAfterDeclaration = newLineAfterDeclaration;
  }

  public isNewLineAfterDeclaration(): boolean {
    return this.newLineAfterDeclaration;
  }

  public isExpandEmptyElements(): boolean {
    return this.expandEmptyElements;
  }

  public setExpandEmptyElements(expandEmptyElements: boolean): void {
    this.expandEmptyElements = expandEmptyElements;
  }

  public isTrimText(): boolean {
    return this.trimText;
  }

  public setTrimText(trimText: boolean): void {
    this.trimText = trimText;
  }

  public isPadText(): boolean {
    return this.padText;
  }

  public setPadText(padText: boolean): void {
    this.padText = padText;
  }

  public getIndent(): string | null {
    return this.indent;
  }

  public setIndent(indent: string | null): void {
    if (indent != null && indent.length <= 0) {
      indent = null;
    }
    this.indent = indent;
  }

  public setIndent(doIndent: boolean): void {
    this.indent = doIndent ? "  " : null;
  }

  public setIndentSize(indentSize: number): void {
    this.indent = " ".repeat(indentSize);
  }

  public isXHTML(): boolean {
    return this.doXHTML;
  }

  public setXHTML(xhtml: boolean): void {
    this.doXHTML = xhtml;
  }

  public getNewLineAfterNTags(): number {
    return this.newLineAfterNTags;
  }

  public setNewLineAfterNTags(tagCount: number): void {
    this.newLineAfterNTags = tagCount;
  }

  public getAttributeQuoteCharacter(): string {
    return this.attributeQuoteChar;
  }

  public setAttributeQuoteCharacter(quoteChar: string): void {
    if (quoteChar !== "'" && quoteChar !== '"') {
      throw new Error(`Invalid attribute quote character (${quoteChar})`);
    }
    this.attributeQuoteChar = quoteChar;
  }

  public parseOptions(args: string[], i: number): number {
    const size = args.length;
    for (; i < size; i++) {
      switch (args[i]) {
        case "-suppressDeclaration":
          this.setSuppressDeclaration(true);
          break;
        case "-omitEncoding":
          this.setOmitEncoding(true);
          break;
        case "-indent":
          this.setIndent(args[++i]);
          break;
        case "-indentSize":
          this.setIndentSize(parseInt(args[++i]));
          break;
        case "-expandEmpty":
          this.setExpandEmptyElements(true);
          break;
        case "-encoding":
          this.setEncoding(args[++i]);
          break;
        case "-newlines":
          this.setNewlines(true);
          break;
        case "-lineSeparator":
          this.setLineSeparator(args[++i]);
          break;
        case "-trimText":
          this.setTrimText(true);
          break;
        case "-padText":
          this.setPadText(true);
          break;
        case "-xhtml":
          this.setXHTML(true);
          break;
        default:
          return i;
      }
    }
    return i;
  }

  public static createPrettyPrint(): OutputFormat {
    const format = new OutputFormat();
    format.setIndentSize(2);
    format.setNewlines(true);
    format.setTrimText(true);
    format.setPadText(true);
    return format;
  }

  public static createCompactFormat(): OutputFormat {
    const format = new OutputFormat();
    format.setIndent(false);
    format.setNewlines(false);
    format.setTrimText(true);
    return format;
  }
}