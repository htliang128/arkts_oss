import AbstractNode from "./AbstractNode";

export default  abstract class AbstractDocumentType extends AbstractNode implements DocumentType {
  constructor() {}

  public getNodeType(): number {
    return 10;
  }

  public getName(): string {
    return this.getElementName();
  }

  public setName(name: string): void {
    this.setElementName(name);
  }

  public getPath(context: Element): string {
    return '';
  }

  public getUniquePath(context: Element): string {
    return '';
  }

  public getText(): string {
    const list = this.getInternalDeclarations();
    if (list && list.length > 0) {
      const buffer: string[] = [];
      const iter = list[Symbol.iterator]();
      const decl = iter.next().value;
      buffer.push(decl.toString());

      for (const decl of iter) {
        buffer.push('\n');
        buffer.push(decl.toString());
      }

      return buffer.join('');
    } else {
      return '';
    }
  }

  public toString(): string {
    return super.toString() + ` [DocumentType: ${this.asXML()}]`;
  }

  public asXML(): string {
    const buffer: string[] = ['<!DOCTYPE ', this.getElementName()];
    let hasPublicID = false;
    const publicID = this.getPublicID();
    if (publicID && publicID.length > 0) {
      buffer.push(' PUBLIC "');
      buffer.push(publicID);
      buffer.push('"');
      hasPublicID = true;
    }

    const systemID = this.getSystemID();
    if (systemID && systemID.length > 0) {
      if (!hasPublicID) {
        buffer.push(' SYSTEM');
      }

      buffer.push(' "');
      buffer.push(systemID);
      buffer.push('"');
    }

    buffer.push('>');
    return buffer.join('');
  }

  public write(writer: Writer): void {
    writer.write('<!DOCTYPE ');
    writer.write(this.getElementName());
    let hasPublicID = false;
    const publicID = this.getPublicID();
    if (publicID && publicID.length > 0) {
      writer.write(' PUBLIC "');
      writer.write(publicID);
      writer.write('"');
      hasPublicID = true;
    }

    const systemID = this.getSystemID();
    if (systemID && systemID.length > 0) {
      if (!hasPublicID) {
        writer.write(' SYSTEM');
      }

      writer.write(' "');
      writer.write(systemID);
      writer.write('"');
    }

    const list = this.getInternalDeclarations();
    if (list && list.length > 0) {
      writer.write(' [');
      for (const decl of list) {
        writer.write('\n  ');
        writer.write(decl.toString());
      }
      writer.write('\n]');
    }

    writer.write('>');
  }

  public accept(visitor: Visitor): void {
    visitor.visit(this);
  }

  protected abstract getInternalDeclarations(): Decl[];
  protected abstract getElementName(): string;
  protected abstract setElementName(name: string): void;
  protected abstract getPublicID(): string | null;
  protected abstract getSystemID(): string | null;
}