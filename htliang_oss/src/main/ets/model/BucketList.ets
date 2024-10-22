import { Bucket } from './Bucket';
import GenericResult from './GenericResult';

class BucketList extends GenericResult {
  private buckets: Bucket[] = [];
  private prefix: string | undefined;
  private marker: string | undefined;
  private maxKeys: number | undefined;
  private truncated: boolean = false;
  private nextMarker: string | undefined;

  getBucketList(): Bucket[] {
    return this.buckets;
  }

  setBucketList(buckets: Bucket[]): void {
    this.buckets = buckets ? [...buckets] : [];
  }

  clearBucketList(): void {
    this.buckets = [];
  }

  getPrefix(): string | undefined {
    return this.prefix;
  }

  setPrefix(prefix: string): void {
    this.prefix = prefix;
  }

  getMarker(): string | undefined {
    return this.marker;
  }

  setMarker(marker: string): void {
    this.marker = marker;
  }

  getMaxKeys(): number | undefined {
    return this.maxKeys;
  }

  setMaxKeys(maxKeys: number): void {
    this.maxKeys = maxKeys;
  }

  isTruncated(): boolean {
    return this.truncated;
  }

  setTruncated(truncated: boolean): void {
    this.truncated = truncated;
  }

  getNextMarker(): string | undefined {
    return this.nextMarker;
  }

  setNextMarker(nextMarker: string): void {
    this.nextMarker = nextMarker;
  }
}

export default BucketList;
