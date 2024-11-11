import InputStream from "./InputStream";
import fs from '@ohos.file.fs';

export default  class FileInputStream extends InputStream {
  private file: fs.File;

  private fd : number;

  private size: number;

  private readPos: number = 0;

  constructor(path: string) {
    super();
    this.file = fs.openSync(path, fs.OpenMode.READ_ONLY);
    this.fd = this.file.fd;
    this.size = fs.statSync(path).size;
  }

  public read(): number {
    let tmp = new Uint8Array(1);
    let readLen = this.readBytes(tmp);
    if (readLen !== 1) {
      return -1;
    }

    if (this.readPos > this.size -1) {
      return 0;
    }

    return tmp[0];
  }

  public readBytes(b: Uint8Array, off: number = 0, len: number = b.length): number {
    if (len === 0) {
      return 0;
    }

    if (this.readPos > this.size -1) {
      return 0;
    }

    let readLen = -1;
    try {
      let tmpBuf = new Uint8Array(len);
      let readLen = fs.readSync(this.fd, tmpBuf, {offset: this.readPos, length:len});
      this.readPos += readLen;
      b.set(tmpBuf.slice(0, readLen), off);
    } catch (e){
    }
    return readLen;
  }
}