import GenericResult from './GenericResult';
import Owner from './Owner';
import StorageClass from './StorageClass';

export class Bucket extends GenericResult {
  name?: string;
  owner?: Owner;
  location?: string;
  creationDate?: Date;
  storageClass: StorageClass = StorageClass.Standard;
  extranetEndpoint?: string;
  intranetEndpoint?: string;
  region?: string;
  hnsStatus?: string;
  resourceGroupId?: string;
  accessMonitor?: string;
  xcType?: string;

  constructor(name?: string, requestId?: string) {
    super();
    if (name) {
      this.setName(name);
    }
    if (requestId) {
      this.setRequestId(requestId);
    }
  }

  getOwner(): Owner | undefined {
    return this.owner;
  }

  setOwner(owner: Owner): void {
    this.owner = owner;
  }

  getCreationDate(): Date | undefined {
    return this.creationDate;
  }

  setCreationDate(creationDate: Date): void {
    this.creationDate = creationDate;
  }

  getName(): string | undefined {
    return this.name;
  }

  setName(name: string): void {
    this.name = name;
  }

  getLocation(): string | undefined {
    return this.location;
  }

  setLocation(location: string): void {
    this.location = location;
  }

  getStorageClass(): StorageClass {
    return this.storageClass;
  }

  setStorageClass(storageClass: StorageClass): void {
    this.storageClass = storageClass;
  }

  getExtranetEndpoint(): string | undefined {
    return this.extranetEndpoint;
  }

  setExtranetEndpoint(endpoint: string): void {
    this.extranetEndpoint = endpoint;
  }

  getIntranetEndpoint(): string | undefined {
    return this.intranetEndpoint;
  }

  setIntranetEndpoint(endpoint: string): void {
    this.intranetEndpoint = endpoint;
  }

  getRegion(): string | undefined {
    return this.region;
  }

  setRegion(region: string): void {
    this.region = region;
  }

  getHnsStatus(): string | undefined {
    return this.hnsStatus;
  }

  setHnsStatus(hnsStatus: string): void {
    this.hnsStatus = hnsStatus;
  }

  getResourceGroupId(): string | undefined {
    return this.resourceGroupId;
  }

  setResourceGroupId(resourceGroupId: string): void {
    this.resourceGroupId = resourceGroupId;
  }

  getXcType(): string | undefined {
    return this.xcType;
  }

  setXcType(xcType: string): void {
    this.xcType = xcType;
  }

  getAccessMonitor(): string | undefined {
    return this.accessMonitor;
  }

  setAccessMonitor(accessMonitor: string): void {
    this.accessMonitor = accessMonitor;
  }

  toString(): string {
    return `OSSBucket [name=${this.getName()}, creationDate=${this.getCreationDate()}, owner=${this.getOwner()}, location=${this.getLocation()}, storageClass=${this.getStorageClass()}]`;
  }
}
