import ClientConfiguration from './ClientConfiguration';
import CredentialsProvider from './common/auth/CredentialsProvider';
import { SignVersion } from './common/comm/SignVersion';
import CodingUtils from './common/utils/CodingUtils';
import OSSConstants from './internal/OSSConstants';
import OSS from './OSS';
import OSSClient from './OSSClient';

export default class OSSClientBuilder {
  private endpoint?: string;
  private credentialsProvider?: CredentialsProvider;
  private clientConfiguration: ClientConfiguration;
  private region?: string;
  private cloudBoxId?: string;

  constructor() {
    this.clientConfiguration = new ClientConfiguration();
  }

  public withEndpoint(endpoint: string): OSSClientBuilder {
    this.endpoint = endpoint;
    return this;
  }

  public withCredentialsProvider(credentialsProvider: CredentialsProvider): OSSClientBuilder {
    this.credentialsProvider = credentialsProvider;
    return this;
  }

  public withClientConfiguration(clientConfiguration: ClientConfiguration): OSSClientBuilder {
    this.clientConfiguration = clientConfiguration;
    return this;
  }

  public withRegion(region: string): OSSClientBuilder {
    this.region = region;
    return this;
  }

  public withCloudBoxId(cloudBoxId: string): OSSClientBuilder {
    this.cloudBoxId = cloudBoxId;
    return this;
  }

  public static create(): OSSClientBuilder {
    return new OSSClientBuilder();
  }


  public build(): OSS {
    if (!this.endpoint || !this.credentialsProvider || !this.credentialsProvider) {
      throw new Error(`build OssClient fail for empty params, endPoint:${this.endpoint}, credentialsProvider:${this.credentialsProvider}, clientConfiguration:${this.clientConfiguration}`);
    }

    if (SignVersion.V4 === this.clientConfiguration.getSignatureVersion()) {
      CodingUtils.assertParameterNotNull(this.region, "region");
    }
    let client = new OSSClient(this.endpoint, this.credentialsProvider, this.clientConfiguration);
    if (this.region) {
      client.setRegion(this.region);
    }
    if (this.cloudBoxId) {
      client.setProduct(OSSConstants.PRODUCT_CLOUD_BOX);
      client.setCloudBoxId(this.cloudBoxId);
    }
    return client;
  }
}