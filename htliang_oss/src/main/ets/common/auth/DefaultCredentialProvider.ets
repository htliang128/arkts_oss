import Credentials from './Credentials';
import CredentialsProvider from './CredentialsProvider';
import DefaultCredentials from './DefaultCredential';

export default class DefaultCredentialProvider implements CredentialsProvider {
  credentials: Credentials;

  constructor(credentials: Credentials);

  constructor(accessKeyId: string, secretAccessKey: string);

  constructor(accessKeyId: string, secretAccessKey: string, securityToken: string);

  constructor(arg: Credentials | string, secretAccessKey?: string, securityToken?: string) {
    if (typeof arg !== 'string') {
      DefaultCredentialProvider.checkCredentials(arg.getAccessKeyId(), arg.getSecretAccessKey());
      this.credentials = arg;
      return;
    }
    DefaultCredentialProvider.checkCredentials(arg, secretAccessKey);
    this.credentials = new DefaultCredentials(arg, secretAccessKey, securityToken);
  }

  static build(accessKeyId: string, secretAccessKey: string, securityToken?: string) {
    DefaultCredentialProvider.checkCredentials(accessKeyId, secretAccessKey);
    return new DefaultCredentialProvider(new DefaultCredentials(accessKeyId, secretAccessKey, securityToken))
  }

  static checkCredentials(accessKeyId: string, secretAccessKey?: string) {
    if (!accessKeyId || accessKeyId.length == 0) {
      throw new Error("Access key id should not be null or empty.")
    }

    if (!secretAccessKey || secretAccessKey.length == 0) {
      throw new Error("Secret access key should not be null or empty.")
    }
  }

  setCredentials(credentials: Credentials): void {
    DefaultCredentialProvider.checkCredentials(credentials.accessKeyId, credentials.accessKeySecret);
    this.credentials = credentials;
  }

  getCredentials(): Credentials {
    return this.credentials;
  }
}