import Document from "../Document";

export default class DocumentInputSource {
  private document: Document;

  constructor();
  constructor(document: Document);
  constructor(arg1?: Document) {
    if (arg1) {
      this.document = arg1;
      this.setSystemId(this.document.getName());
    }
  }

  getDocument(): Document {
    return this.document;
  }

  setDocument(document: Document): void {
    this.document = document;
    this.setSystemId(document.getName());
  }

  setCharacterStream(characterStream: Reader): void {
    throw new UnsupportedOperationException();
  }

  getCharacterStream(): Reader {
    try {
      const out = new StringWriter();
      const writer = new XMLWriter(out);
      writer.write(this.document);
      writer.flush();
      return new StringReader(out.toString());
    } catch (var3) {
      const e = var3;
      return {
        read: (ch: char[], offset: number, length: number): number => {
          throw e;
        },
        close: (): void => {}
      } as Reader;
    }
  }

  private setSystemId(systemId: string): void {
    // Implement setSystemId logic if needed
  }
}