import Credentials from '../../common/auth/Credentials';

export default class OSSSignerParams {
  private resourcePath: string;
  private credentials: Credentials;
  private product?: string;
  private region?: string;
  private tickOffset: number;
  private cloudBoxId?: string;
  private expiration?: Date;
  private additionalHeaderNames?: Set<string>;

  constructor(resourcePath: string, credentials: Credentials) {
    this.resourcePath = resourcePath;
    this.credentials = credentials;
    this.tickOffset = 0;
  }

  getResourcePath(): string {
    return this.resourcePath;
  }

  setResourcePath(resourcePath: string): void {
    this.resourcePath = resourcePath;
  }

  getCredentials(): Credentials {
    return this.credentials;
  }

  setCredentials(creds: Credentials): void {
    this.credentials = creds;
  }

  getProduct(): string | undefined {
    return this.product;
  }

  setProduct(product: string): void {
    this.product = product;
  }

  getRegion(): string | undefined {
    return this.region;
  }

  setRegion(region: string): void {
    this.region = region;
  }

  getTickOffset(): number {
    return this.tickOffset;
  }

  setTickOffset(tickOffset: number): void {
    this.tickOffset = tickOffset;
  }

  getCloudBoxId(): string | undefined {
    return this.cloudBoxId;
  }

  setCloudBoxId(cloudBoxId: string): void {
    this.cloudBoxId = cloudBoxId;
  }

  getExpiration(): Date | undefined {
    return this.expiration;
  }

  setExpiration(expiration: Date): void {
    this.expiration = expiration;
  }

  getAdditionalHeaderNames(): Set<string> {
    return this.additionalHeaderNames ?? new Set<string>();
  }

  setAdditionalHeaderNames(additionalHeaderNames: Set<string>): void {
    this.additionalHeaderNames = additionalHeaderNames;
  }
}
