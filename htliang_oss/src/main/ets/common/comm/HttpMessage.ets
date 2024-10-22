import fs from '@ohos.file.fs';
import { TreeMap } from '@kit.ArkTS';

export default abstract class HttpMessage {
  private _headers: TreeMap<string, string> = new TreeMap<string, string>();

  public set headers(value: TreeMap<string, string>) {
    this._headers = value;
  }

  public get headers(): TreeMap<string, string> {
    return this._headers;
  }

  private _content: Promise<fs.Stream> | undefined;

  public set content(value: Promise<fs.Stream> | undefined) {
    this._content = value;
  }

  public get content(): Promise<fs.Stream> | undefined {
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