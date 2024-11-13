import { common } from "@kit.AbilityKit";
import fs from '@ohos.file.fs'
import { buffer } from "@kit.ArkTS";

export default class FileUtil {
  public static resolePath(path: string, subPath: string) {
    if (subPath.endsWith('/')) {
      subPath = subPath.substring(0, subPath.length - 1);
    }
    if (subPath.startsWith('/')) {
      subPath = subPath.substring(1, subPath.length);
    }
    if (path.endsWith('/')) {
      path = path.substring(0, path.length - 1);
    }

    return `${path}${subPath == '' ? '' : '/'}${subPath}`;
  }

  public static getFileExtension(filename: string, includePot: boolean = false): string {
    const parts = filename.split('.');
    let extension = parts.length > 1 ? parts.pop()! : '';
    if (!includePot) {
      return extension;
    }
    return extension == '' ? extension : `.${extension}`;
  }

  public static getFilePath(ctx: common.Context, subPath: string) {
    if (subPath.endsWith('/')) {
      subPath = subPath.substring(0, subPath.length - 1);
    }
    if (subPath.startsWith('/')) {
      subPath = subPath.substring(1, subPath.length);
    }
    return `${ctx.filesDir}${subPath == '' ? '' : '/'}${subPath}`;
  }

  public static createFile(filePath: string) {
    let file = fs.openSync(filePath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
    fs.writeSync(file.fd, new ArrayBuffer(0));
    fs.closeSync(file);
  }

  public static getResourcePath(ctx: common.UIAbilityContext, subPath: string) {
    return `${ctx.resourceDir}/${subPath}`;
  }

  public static isFileExist(filePath: string): boolean {
    try {
      return fs.accessSync(filePath, fs.AccessModeType.EXIST);
    } catch (ignore) {
      return false;
    }
  }

  public static isFile(path:string): boolean {
    return fs.statSync(path).isFile();
  }

  public static cloneFile(fromPath: string, toPath: string) {
    if (!FileUtil.isFileExist(toPath)) {
      FileUtil.createFile(toPath);
    }

    let fromFile = fs.openSync(fromPath, fs.OpenMode.READ_ONLY);
    let toFile = fs.openSync(toPath, fs.OpenMode.READ_WRITE);

    fs.copyFileSync(fromFile.fd, toFile.fd);

    fs.closeSync(fromFile);
    fs.closeSync(toFile);
  }

  public static getFileName(filePath: string): string {
    let file = fs.openSync(filePath);
    let fileName = file.name;
    fs.closeSync(file);
    return fileName;
  }

  // please make sure the file exist firstly
  public static readText(filePath: string): string {
    let buf = FileUtil.readBin(filePath);

    return buffer.from(buf).toString('utf-8')
  }

  // please make sure the file exist firstly
  public static readBin(filePath: string): ArrayBuffer {
    let file: fs.File | undefined;
    try {
      file = fs.openSync(filePath, fs.OpenMode.READ_ONLY);
      let fileSize = fs.statSync(file.fd).size;
      let buf = new ArrayBuffer(fileSize);
      fs.readSync(file.fd, buf, {
        offset: 0, length: fileSize
      });
      return buf;
    } finally {
      if (file) {
        fs.closeSync(file)
      }
    }
  }
}