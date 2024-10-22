import fs from '@ohos.file.fs';

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
}