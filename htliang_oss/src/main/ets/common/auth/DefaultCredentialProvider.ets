import Credentials from './Credentials';
import CredentialsProvider from './CredentialsProvider';
import DefaultCredentials from './DefaultCredential';

export default class DefaultCredentialProvider implements CredentialsProvider {
  credentials: Credentials;

  constructor(credentials: Credentials);

  constructor(accessKeyId: string, secretAccessKey: string);

  constructor(accessKeyId: string, secretAccessKey: string, securityToken: string);

  constructor(arg: Credentials | string, secretAccessKey?: string, securityToken?: string) {
    if (!secretAccessKey) {
      let credentials = arg as Credentials;
      DefaultCredentialProvider.checkCredentials(credentials.getAccessKeyId(), credentials.getSecretAccessKey());
      this.credentials = credentials;
      return;
    }

    let accessKeyId = arg as string;
    DefaultCredentialProvider.checkCredentials(accessKeyId, secretAccessKey);
    this.credentials = new DefaultCredentials(accessKeyId, secretAccessKey, securityToken);
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