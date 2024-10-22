import CannedAccessControlList from './CannedAccessControlList';
import DataRedundancyType from './DataRedundancyType';
import GenericRequest from './GenericRequest';
import StorageClass from './StorageClass';

class CreateBucketRequest extends GenericRequest {
  private locationConstraint?: string;
  private cannedACL?: CannedAccessControlList;
  private storageClass?: StorageClass;
  private dataRedundancyType?: DataRedundancyType;
  private hnsStatus?: string;
  private resourceGroupId?: string;
  private xcType?: string;

  constructor(bucketName: string) {
    super(bucketName);
  }

  getLocationConstraint(): string | undefined {
    return this.locationConstraint;
  }

  setLocationConstraint(locationConstraint: string): void {
    this.locationConstraint = locationConstraint;
  }

  withLocationConstraint(locationConstraint: string) {
    this.setLocationConstraint(locationConstraint);
    return this;
  }

  getCannedACL(): CannedAccessControlList | undefined {
    return this.cannedACL;
  }

  setCannedACL(cannedACL: CannedAccessControlList): void {
    this.cannedACL = cannedACL;
  }

  withCannedACL(cannedACL: CannedAccessControlList) {
    this.setCannedACL(cannedACL);
    return this;
  }

  getStorageClass(): StorageClass | undefined {
    return this.storageClass;
  }

  setStorageClass(storageClass: StorageClass): void {
    this.storageClass = storageClass;
  }

  withStorageType(storageClass: StorageClass) {
    this.setStorageClass(storageClass);
    return this;
  }

  getDataRedundancyType(): DataRedundancyType | undefined {
    return this.dataRedundancyType;
  }

  setDataRedundancyType(dataRedundancyType: DataRedundancyType): void {
    this.dataRedundancyType = dataRedundancyType;
  }

  withDataRedundancyType(dataRedundancyType: DataRedundancyType) {
    this.setDataRedundancyType(dataRedundancyType);
    return this;
  }

  getHnsStatus(): string | undefined {
    return this.hnsStatus;
  }

  setHnsStatus(hnsStatus: string): void {
    this.hnsStatus = hnsStatus;
  }

  withHnsStatus(hnsStatus: string) {
    this.setHnsStatus(hnsStatus);
    return this;
  }

  getResourceGroupId(): string | undefined {
    return this.resourceGroupId;
  }

  setResourceGroupId(resourceGroupId: string): void {
    this.resourceGroupId = resourceGroupId;
  }

  withResourceGroupId(resourceGroupId: string) {
    this.setResourceGroupId(resourceGroupId);
    return this;
  }

  getXcType(): string | undefined {
    return this.xcType;
  }

  setXcType(xcType: string): void {
    this.xcType = xcType;
  }
}

export default CreateBucketRequest;
