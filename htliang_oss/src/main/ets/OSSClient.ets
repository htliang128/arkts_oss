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
import InputStream from '@htliang/java_type/src/main/ets/java/io/InputStream';
import { OSSUtils } from './internal/OSSUtils';
import OSSObjectOperation from './internal/OSSObjectOperation';
import DefaultCredentials from './common/auth/DefaultCredential';
import DefaultCredentialProvider from './common/auth/DefaultCredentialProvider';

export default class OSSClient implements OSS {
  private credsProvider: CredentialsProvider;
  private endpoint: uri.URI;
  private serviceClient: ServiceClient;
  // private bucketOperation: OSSBucketOperation;
  private objectOperation: OSSObjectOperation;

  // private multipartOperation: OSSMultipartOperation;
  // private corsOperation: CORSOperation;
  // private uploadOperation: OSSUploadOperation;
  // private downloadOperation: OSSDownloadOperation;
  // private liveChannelOperation: LiveChannelOperation;


  constructor(accessKeyId: string, secretAccessKey: string);

  constructor(endPoint: string, accessKeyId: string, secretAccessKey: string);

  constructor(endPoint: string, accessKeyId: string, secretAccessKey: string, config: ClientConfiguration);

  constructor(endPoint: string, accessKeyId: string, secretAccessKey: string, securityToken: string);

  constructor(endPoint: string, accessKeyId: string, secretAccessKey: string, securityToken: string,
    config: ClientConfiguration);

  constructor(endPoint: string, credsProvider: CredentialsProvider);

  constructor(endPoint: string, credsProvider: CredentialsProvider, config: ClientConfiguration);

  constructor(arg1: string, arg2: string | CredentialsProvider, arg3?: string | ClientConfiguration,
    arg4?: string | ClientConfiguration,
    arg5?: ClientConfiguration) {
    if (typeof arg2 !== 'string') {
      this.credsProvider = arg2;
      let config = arg3 ? arg3 as ClientConfiguration : new ClientConfiguration();
      if (config.isRequestTimeoutEnabled()) {
        this.serviceClient = new Timeout
      }
    }
  }

  setEndpoint(endpoint: string) {
    let uri = this.toURI(endpoint);
    this.endpoint = uri;
    OSSUtils.ensureEndpointValid(uri.host);

    if (this.isIpOrLocalhost(uri)) {
      this.serviceClient.getClientConfiguration().setSLDEnabled(true);
    }

    // this.bucketOperation.setEndpoint(uri);
    this.objectOperation.setEndpoint(uri);
    // this.multipartOperation.setEndpoint(uri);
    // this.corsOperation.setEndpoint(uri);
    // this.liveChannelOperation.setEndpoint(uri);
  }

  /**
   * Checks if the uri is an IP or domain. If it's IP or local host, then it
   * will use secondary domain of Alibaba cloud. Otherwise, it will use domain
   * directly to access the OSS.
   *
   * @param uri
   *            URI。
   */
  private isIpOrLocalhost(uri: uri.URI) {
    let host = uri.host;
    return this.isIPv4(host) || this.isIPv6(host) || host === "localhost";
  }

  private isCloudBoxEndpointSuffix(uri: uri.URI): boolean {
    let host = uri.host;
    return (
      host.endsWith('oss-cloudbox.aliyuncs.com') ||
      host.endsWith('oss-cloudbox-control.aliyuncs.com')
    );
  }

  private isIPv4(host: string): boolean {
    const ipv4Regex =
      /^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/;
    return ipv4Regex.test(host);
  }

  private isIPv6(host: string): boolean {
    const ipv6Regex =
      /^(([0-9a-fA-F]{1,4}:){7,7}[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,7}:|([0-9a-fA-F]{1,4}:){1,6}:[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,5}(:[0-9a-fA-F]{1,4}){1,2}|([0-9a-fA-F]{1,4}:){1,4}(:[0-9a-fA-F]{1,4}){1,3}|([0-9a-fA-F]{1,4}:){1,3}(:[0-9a-fA-F]{1,4}){1,4}|([0-9a-fA-F]{1,4}:){1,2}(:[0-9a-fA-F]{1,4}){1,5}|[0-9a-fA-F]{1,4}:((:[0-9a-fA-F]{1,4}){1,6})|:((:[0-9a-fA-F]{1,4}){1,7}|:)|fe80:(:[0-9a-fA-F]{0,4}){0,4}%[0-9a-zA-Z]{1,}|::(ffff(:0{1,4}){0,1}:){0,1}((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3,3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)|([0-9a-fA-F]{1,4}:){1,4}:((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3,3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?))$/;
    return ipv6Regex.test(host);
  }


  private toURI(endpoint: string): uri.URI {
    this.serviceClient
    return OSSUtils.toEndpointURI(endpoint, this.serviceClient.getClientConfiguration().getProtocol().toString())
  }

  private initOperations(): void {
    // this.bucketOperation = new OSSBucketOperation(this.serviceClient, this.credsProvider);
    this.objectOperation = new OSSObjectOperation(this.serviceClient, this.credsProvider);
    // this.multipartOperation = new OSSMultipartOperation(this.serviceClient, this.credsProvider);
    // this.corsOperation = new CORSOperation(this.serviceClient, this.credsProvider);
    // this.uploadOperation = new OSSUploadOperation(this.multipartOperation);
    // this.downloadOperation = new OSSDownloadOperation(objectOperation);
    // this.liveChannelOperation = new LiveChannelOperation(this.serviceClient, this.credsProvider);
  }

  private setSignatureVersionInner(version: SignVersion): void {
    // this.bucketOperation.setSignVersion(version);
    this.objectOperation.setSignVersion(version);
    // this.multipartOperation.setSignVersion(version);
    // this.corsOperation.setSignVersion(version);
    // this.liveChannelOperation.setSignVersion(version);
  }

  public setProduct(product: string): void {
    // this.bucketOperation.setProduct(product);
    this.objectOperation.setProduct(product);
    // this.multipartOperation.setProduct(product);
    // this.corsOperation.setProduct(product);
    // this.liveChannelOperation.setProduct(product);
  }


  public setRegion(region: string): void {
    // this.bucketOperation.setRegion(region);
    this.objectOperation.setRegion(region);
    // this.multipartOperation.setRegion(region);
    // this.corsOperation.setRegion(region);
    // this.liveChannelOperation.setRegion(region);
  }

  public setCloudBoxId(cloudBoxId: string): void {
    // this.bucketOperation.setCloudBoxId(cloudBoxId);
    this.objectOperation.setCloudBoxId(cloudBoxId);
    // this.multipartOperation.setCloudBoxId(cloudBoxId);
    // this.corsOperation.setCloudBoxId(cloudBoxId);
    // this.liveChannelOperation.setCloudBoxId(cloudBoxId);
  }


  // constructor(arg1:string, credentialProvider:CredentialsProvider,clientConfiguration?:ClientConfiguration) {
  //   this.credentialsProvider = credentialProvider;
  //   clientConfiguration = clientConfiguration?? new ClientConfiguration();
  //   this.endpoint = new uri.URI(endpoint);
  // }


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

  putObject(request: PutObjectRequest): PutObjectResult;

  putObject(bucketName: string, key: string, input: InputStream): PutObjectResult;

  putObject(bucketName: PutObjectRequest | string, key?: string, input?: InputStream): PutObjectResult {
    throw new Error('Method not implemented.');
  }
}