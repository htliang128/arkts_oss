import OSS from './OSS';
import Credentials from './common/auth/Credentials';
import { SignVersion } from './common/comm/SignVersion';
import PutObjectResult from './model/PutObjectResult';
import CredentialsProvider from './common/auth/CredentialsProvider';
import uri from '@ohos.uri';
import { ServiceClient } from './common/comm/SeviceClient';
import ClientConfiguration from './ClientConfiguration';
import PutObjectRequest from './model/PutObjectRequest';
import CodingUtils from './common/utils/CodingUtils';

export default class OSSClient implements OSS {
  credentialsProvider:CredentialsProvider;

  endpoint:uri.URI;

  serviceClient:ServiceClient;

  switchCredentials(credentials: Credentials): void {
    throw new Error('Method not implemented.');
  }

  switchSignatureVersion(signatureVersion: SignVersion): void {
    throw new Error('Method not implemented.');
  }

  shutdown(): void {
    throw new Error('Method not implemented.');
  }

  getConnectionPoolStats(): string {
    throw new Error('Method not implemented.');
  }

  putObject(putObjectRequest:PutObjectRequest): Promise<PutObjectResult> {
    CodingUtils.assertParameterNotNull(putObjectRequest, "putObjectRequest");


    throw new Error('Method not implemented.');
  }

  constructor(endpoint:string, credentialProvider:CredentialsProvider,clientConfiguration?:ClientConfiguration) {
    this.credentialsProvider = credentialProvider;
    clientConfiguration = clientConfiguration?? new ClientConfiguration();
    this.endpoint = new uri.URI(endpoint);
  }
}