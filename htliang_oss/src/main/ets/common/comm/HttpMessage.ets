import fs from '@ohos.file.fs';
import { TreeMap } from '@kit.ArkTS';
import InputStream from '@htliang/java_type/src/main/ets/java/io/InputStream';

export default abstract class HttpMessage {
  private _headers: TreeMap<string, string> = new TreeMap<string, string>();

  public set headers(value: TreeMap<string, string>) {
    this._headers = value;
  }

  public get headers(): TreeMap<string, string> {
    return this._headers;
  }

  private _content: InputStream | undefined;

  public set content(value: InputStream | undefined) {
    this._content = value;
  }

  public get content(): InputStream | undefined {
    return this._content;
  }

  private _contentLength: number = 0;

  public set contentLength(value: number) {
    this._contentLength = value;
  }

  public get contentLength(): number {
    return this._contentLength;
  }

  public addHeader(key: string, value: string): void {
    this.headers.set(key, value);
  }

  close() {
    if (this._content != null) {
      // this.content.close();
      // this.content = null;
    }
  }
}