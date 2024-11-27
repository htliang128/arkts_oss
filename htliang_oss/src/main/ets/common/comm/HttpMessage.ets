import InputStream from '@htliang/java_type/src/main/ets/java/io/InputStream';
import { TreeMap } from '@kit.ArkTS';

export default abstract class HttpMessage {
  private headers: TreeMap<string, string> = new TreeMap<string, string>();
  private content?: InputStream;
  private contentLength: number = 0;

  public setHeaders(value: TreeMap<string, string>) {
    this.headers = value;
  }

  public getHeaders(): TreeMap<string, string> {
    return this.headers;
  }

  public addHeader(key: string, value: string): void {
    this.headers.set(key, value);
  }

  public setContent(value: InputStream | undefined) {
    this.content = value;
  }

  public getContent(): InputStream | undefined {
    return this.content;
  }


  public setContentLength(value: number) {
    this.contentLength = value;
  }

  public getContentLength(): number {
    return this.contentLength;
  }

  close() {
    if (this.content) {
      this.content.close();
      this.content = undefined;
    }
  }
}