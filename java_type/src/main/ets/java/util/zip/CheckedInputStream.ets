import FilterInputStream from "../../io/FilterInputStream";
import InputStream from "../../io/InputStream";
import Checksum from "./Checksum";

export default class CheckedInputStream extends FilterInputStream {
  private cksum: Checksum;

  constructor(inputStream: InputStream, cksum: Checksum) {
    super(inputStream);
    this.cksum = cksum;
  }

  public read(): number {
    let b = this.inputStream.read();
    if (b != -1) {
      this.cksum.update(b);
    }
    return b;
  }

  public readBytes(buf: Uint8Array, offset: number, length: number): number {
    length = this.inputStream.readBytes(buf, offset, length);
    if (length != -1) {
      this.cksum.updateBytes(buf, offset, length);
    }
    return length;
  }

  public skip(n: number): number {
    let buf = new Uint8Array(512);
    let total = 0;
    while (total < n) {
      let len = n - total;
      len = this.readBytes(buf, 0, len < buf.length ? len : buf.length);
      if (len == -1) {
        return total;
      }
      total += len;
    }
    return total;
  }

  public getCheckSum(): Checksum {
    return this.cksum;
  }
}