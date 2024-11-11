import fs from '@ohos.file.fs';
import { zlib } from '@kit.BasicServicesKit';

export default class IOUtils {
  public static checkFilePath(filePath: string): boolean {
    try {
      return fs.accessSync(filePath, fs.AccessModeType.EXIST);
    } catch (err) {
      console.log("xxxx + " + err)
      return false;
    }
  }

  public static checkFile(file: fs.File): boolean {
    return IOUtils.checkFilePath(file.path);
  }

  public static async checkSum(toCheck : string | ArrayBuffer): Promise<number> {
    let checkSum = zlib.createChecksumSync();
    let crc = 0;

    if (typeof(toCheck) === 'string') {
      let file = fs.openSync(toCheck);
      let buf = new ArrayBuffer(1024);
      let readLen = 0;
      let readTotal = 0;

      while ((readLen = fs.readSync(file.fd, buf, {offset: readTotal,length: 1024})) > 0) {
        crc = await checkSum.crc64 (crc, buf.slice(0, readLen));
        readTotal+= readLen;
      }

      return crc;
    }

    return checkSum.crc64(crc, toCheck);
  }
}