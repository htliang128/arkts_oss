import Closeable from "./Closeable";
import Flushable from "./Flushable";

export default abstract class OutputStream implements Closeable, Flushable {
  constructor() {
  }

  public abstract write(b: number): void;

  public writeBytes(b: Uint8Array, off: number = 0, len: number = b.length): void {
    if (off < 0 || len < 0 || off + len > b.length) {
      throw new RangeError("Index out of bounds");
    }
    for (let i = 0; i < len; i++) {
      this.write(b[off + i]);
    }
  }

  public flush(): void {
    // Implement flush logic if needed
  }

  public close(): void {
  }
}
