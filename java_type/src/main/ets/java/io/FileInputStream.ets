import InputStream from "./InputStream";
import fs from '@ohos.file.fs';
import FileUtil from "../util/FileUtil";
import FileNotFoundException from "./FileNotFoundException";
import IOException from "./IOException";
import IndexOutOfBoundsException from "../lang/IndexOutOfBoundsException";

export default class FileInputStream extends InputStream {
  private file: fs.File;
  private fd: number;
  private size: number;
  private readPosition: number = 0;
  private markPosition: number = 0;
  private readLimitPosition: number = 0;

  constructor(path: string);

  constructor(file: fs.File);

  constructor(arg: string | fs.File) {
    super();
    if (typeof arg === 'string') {
      let path = arg;
      this.file = fs.openSync(path, fs.OpenMode.READ_ONLY);
      this.fd = this.file.fd;
      this.size = fs.statSync(this.fd).size;
      return;
    }
    this.file = arg;
    this.fd = this.file.fd;
    this.size = fs.statSync(this.fd).size;
  }

  public read(): number {
    let tmp = new Uint8Array(1);
    let readLen = this.readBytes(tmp);
    if (readLen !== 1) {
      return -1;
    }

    if (this.readPosition > this.size - 1) {
      return 0;
    }

    return tmp[0];
  }

  public readNBytes(len: number): Uint8Array {
    if (len < 0) {
      throw new Error("len < 0");
    }

    len = Math.min(this.available(), len);
    let result = new Uint8Array(len);
    let readSize = this.readBytes(result);
    this.readPosition += readSize;
    return result;
  }

  public readBytes(b: Uint8Array, off: number = 0, len: number = b.length): number {
    if (len === 0 || this.readPosition >= this.size) {
      return -1;
    }

    if (len < 0 || len > b.length - off) {
      throw new IndexOutOfBoundsException();
    }

    let readLen = -1;
    try {
      let tmpBuf = new ArrayBuffer(len);
      readLen = fs.readSync(this.fd, tmpBuf, {
        offset: this.readPosition, length: len
      });
      this.readPosition += readLen;

      b.set(new Uint8Array(tmpBuf).slice(0, readLen), off);
    } catch (e) {
      throw new IOException(`IOException: ${e}`)
    }
    return readLen;
  }

  public skip(n: number): number {
    let available = this.available();
    if (available > n && (this.readPosition + n) > -1) {
      this.readPosition += n;
      return n;
    }
    this.readPosition = this.size;
    return available;
  }

  public available(): number {
    return this.size - this.readPosition;
  }

  public close(): void {
    fs.closeSync(this.file);
  }

  public getFD(): number {
    return this.fd;
  }

  public getFile(): fs.File {
    return this.file;
  }

  public markSupported(): boolean {
    return true;
  }

  public mark(readLimit: number): void {
    this.markPosition = this.readPosition;
    this.readLimitPosition = this.readPosition + readLimit;
  }

  public reset(): void {
    if (this.readLimitPosition > this.readPosition) {
      this.readPosition = this.markPosition;
      return;
    }
  }
}