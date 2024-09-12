import ICredentials from './Credentials';

interface CredentialsProvider {
  setCredentials(credentials: ICredentials): void;

  getCredentials(): ICredentials;
}
