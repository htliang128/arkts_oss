import { TreeMap } from '@kit.ArkTS';
import { http } from '@kit.NetworkKit';

export abstract class WebServiceRequest {
  // private progressListener: ProgressListener = NOOP;
  private sendProgressCallBack?: Callback<http.DataSendProgressInfo>;
  private receiveProgressCallback?: Callback<http.DataReceiveProgressInfo>;
  private logEnabled: boolean = true;
  private endpoint: string = '';
  private parameters: TreeMap<string, string> = new TreeMap<string, string>();
  private headers: TreeMap<string, string> = new TreeMap<string, string>();
  private additionalHeaderNames: Set<string> = new Set<string>();

  public getSendProgressCallBack(): Callback<http.DataSendProgressInfo> | undefined {
    return this.sendProgressCallBack;
  }

  public setSendProgressCallBack(sendProgressCallback: Callback<http.DataSendProgressInfo> | undefined): void {
    this.sendProgressCallBack = sendProgressCallback;
  }

  public getReceiveProgressCallback(): Callback<http.DataReceiveProgressInfo> | undefined {
    return this.receiveProgressCallback;
  }

  public setReceiveProgressCallBack(receiveProgressCallback: Callback<http.DataReceiveProgressInfo> | undefined): void {
    this.receiveProgressCallback = receiveProgressCallback;
  }


  // public setProgressListener(progressListener: ProgressListener): void {
  //   this.progressListener = progressListener ? progressListener : NOOP;
  // }
  //
  // public getProgressListener(): ProgressListener {
  //   return this.progressListener;
  // }
  //
  // public withProgressListener(progressListener: ProgressListener) {
  //   this.setProgressListener(progressListener);
  //   return this;
  // }

  public getParameters(): TreeMap<string, string> {
    return this.parameters;
  }

  public setParameters(parameters: TreeMap<string, string>): void {
    this.parameters = parameters;
  }

  public addParameter(key: string, value: string): void {
    this.parameters.set(key, value);
  }

  public getHeaders(): TreeMap<string, string> {
    return this.headers;
  }

  public setHeaders(headers: TreeMap<string, string>): void {
    this.headers = headers;
  }

  public addHeader(key: string, value: string): void {
    this.headers.set(key, value);
  }

  public getAdditionalHeaderNames(): Set<string> {
    return this.additionalHeaderNames;
  }

  public setAdditionalHeaderNames(additionalHeaderNames: Set<string>): void {
    this.additionalHeaderNames = additionalHeaderNames;
  }

  public addAdditionalHeaderName(name: string): void {
    this.additionalHeaderNames.add(name);
  }

  public isLogEnabled(): boolean {
    return this.logEnabled;
  }

  public setLogEnabled(logEnabled: boolean): void {
    this.logEnabled = logEnabled;
  }

  public getEndpoint(): string {
    return this.endpoint;
  }

  public setEndpoint(endpoint: string): void {
    this.endpoint = endpoint;
  }
}
