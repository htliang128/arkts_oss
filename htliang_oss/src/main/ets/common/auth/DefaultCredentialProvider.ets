import Credentials from './Credentials';
import CredentialsProvider from './CredentialsProvider';
import DefaultCredentials from './DefaultCredential';

export default class DefaultCredentialProvider implements CredentialsProvider {
  credentials: Credentials;

  constructor(credentials: Credentials) {
    this.credentials = credentials;
  }

  static build(accessKeyId: string, secretAccessKey: string, securityToken?: string) {
    DefaultCredentialProvider.checkCredentials(accessKeyId, secretAccessKey);
    return new DefaultCredentialProvider(new DefaultCredentials(accessKeyId, secretAccessKey, securityToken))
  }

  static checkCredentials(accessKeyId: string, secretAccessKey: string) {
    if (!accessKeyId || accessKeyId.length == 0) {
      throw new Error("Access key id should not be null or empty.")
    }

    if (!secretAccessKey || secretAccessKey.length == 0) {
      throw new Error("Secret access key should not be null or empty.")
    }
  }

  setCredentials(credentials: Credentials): void {
    this.credentials = credentials;
  }

  getCredentials(): Credentials {
    return this.credentials;
  }
}