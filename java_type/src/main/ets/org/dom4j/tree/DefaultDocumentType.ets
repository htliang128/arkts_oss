export default class DefaultDocumentType extends AbstractDocumentType {
  protected elementName: string;
  private publicID: string | null;
  private systemID: string | null;
  private internalDeclarations: Decl[] | null;
  private externalDeclarations: Decl[] | null;

  constructor();
  constructor(elementName: string, systemID: string);
  constructor(elementName: string, publicID: string, systemID: string);
  constructor(arg1?: string | undefined, arg2?: string | string | undefined) {
    super();
    if (typeof arg1 === 'string' && typeof arg2 === 'string') {
      this.elementName = arg1;
      this.systemID = arg2;
      this.publicID = null;
    } else if (typeof arg1 === 'string') {
      this.elementName = arg1;
      this.publicID = null;
      this.systemID = null;
    } else {
      this.elementName = '';
      this.publicID = null;
      this.systemID = null;
    }
    this.internalDeclarations = null;
    this.externalDeclarations = null;
  }

  public getElementName(): string {
    return this.elementName;
  }

  public setElementName(elementName: string): void {
    this.elementName = elementName;
  }

  public getPublicID(): string | null {
    return this.publicID;
  }

  public setPublicID(publicID: string): void {
    this.publicID = publicID;
  }

  public getSystemID(): string | null {
    return this.systemID;
  }

  public setSystemID(systemID: string): void {
    this.systemID = systemID;
  }

  public getInternalDeclarations(): Decl[] | null {
    return this.internalDeclarations;
  }

  public setInternalDeclarations(internalDeclarations: Decl[]): void {
    this.internalDeclarations = internalDeclarations;
  }

  public getExternalDeclarations(): Decl[] | null {
    return this.externalDeclarations;
  }

  public setExternalDeclarations(externalDeclarations: Decl[]): void {
    this.externalDeclarations = externalDeclarations;
  }
}