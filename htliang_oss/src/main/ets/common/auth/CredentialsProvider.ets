import Credentials from './Credentials';

export default interface CredentialsProvider {
  setCredentials(credentials: Credentials): void;

  getCredentials(): Credentials;
}
