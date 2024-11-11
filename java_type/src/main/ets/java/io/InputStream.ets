import Closeable from "./Closeable";
import OutputStream from "./OutputStream";

export default abstract class InputStream implements Closeable {
  private static readonly MAX_SKIP_BUFFER_SIZE = 2048;
  private static readonly DEFAULT_BUFFER_SIZE = 16384;

  constructor() {
  }

  public abstract read(): number;

  public readBytes(b: Uint8Array, off: number = 0, len: number = b.length): number {
    if (len === 0) {
      return 0;
    }

    let c = this.read();
    if (c === -1) {
      return -1;
    }
    b[off] = c;

    let i = 1;
    try {
      for (; i < len; i++) {
        c = this.read();
        if (c === -1) {
          break;
        }
        b[off + i] = c;
      }
    } catch (e) {
    }
    return i;
  }

  public readAllBytes(): Uint8Array {
    return this.readNBytes(Number.MAX_SAFE_INTEGER);
  }

  public readNBytes(len: number): Uint8Array {
    if (len < 0) {
      throw new Error("len < 0");
    }

    const buffers: Uint8Array[] = [];
    let total = 0;
    let remaining = len;
    let n: number;

    do {
      const buf = new Uint8Array(Math.min(remaining, InputStream.DEFAULT_BUFFER_SIZE));
      let nRead = 0;

      while ((n = this.readBytes(buf, nRead, Math.min(buf.length - nRead, remaining))) > 0) {
        nRead += n;
        remaining -= n;
      }

      if (nRead > 0) {
        total += nRead;
        buffers.push(buf.subarray(0, nRead));
      }
    } while (n >= 0 && remaining > 0);

    const result = new Uint8Array(total);
    let offset = 0;
    for (const buffer of buffers) {
      result.set(buffer, offset);
      offset += buffer.length;
    }
    return result;
  }

  public skip(n: number): number {
    let remaining = n;
    let nr: number;

    if (n <= 0) {
      return 0;
    }

    const size = Math.min(InputStream.MAX_SKIP_BUFFER_SIZE, remaining);
    const skipBuffer = new Uint8Array(size);
    while (remaining > 0) {
      nr = this.readBytes(skipBuffer, 0, Math.min(size, remaining));
      if (nr < 0) {
        break;
      }
      remaining -= nr;
    }

    return n - remaining;
  }

  public skipNBytes(n: number): void {
    while (n > 0) {
      const ns = this.skip(n);
      if (ns > 0 && ns <= n) {
        n -= ns;
      } else if (ns === 0) {
        if (this.read() === -1) {
          throw new Error("EOFException");
        }
        n--;
      } else {
        throw new Error("Unable to skip exactly");
      }
    }
  }

  public available(): number {
    return 0;
  }

  public close(): void {
  }

  public mark(readlimit: number): void {
  }

  public reset(): void {
    throw new Error("mark/reset not supported");
  }

  public markSupported(): boolean {
    return false;
  }

  public transferTo(out: OutputStream): number {
    if (!out) {
      throw new Error("Output stream is null");
    }
    let transferred = 0;
    const buffer = new Uint8Array(InputStream.DEFAULT_BUFFER_SIZE);
    let read: number;
    while ((read = this.readBytes(buffer, 0, InputStream.DEFAULT_BUFFER_SIZE)) >= 0) {
      out.writeBytes(buffer, 0, read);
      if (transferred < Number.MAX_SAFE_INTEGER) {
        transferred += read;
      }
    }
    return transferred;
  }
}

