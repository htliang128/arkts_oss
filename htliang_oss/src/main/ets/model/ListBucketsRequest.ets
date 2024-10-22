import { WebServiceRequest } from '../internal/model/WebServiceRequest';


class ListBucketsRequest extends WebServiceRequest {
  static readonly MAX_RETURNED_KEYS = 1000;
  private prefix?: string;
  private marker?: string;
  private maxKeys?: number;
  private bid?: string;
  private tagKey?: string;
  private tagValue?: string;
  private resourceGroupId?: string;

  constructor(prefix?: string, marker?: string, maxKeys?: number) {
    super();
    this.prefix = prefix;
    this.marker = marker;
    if (maxKeys !== undefined) {
      this.setMaxKeys(maxKeys);
    }
  }

  getPrefix(): string | undefined {
    return this.prefix;
  }

  setPrefix(prefix: string): void {
    this.prefix = prefix;
  }

  withPrefix(prefix: string): ListBucketsRequest {
    this.setPrefix(prefix);
    return this;
  }

  getMarker(): string | undefined {
    return this.marker;
  }

  setMarker(marker: string): void {
    this.marker = marker;
  }

  withMarker(marker: string): ListBucketsRequest {
    this.setMarker(marker);
    return this;
  }

  getMaxKeys(): number | undefined {
    return this.maxKeys;
  }

  setMaxKeys(maxKeys: number): void {
    if (maxKeys < 0 || maxKeys > ListBucketsRequest.MAX_RETURNED_KEYS) {
      throw new Error("The max keys should be not be less than 0 or greater than 1000.");
    }
    this.maxKeys = maxKeys;
  }

  withMaxKeys(maxKeys: number): ListBucketsRequest {
    this.setMaxKeys(maxKeys);
    return this;
  }

  setBid(bid: string): void {
    this.bid = bid;
  }

  getBid(): string | undefined {
    return this.bid;
  }

  setTag(tagKey: string, tagValue: string): void {
    this.tagKey = tagKey;
    this.tagValue = tagValue;
  }

  getTagKey(): string | undefined {
    return this.tagKey;
  }

  getTagValue(): string | undefined {
    return this.tagValue;
  }

  getResourceGroupId(): string | undefined {
    return this.resourceGroupId;
  }

  setResourceGroupId(resourceGroupId: string): void {
    this.resourceGroupId = resourceGroupId;
  }

  withResourceGroupId(resourceGroupId: string): ListBucketsRequest {
    this.setResourceGroupId(resourceGroupId);
    return this;
  }
}

export default ListBucketsRequest;