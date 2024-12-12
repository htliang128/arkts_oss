export default  class ExternalEntityDecl implements Decl {
  private name: string;
  private publicID: string | null;
  private systemID: string | null;

  constructor();
  constructor(name: string, publicID: string | null, systemID: string | null);
  constructor(name?: string, publicID: string | null = null, systemID: string | null = null) {
    this.name = name || '';
    this.publicID = publicID;
    this.systemID = systemID;
  }

  public getName(): string {
    return this.name;
  }

  public setName(name: string): void {
    this.name = name;
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

  public toString(): string {
    const buffer: string[] = ["<!ENTITY "];
    if (this.name.startsWith("%")) {
      buffer.push("% ", this.name.substring(1));
    } else {
      buffer.push(this.name);
    }

    if (this.publicID !== null) {
      buffer.push(" PUBLIC \"", this.publicID, "\" ");
      if (this.systemID !== null) {
        buffer.push("\"", this.systemID, "\" ");
      }
    } else if (this.systemID !== null) {
      buffer.push(" SYSTEM \"", this.systemID, "\" ");
    }

    buffer.push(">");
    return buffer.join('');
  }
}
