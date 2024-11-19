import { http } from "@kit.NetworkKit";

export class RequestConfig {
  private readTimeout?: number;
  private connectTimeout?: number;
  private usingProxy?: http.HttpProxy;
  private userAgent?: string;

  constructor() {
  }

  // Getter and setter for readTimeout
  getReadTimeout(): number | undefined {
    return this.readTimeout;
  }

  setReadTimeout(value: number | undefined): void {
    this.readTimeout = value;
  }

  // Getter and setter for connectTimeout
  getConnectTimeout(): number | undefined {
    return this.connectTimeout;
  }

  setConnectTimeout(value: number | undefined): void {
    this.connectTimeout = value;
  }

  // Getter and setter for usingProxy
  getUsingProxy(): http.HttpProxy | undefined {
    return this.usingProxy;
  }

  setUsingProxy(value: http.HttpProxy | undefined): void {
    this.usingProxy = value;
  }

  // Getter and setter for userAgent
  getUserAgent(): string | undefined {
    return this.userAgent;
  }

  setUserAgent(value: string | undefined): void {
    this.userAgent = value;
  }
}