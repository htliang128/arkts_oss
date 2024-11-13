import Payer from './Payer';

class GenericRequest {
  private bucketName?: string;
  private key?: string;
  private versionId?: string;
  private payer?: Payer;

  constructor();

  constructor(bucketName: string);

  constructor(bucketName: string, key: string);

  constructor(bucketName: string, key: string, versionId: string);

  constructor(bucketName?: string, key?: string, versionId?: string) {
    this.bucketName = bucketName;
    this.key = key;
    this.versionId = versionId;
  }

  getBucketName(): string | undefined {
    return this.bucketName;
  }

  setBucketName(bucketName: string): void {
    this.bucketName = bucketName;
  }

  withBucketName(bucketName: string) {
    this.setBucketName(bucketName);
    return this;
  }

  getKey(): string | undefined {
    return this.key;
  }

  setKey(key: string): void {
    this.key = key;
  }

  withKey(key: string) {
    this.setKey(key);
    return this;
  }

  getVersionId(): string | undefined {
    return this.versionId;
  }

  setVersionId(versionId: string): void {
    this.versionId = versionId;
  }

  withVersionId(versionId: string) {
    this.setVersionId(versionId);
    return this;
  }

  getRequestPayer(): Payer | undefined {
    return this.payer;
  }

  setRequestPayer(payer: Payer): void {
    this.payer = payer;
  }

  withRequestPayer(payer: Payer) {
    this.setRequestPayer(payer);
    return this;
  }
}

export default GenericRequest;