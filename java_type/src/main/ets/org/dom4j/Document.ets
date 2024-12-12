import Branch from "./Branch";
import DocumentType from "./DocumentType";
import Element from "./Element";

export default  interface Document extends Branch {
  getRootElement(): Element;

  setRootElement(var1: Element): void;

  addComment(var1: string): Document;

  addProcessingInstruction(var1: string, var2: string): Document;

  addProcessingInstruction(var1: string, var2: Map<string, string>): Document;

  addDocType(var1: string, var2: string, var3: string): Document;

  getDocType(): DocumentType;

  setDocType(var1: DocumentType): void;

  getEntityResolver(): EntityResolver;

  setEntityResolver(var1: EntityResolver): void;

  getXMLEncoding(): string;

  setXMLEncoding(var1: string): void;
}