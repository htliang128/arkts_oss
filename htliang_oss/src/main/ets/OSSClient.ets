import OSS from './OSS';
import Credentials from './common/auth/Credentials';
import { SignVersion } from './common/comm/SignVersion';
import PutObjectResult from './model/PutObjectResult';
import CredentialsProvider from './common/auth/CredentialsProvider';
import uri from '@ohos.uri';
import { ServiceClient } from './common/comm/SeviceClient';
import ClientConfiguration from './ClientConfiguration';
import PutObjectRequest from './model/PutObjectRequest';
import InputStream from '@htliang/java_type/src/main/ets/java/io/InputStream';
import { OSSUtils } from './internal/OSSUtils';
import OSSObjectOperation from './internal/OSSObjectOperation';
import DefaultCredentialProvider from './common/auth/DefaultCredentialProvider';
import DefaultServiceClient from './common/comm/DefaultServiceClient';
import OSSConstants from './internal/OSSConstants';
import LogUtils from './common/utils/LogUtils';

export default class OSSClient implements OSS {
  private credsProvider: CredentialsProvider;
  private endpoint?: uri.URI;
  private serviceClient: ServiceClient;
  // private bucketOperation: OSSBucketOperation;
  private objectOperation?: OSSObjectOperation;

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
    if (!arg3) {
      if (typeof arg2 === 'string') {
        this.credsProvider = new DefaultCredentialProvider(arg1, arg2);
        this.serviceClient = new DefaultServiceClient(new ClientConfiguration());
        this.initOperations();
        this.setEndpoint(OSSConstants.DEFAULT_OSS_ENDPOINT);
        this.initDefaultsByEndpoint();
        return;
      }
      this.credsProvider = arg2;
      this.serviceClient = new DefaultServiceClient(new ClientConfiguration());
      ;
      this.initOperations();
      this.setEndpoint(arg1);
      this.initDefaultsByEndpoint();
      return;
    }

    if (!arg4) {
      if (typeof arg3 === 'string') {
        this.credsProvider = new DefaultCredentialProvider(arg2 as string, arg3);
        this.serviceClient = new DefaultServiceClient(new ClientConfiguration());
        this.initOperations();
        this.setEndpoint(arg1);
        this.initDefaultsByEndpoint();
        return;
      }
      this.credsProvider = arg2 as CredentialsProvider;
      this.serviceClient = new DefaultServiceClient(arg3);
      this.initOperations();
      this.setEndpoint(arg1);
      this.initDefaultsByEndpoint();
      return;
    }

    if (!arg5) {
      if (typeof arg4 === 'string') {
        this.credsProvider = new DefaultCredentialProvider(arg2 as string, arg3 as string, arg4);
        this.serviceClient = new DefaultServiceClient(new ClientConfiguration());
        this.initOperations();
        this.setEndpoint(arg1);
        this.initDefaultsByEndpoint();
        return;
      }
      this.credsProvider = new DefaultCredentialProvider(arg2 as string, arg3 as string);
      this.serviceClient = new DefaultServiceClient(arg4);
      this.initOperations();
      this.setEndpoint(arg1);
      this.initDefaultsByEndpoint();
      return;
    }

    this.credsProvider = new DefaultCredentialProvider(arg2 as string, arg3 as string, arg4 as string);
    this.serviceClient = new DefaultServiceClient(arg5);
    this.initOperations();
    this.setEndpoint(arg1);
    this.initDefaultsByEndpoint();
  }

  private initDefaultsByEndpoint() {
    if (!this.serviceClient.getClientConfiguration().isExtractSettingFromEndpointEnable()) {
      return;
    }

    if (!this.endpoint) {
      return;
    }

    //cloud box endpoint pattern: cloudbox-id.region.oss-cloudbox[-control].aliyuncs.com
    //cloudbox-id start with cb-
    if (this.isCloudBoxEndpointSuffix(this.endpoint)) {
      let host = this.endpoint.host;
      let keys = host.split('.');
      if (keys.length == 5) {
        if (keys[0].startsWith("cb-")) {
          this.setCloudBoxId(keys[0]);
          this.setRegion(keys[1]);
          this.setProduct(OSSConstants.PRODUCT_CLOUD_BOX);
          if (SignVersion.V4 > this.serviceClient.getClientConfiguration().getSignatureVersion()) {
            this.setSignatureVersionInner(SignVersion.V4);
          }
        }
      }
    }
  }

  private setEndpoint(endpoint: string) {
    let uri = this.toURI(endpoint);
    this.endpoint = uri;
    OSSUtils.ensureEndpointValid(uri.host);

    if (this.isIpOrLocalhost(uri)) {
      this.serviceClient.getClientConfiguration().setSLDEnabled(true);
    }

    // this.bucketOperation.setEndpoint(uri);
    this.objectOperation?.setEndpoint(uri);
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
    this.objectOperation?.setSignVersion(version);
    // this.multipartOperation.setSignVersion(version);
    // this.corsOperation.setSignVersion(version);
    // this.liveChannelOperation.setSignVersion(version);
  }

  public setProduct(product: string): void {
    // this.bucketOperation.setProduct(product);
    this.objectOperation?.setProduct(product);
    // this.multipartOperation.setProduct(product);
    // this.corsOperation.setProduct(product);
    // this.liveChannelOperation.setProduct(product);
  }


  public setRegion(region: string): void {
    // this.bucketOperation.setRegion(region);
    this.objectOperation?.setRegion(region);
    // this.multipartOperation.setRegion(region);
    // this.corsOperation.setRegion(region);
    // this.liveChannelOperation.setRegion(region);
  }

  public setCloudBoxId(cloudBoxId: string): void {
    // this.bucketOperation.setCloudBoxId(cloudBoxId);
    this.objectOperation?.setCloudBoxId(cloudBoxId);
    // this.multipartOperation.setCloudBoxId(cloudBoxId);
    // this.corsOperation.setCloudBoxId(cloudBoxId);
    // this.liveChannelOperation.setCloudBoxId(cloudBoxId);
  }

  public switchCredentials(credentials: Credentials): void {
    this.credsProvider.setCredentials(credentials);
  }

  public switchSignatureVersion(signatureVersion: SignVersion): void {
    this.getClientConfiguration().setSignatureVersion(signatureVersion);
  }

  public getCredentialsProvider(): CredentialsProvider {
    return this.credsProvider;
  }

  public getClientConfiguration(): ClientConfiguration {
    return this.serviceClient.getClientConfiguration();
  }

  public shutdown(): void {
    try {
      this.serviceClient.shutdown();
    } catch (e) {
      LogUtils.logException("shutdown throw exception: ", e);
    }
  }

  public getConnectionPoolStats(): string {
    try {
      return this.serviceClient.getConnectionPoolStats();
    } catch (e) {
    }
    return "";
  }

  public putObject(request: PutObjectRequest): PutObjectResult{
    this.objectOperation?.putObject(request);
  }

  // public putObject(bucketName: string, key: string, input: InputStream): PutObjectResult;
  //
  // public putObject(bucketName: PutObjectRequest | string, key?: string, input?: InputStream): PutObjectResult {
  //   throw new Error('Method not implemented.');
  // }
}