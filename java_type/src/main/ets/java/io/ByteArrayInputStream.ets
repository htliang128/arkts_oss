import IndexOutOfBoundsException from "../lang/IndexOutOfBoundsException";
import InputStream from "./InputStream";

export default class ByteArrayInputStream extends InputStream {
  protected buf: Uint8Array;
  protected pos: number;
  protected markPos: number = 0;
  protected count: number;

  constructor(buf: ArrayBuffer);

  constructor(buf: Uint8Array);

  constructor(buf: Uint8Array, offset: number, length: number);

  constructor(buf: ArrayBuffer | Uint8Array, offset?: number, length?: number) {
    super();
    if (buf instanceof Uint8Array) {
      this.buf = buf;
    } else {
      this.buf = new Uint8Array(buf);
    }
    this.pos = offset ?? 0;
    if (offset && length) {
      this.count = Math.min(this.buf.length, offset + length);
      return
    }
    this.count = this.buf.length;
  }


  public read(): number {
    return (this.pos < this.count) ? (this.buf[this.pos++] & 0xff) : -1;
  }

  public readBytes(b: Uint8Array, off: number = 0, len: number = b.length): number {
    if (this.pos >= this.count) {
      return -1;
    }

    if (len <= 0) {
      return 0;
    }

    if (len < 0 || len > b.length - off) {
      throw new IndexOutOfBoundsException();
    }

    let avail = this.count - this.pos;
    if (len > avail) {
      len = avail;
    }

    b.set(this.buf.slice(this.pos, this.pos + len), off);
    this.pos += len;
    return len;
  }

  public skip(n: number): number {
    let k = this.count - this.pos;
    if (n < k) {
      k = n < 0 ? 0 : n;
    }

    this.pos += k;
    return k;
  }

  public available(): number {
    return this.count - this.pos;
  }

  public markSupported(): boolean {
    return true;
  }

  public mark(readlimit: number): void {
    this.markPos = this.pos;
  }

  public reset(): void {
    this.pos = this.markPos;
  }

  public close(): void {
  }
}