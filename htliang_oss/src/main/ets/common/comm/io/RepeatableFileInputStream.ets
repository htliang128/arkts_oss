import fs from '@ohos.file.fs';
import ClientException from '../../../ClientException';
import BinaryUtil from '../../utils/BinaryUtil';
import buffer from '@ohos.buffer';

export default class RepeatableFileInputStream extends fs.ReadStream {
  private file?: fs.File;
  private fis: fs.ReadStream;
  private position: number = 0;
  private markPos: number = 0;

  constructor(fis?: fs.ReadStream, file?: fs.File) {
    super();
    if (!fis) {
      fis = fs.createReadStream(file?.path);
    }
    this.file = file;
    this.fis = fis;
    this.position = this.fis.seek(0, fs.WhenceType.SEEK_CUR);
    this.markPos = this.position;
  }

  reset(): void {
    this.position = this.fis.seek(this.markPos, fs.WhenceType.SEEK_SET);
  }

  markSupported(): boolean {
    return true;
  }

  mark(): void {
    try {
      this.position = this.fis.seek(0, fs.WhenceType.SEEK_CUR);
      this.markPos = this.position;
    } catch (err) {
      throw new ClientException("Failed to mark file position", err);
    }
    console.trace(`File input stream marked at position ${this.markPos}`);
  }

  available(): number {
    return this.fis.bytesRead - this.fis.seek(0, fs.WhenceType.SEEK_CUR);
  }

  close(): void {
    this.fis.close();
  }

  readNumber(): number {
    this.position++;
    let readResult = this.fis.read(1);
    if (!readResult) {
      return -1;
    }

    return BinaryUtil.getUtf8Array(readResult)[0];
  }

  skip(n: number): number {
    let left = this.available();
    let actualSkip = Math.min(n, left);
    this.position = this.fis.seek(actualSkip, fs.WhenceType.SEEK_CUR);
    return actualSkip;
  }

  readBytes(b: buffer.Buffer, off: number, len: number): number {
    let readResult = this.fis.read(len);
    if (!readResult) {
      return 0;
    }
    let readUint8Array = BinaryUtil.getUtf8Array(readResult);
    b.fill(readResult, off);
    return readUint8Array.length;
  }

  getWrappedInputStream(): fs.ReadStream {
    return this.fis;
  }

  getFile(): fs.File | undefined {
    return this.file;
  }
}