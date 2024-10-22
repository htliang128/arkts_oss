import { CallbackBodyType } from './CallbackBodyType';


export default class CallbackInfo {
  private callbackUrl?: string;
  private callbackHost?: string;
  private callbackBody?: string;
  private callbackBodyType?: CallbackBodyType;
  private callbackVar: Map<string, string> = new Map();
  private callbackSNI: boolean = false;

  getCallbackUrl(): string | undefined {
    return this.callbackUrl;
  }

  setCallbackUrl(callbackUrl: string): void {
    this.callbackUrl = callbackUrl;
  }

  getCallbackHost(): string | undefined {
    return this.callbackHost;
  }

  setCallbackHost(callbackHost: string): void {
    this.callbackHost = callbackHost;
  }

  getCallbackBody(): string | undefined {
    return this.callbackBody;
  }

  setCallbackBody(callbackBody: string): void {
    this.callbackBody = callbackBody;
  }

  getCallbackBodyType(): CallbackBodyType | undefined {
    return this.callbackBodyType;
  }

  setCallbackBodyType(callbackBodyType: CallbackBodyType): void {
    this.callbackBodyType = callbackBodyType;
  }

  getCallbackVar(): Map<string, string> {
    return this.callbackVar;
  }

  setCallbackVar(callbackVar: Map<string, string>): void {
    this.callbackVar.clear();
    callbackVar.forEach((value, key) => {
      this.callbackVar.set(key, value);
    });
  }

  addCallbackVar(key: string, value: string): void {
    this.callbackVar.set(key, value);
  }

  hasCallbackVar(): boolean {
    return this.callbackVar.size > 0;
  }

  getCallbackSNI(): boolean {
    return this.callbackSNI;
  }

  setCallbackSNI(callbackSNI: boolean): void {
    this.callbackSNI = callbackSNI;
  }
}