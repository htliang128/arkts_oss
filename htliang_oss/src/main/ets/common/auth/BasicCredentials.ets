import Credentials from './Credentials';

export default class BasicCredentials implements Credentials {
  accessKeyId: string = '';
  accessKeySecret: string = '';
  securityToken: string = '';
  expiredDurationSeconds: number;
  startedTimeInMilliSeconds: number = 0;
  expiredFactor: number = 0.8;

  withExpiredFactor(expiredFactor: number): BasicCredentials {
    this.expiredFactor = expiredFactor;
    return this;
  }

  withExpiredDuration(expiredDurationSeconds: number): BasicCredentials {
    this.expiredDurationSeconds = expiredDurationSeconds;
    return this;
  }

  getAccessKeyId(): string {
    return this.accessKeyId;
  }

  getSecretAccessKey(): string {
    return this.accessKeySecret;
  }

  getSecurityToken(): string {
    return this.securityToken;
  }

  useSecurityToken(): boolean {
    return this.securityToken.length > 0;
  }

  willSoonExpire(): boolean {
    if (this.expiredDurationSeconds === 0) {
      return false;
    }
    const now = Date.now();
    return this.expiredDurationSeconds * this.expiredFactor < (now - this.startedTimeInMilliSeconds) / 1000.0;
  }

  constructor(accessKeyId: string, accessKeySecret: string, securityToken: string, expiredDurationSeconds: number = 0) {
    this.accessKeyId = accessKeyId;
    this.accessKeySecret = accessKeySecret;
    this.securityToken = securityToken;
    this.expiredDurationSeconds = expiredDurationSeconds;
    this.startedTimeInMilliSeconds = Date.now();
  }
}