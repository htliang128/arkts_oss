export default  class XMLErrorHandler {
  protected static readonly ERROR_QNAME: QName = QName.get("error");
  protected static readonly FATALERROR_QNAME: QName = QName.get("fatalError");
  protected static readonly WARNING_QNAME: QName = QName.get("warning");

  private errors: Element;
  private errorQName: QName;
  private fatalErrorQName: QName;
  private warningQName: QName;

  constructor(errors?: Element) {
    this.errorQName = XMLErrorHandler.ERROR_QNAME;
    this.fatalErrorQName = XMLErrorHandler.FATALERROR_QNAME;
    this.warningQName = XMLErrorHandler.WARNING_QNAME;
    this.errors = errors || DocumentHelper.createElement("errors");
  }

  public error(e: SAXParseException): void {
    let element = this.errors.addElement(this.errorQName);
    this.addException(element, e);
  }

  public fatalError(e: SAXParseException): void {
    let element = this.errors.addElement(this.fatalErrorQName);
    this.addException(element, e);
  }

  public warning(e: SAXParseException): void {
    let element = this.errors.addElement(this.warningQName);
    this.addException(element, e);
  }

  public getErrors(): Element {
    return this.errors;
  }

  public setErrors(errors: Element): void {
    this.errors = errors;
  }

  public getErrorQName(): QName {
    return this.errorQName;
  }

  public setErrorQName(errorQName: QName): void {
    this.errorQName = errorQName;
  }

  public getFatalErrorQName(): QName {
    return this.fatalErrorQName;
  }

  public setFatalErrorQName(fatalErrorQName: QName): void {
    this.fatalErrorQName = fatalErrorQName;
  }

  public getWarningQName(): QName {
    return this.warningQName;
  }

  public setWarningQName(warningQName: QName): void {
    this.warningQName = warningQName;
  }

  protected addException(element: Element, e: SAXParseException): void {
    element.addAttribute("column", e.getColumnNumber().toString());
    element.addAttribute("line", e.getLineNumber().toString());
    let publicID = e.getPublicId();

    if (publicID && publicID.length > 0) {
      element.addAttribute("publicID", publicID);
    }

    let systemID = e.getSystemId();

    if (systemID && systemID.length > 0) {
      element.addAttribute("systemID", systemID);
    }

    element.addText(e.getMessage());
  }
}