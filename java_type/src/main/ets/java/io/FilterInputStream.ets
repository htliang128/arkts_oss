import InputStream from "./InputStream";

export default class FilterInputStream extends InputStream {
  protected inputStream: InputStream;

  constructor(inputStream: InputStream) {
    super();
    this.inputStream = inputStream;
  }

  public read(): number {
    return this.inputStream.read();
  }

  public readBytes(b: Uint8Array, off: number = 0, len: number = b.length): number {
    return this.inputStream.readBytes(b, off, len);
  }

  public skip(n: number): number {
    return this.inputStream.skip(n);
  }

  public available(): number {
    return this.inputStream.available();
  }

  public close(): void {
    this.inputStream.close();
  }

  public mark(readLimit: number): void {
    this.inputStream.mark(readLimit);
  }

  public reset(): void {
    this.inputStream.reset();
  }

  public markSupported(): boolean {
    return this.inputStream.markSupported();
  }
}