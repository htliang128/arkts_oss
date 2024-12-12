export default  interface DocumentType extends Node {
  getElementName(): string;

  setElementName(var1: string): void;

  getPublicID(): string;

  setPublicID(var1: string): void;

  getSystemID(): string;

  setSystemID(var1: string): void;

  getInternalDeclarations(): Decl[];

  setInternalDeclarations(var1: Decl[]): void;

  getExternalDeclarations(): Decl[];

  setExternalDeclarations(var1: Decl[]): void;
}