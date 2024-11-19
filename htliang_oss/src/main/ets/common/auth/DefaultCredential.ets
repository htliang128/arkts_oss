import CommonConstant from '../CommonConstant';
import Credentials from './Credentials';

export default class DefaultCredentials implements Credentials {
  accessKeyId: string;
  accessKeySecret: string;
  securityToken: string;

  constructor(accessKeyId: string, secretAccessKey: string);

  constructor(accessKeyId: string, secretAccessKey: string, securityToken: string | undefined);

  constructor(accessKeyId: string, secretAccessKey: string, securityToken: string = CommonConstant.BLANK) {
    if (!accessKeyId) {
      throw new Error("Access key id should not be null or empty.");
    }
    if (!secretAccessKey) {
      throw new Error("Secret access key should not be null or empty.");
    }

    this.accessKeyId = accessKeyId;
    this.accessKeySecret = secretAccessKey;
    this.securityToken = securityToken ?? CommonConstant.BLANK;
  }

  getAccessKeyId(): string {
    return this.accessKeyId;
  }

  getSecretAccessKey(): string {
    return this.accessKeySecret;
  }

  getSecurityToken(): string {
    return this.securityToken ?? CommonConstant.BLANK;
  }

  useSecurityToken(): boolean {
    return this.securityToken.length > 0;
  }
}