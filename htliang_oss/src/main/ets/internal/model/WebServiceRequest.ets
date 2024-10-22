import ProgressListener, { NOOP } from '../../event/ProgressListener';

export abstract class WebServiceRequest {
  private progressListener: ProgressListener = NOOP;
  private logEnabled: boolean = true;
  private endpoint: string = '';
  private parameters: Map<string, string> = new Map<string, string>();
  private headers: Map<string, string> = new Map<string, string>();
  private additionalHeaderNames: Set<string> = new Set<string>();

  public setProgressListener(progressListener: ProgressListener): void {
    this.progressListener = progressListener ? progressListener : NOOP;
  }

  public getProgressListener(): ProgressListener {
    return this.progressListener;
  }

  public withProgressListener(progressListener: ProgressListener) {
    this.setProgressListener(progressListener);
    return this;
  }

  public getParameters(): Map<string, string> {
    return this.parameters;
  }

  public setParameters(parameters: Map<string, string>): void {
    this.parameters = parameters;
  }

  public addParameter(key: string, value: string): void {
    this.parameters.set(key, value);
  }

  public getHeaders(): Map<string, string> {
    return this.headers;
  }

  public setHeaders(headers: Map<string, string>): void {
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
