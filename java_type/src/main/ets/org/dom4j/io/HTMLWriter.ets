export default class HTMLWriter extends XMLWriter {
  private static lineSeparator: string = System.getProperty("line.separator");
  protected static DEFAULT_PREFORMATTED_TAGS: Set<string> = new HashSet();
  protected static DEFAULT_HTML_FORMAT: OutputFormat;

  private formatStack: Stack<FormatState> = new Stack();
  private lastText: string = "";
  private tagsOuput: number = 0;
  private newLineAfterNTags: number = -1;
  private preformattedTags: Set<string>;
  private omitElementCloseSet: Set<string>;

  constructor(writer: Writer) {
    super(writer, HTMLWriter.DEFAULT_HTML_FORMAT);
    this.preformattedTags = HTMLWriter.DEFAULT_PREFORMATTED_TAGS;
  }

  constructor(writer: Writer, format: OutputFormat) {
    super(writer, format);
    this.preformattedTags = HTMLWriter.DEFAULT_PREFORMATTED_TAGS;
  }

  constructor() throws UnsupportedEncodingException {
  super(HTMLWriter.DEFAULT_HTML_FORMAT);
  this.preformattedTags = HTMLWriter.DEFAULT_PREFORMATTED_TAGS;
}

constructor(format: OutputFormat) throws UnsupportedEncodingException {
  super(format);
  this.preformattedTags = HTMLWriter.DEFAULT_PREFORMATTED_TAGS;
}

constructor(out: OutputStream) throws UnsupportedEncodingException {
  super(out, HTMLWriter.DEFAULT_HTML_FORMAT);
  this.preformattedTags = HTMLWriter.DEFAULT_PREFORMATTED_TAGS;
}

constructor(out: OutputStream, format: OutputFormat) throws UnsupportedEncodingException {
  super(out, format);
  this.preformattedTags = HTMLWriter.DEFAULT_PREFORMATTED_TAGS;
}

public startCDATA(): void {
}

public endCDATA(): void {
}

protected writeCDATA(text: string): void {
  if (this.getOutputFormat().isXHTML()) {
  super.writeCDATA(text);
} else {
  this.writer.write(text);
}
this.lastOutputNodeType = 4;
}

protected writeEntity(entity: Entity): void {
  this.writer.write(entity.getText());
  this.lastOutputNodeType = 5;
}

protected writeDeclaration(): void {
}

protected writeString(text: string): void {
  if (text === "\n") {
  if (!this.formatStack.empty()) {
  super.writeString(HTMLWriter.lineSeparator);
}
} else {
  this.lastText = text;
  if (this.formatStack.empty()) {
    super.writeString(text.trim());
  } else {
    super.writeString(text);
  }
}
}

protected writeClose(qualifiedName: string): void {
  if (!this.omitElementClose(qualifiedName)) {
  super.writeClose(qualifiedName);
}
}

protected writeEmptyElementClose(qualifiedName: string): void {
  if (this.getOutputFormat().isXHTML()) {
  if (this.omitElementClose(qualifiedName)) {
  this.writer.write(" />");
} else {
  super.writeEmptyElementClose(qualifiedName);
}
} else if (this.omitElementClose(qualifiedName)) {
  this.writer.write(">");
} else {
  super.writeEmptyElementClose(qualifiedName);
}
}

protected omitElementClose(qualifiedName: string): boolean {
  return this.internalGetOmitElementCloseSet().contains(qualifiedName.toUpperCase());
}

private internalGetOmitElementCloseSet(): Set<string> {
  if (this.omitElementCloseSet == null) {
  this.omitElementCloseSet = new HashSet();
  this.loadOmitElementCloseSet(this.omitElementCloseSet);
}
return this.omitElementCloseSet;
}

protected loadOmitElementCloseSet(set: Set<string>): void {
  set.add("AREA");
  set.add("BASE");
  set.add("BR");
  set.add("COL");
  set.add("HR");
  set.add("IMG");
  set.add("INPUT");
  set.add("LINK");
  set.add("META");
  set.add("P");
  set.add("PARAM");
}

public getOmitElementCloseSet(): Set<string> {
  return new Set(this.internalGetOmitElementCloseSet());
}

public setOmitElementCloseSet(newSet: Set<string>): void {
  this.omitElementCloseSet = new HashSet();
  if (newSet != null) {
  for (const aTag of newSet) {
  if (aTag != null) {
  this.omitElementCloseSet.add(aTag.toUpperCase());
}
}
}
}

public getPreformattedTags(): Set<string> {
  return new Set(this.preformattedTags);
}

public setPreformattedTags(newSet: Set<string>): void {
  this.preformattedTags = new HashSet();
  if (newSet != null) {
  for (const aTag of newSet) {
  if (aTag != null) {
  this.preformattedTags.add(aTag.toUpperCase());
}
}
}
}

public isPreformattedTag(qualifiedName: string): boolean {
  return this.preformattedTags != null && this.preformattedTags.contains(qualifiedName.toUpperCase());
}

protected writeElement(element: Element): void {
  if (this.newLineAfterNTags === -1) {
  this.lazyInitNewLinesAfterNTags();
}

if (this.newLineAfterNTags > 0 && this.tagsOuput > 0 && this.tagsOuput % this.newLineAfterNTags === 0) {
  super.writer.write(HTMLWriter.lineSeparator);
}

this.tagsOuput++;
const qualifiedName: string = element.getQualifiedName();
const saveLastText: string = this.lastText;
const size: number = element.nodeCount();
if (this.isPreformattedTag(qualifiedName)) {
  const currentFormat: OutputFormat = this.getOutputFormat();
  const saveNewlines: boolean = currentFormat.isNewlines();
  const saveTrimText: boolean = currentFormat.isTrimText();
  const currentIndent: string = currentFormat.getIndent();
  this.formatStack.push(new FormatState(saveNewlines, saveTrimText, currentIndent));
  let var13: boolean = false;

  try {
    var13 = true;
    super.writePrintln();
    if (saveLastText.trim().length === 0 && currentIndent != null && currentIndent.length > 0) {
      super.writer.write(this.justSpaces(saveLastText));
    }

    currentFormat.setNewlines(false);
    currentFormat.setTrimText(false);
    currentFormat.setIndent("");
    super.writeElement(element);
    var13 = false;
  } finally {
    if (var13) {
      const state: FormatState = this.formatStack.pop();
      currentFormat.setNewlines(state.isNewlines());
      currentFormat.setTrimText(state.isTrimText());
      currentFormat.setIndent(state.getIndent());
    }
  }

  const state: FormatState = this.formatStack.pop();
  currentFormat.setNewlines(state.isNewlines());
  currentFormat.setTrimText(state.isTrimText());
  currentFormat.setIndent(state.getIndent());
} else {
  super.writeElement(element);
}
}

private justSpaces(text: string): string {
  const size: number = text.length;
  const res: StringBuffer = new StringBuffer(size);
  let i: number = 0;

  while (i < size) {
    const c: string = text.charAt(i);
    switch (c) {
      default:
        res.append(c);
      case '\n':
      case '\r':
        i++;
    }
  }

  return res.toString();
}

private lazyInitNewLinesAfterNTags(): void {
  if (this.getOutputFormat().isNewlines()) {
  this.newLineAfterNTags = 0;
} else {
  this.newLineAfterNTags = this.getOutputFormat().getNewLineAfterNTags();
}
}

public static prettyPrintHTML(html: string): string {
  return prettyPrintHTML(html, true, true, false, true);
}

public static prettyPrintXHTML(html: string): string {
  return prettyPrintHTML(html, true, true, true, false);
}

public static prettyPrintHTML(html: string, newlines: boolean, trim: boolean, isXHTML: boolean, expandEmpty: boolean): string {
  const sw: StringWriter = new StringWriter();
  const format: OutputFormat = OutputFormat.createPrettyPrint();
  format.setNewlines(newlines);
  format.setTrimText(trim);
  format.setXHTML(isXHTML);
  format.setExpandEmptyElements(expandEmpty);
  const writer: HTMLWriter = new HTMLWriter(sw, format);
  const document: Document = DocumentHelper.parseText(html);
  writer.write(document);
  writer.flush();
  return sw.toString();
}

static {
  HTMLWriter.DEFAULT_PREFORMATTED_TAGS.add("PRE");
  HTMLWriter.DEFAULT_PREFORMATTED_TAGS.add("SCRIPT");
  HTMLWriter.DEFAULT_PREFORMATTED_TAGS.add("STYLE");
  HTMLWriter.DEFAULT_PREFORMATTED_TAGS.add("TEXTAREA");
  HTMLWriter.DEFAULT_HTML_FORMAT = new OutputFormat("  ", true);
  HTMLWriter.DEFAULT_HTML_FORMAT.setTrimText(true);
  HTMLWriter.DEFAULT_HTML_FORMAT.setSuppressDeclaration(true);
}

private class FormatState {
  private newlines: boolean = false;
  private trimText: boolean = false;
  private indent: string = "";

  public FormatState(newLines: boolean, trimText: boolean, indent: string) {
    this.newlines = newLines;
    this.trimText = trimText;
    this.indent = indent;
  }

  public isNewlines(): boolean {
    return this.newlines;
  }

  public isTrimText(): boolean {
    return this.trimText;
  }

  public getIndent(): string {
    return this.indent;
  }
}
}