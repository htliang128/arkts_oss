import { TreeMap } from '@kit.ArkTS';
import DateUtil from '../common/utils/DateUtil';
import OSSHeaders from '../internal/OSSHeaders';
import SignV2Utils from '../internal/SignV2Utils';
import StorageClass from './StorageClass';

export default class ObjectMetadata {
  private userMetadata: TreeMap<string, string> = new TreeMap();
  private metadata: TreeMap<string, ESObject> = new TreeMap();

  getUserMetadata(): TreeMap<string, string> {
    return this.userMetadata;
  }

  setUserMetadata(userMetadata: TreeMap<string, string>): void {
    this.userMetadata.clear();
    userMetadata.forEach((value, key) => {
      this.userMetadata.set(key, value);
    });
  }

  setHeader(key: string, value: ESObject): void {
    this.metadata.set(key, value);
  }

  removeHeader(key: string): void {
    this.metadata.remove(key);
  }

  addUserMetadata(key: string, value: string): void {
    this.userMetadata.set(key, value);
  }

  getLastModified(): Date | undefined {
    return this.metadata.get(OSSHeaders.LAST_MODIFIED);
  }

  setLastModified(lastModified: Date): void {
    this.metadata.set(OSSHeaders.LAST_MODIFIED, lastModified);
  }

  getExpirationTime(): Date | undefined {
    const expires: ESObject = this.metadata.get(OSSHeaders.EXPIRES);
    return expires ? DateUtil.parseRfc822Date(expires) : undefined;
  }

  getRawExpiresValue(): string | undefined {
    return this.metadata.get(OSSHeaders.EXPIRES);
  }

  setExpirationTime(expirationTime: Date): void {
    this.metadata.set(OSSHeaders.EXPIRES, DateUtil.formatRfc822Date(expirationTime));
  }

  getContentLength(): number {
    const contentLength: ESObject = this.metadata.get(OSSHeaders.CONTENT_LENGTH);
    return contentLength !== undefined ? parseInt(contentLength) : 0;
  }

  setContentLength(contentLength: number): void {
    this.metadata.set(OSSHeaders.CONTENT_LENGTH, contentLength);
  }

  getContentType(): string | undefined {
    return this.metadata.get(OSSHeaders.CONTENT_TYPE);
  }

  setContentType(contentType: string): void {
    this.metadata.set(OSSHeaders.CONTENT_TYPE, contentType);
  }

  getContentMD5(): string | undefined {
    return this.metadata.get(OSSHeaders.CONTENT_MD5);
  }

  setContentMD5(contentMD5: string): void {
    this.metadata.set(OSSHeaders.CONTENT_MD5, contentMD5);
  }

  getContentEncoding(): string | undefined {
    return this.metadata.get(OSSHeaders.CONTENT_ENCODING);
  }

  setContentEncoding(encoding: string): void {
    this.metadata.set(OSSHeaders.CONTENT_ENCODING, encoding);
  }

  getCacheControl(): string | undefined {
    return this.metadata.get(OSSHeaders.CACHE_CONTROL);
  }

  setCacheControl(cacheControl: string): void {
    this.metadata.set(OSSHeaders.CACHE_CONTROL, cacheControl);
  }

  getContentDisposition(): string | undefined {
    return this.metadata.get(OSSHeaders.CONTENT_DISPOSITION);
  }

  setContentDisposition(disposition: string): void {
    this.metadata.set(OSSHeaders.CONTENT_DISPOSITION, disposition);
  }

  getETag(): string | undefined {
    return this.metadata.get(OSSHeaders.ETAG);
  }

  getServerSideEncryption(): string | undefined {
    return this.metadata.get(OSSHeaders.OSS_SERVER_SIDE_ENCRYPTION);
  }

  setServerSideEncryption(serverSideEncryption: string): void {
    this.metadata.set(OSSHeaders.OSS_SERVER_SIDE_ENCRYPTION, serverSideEncryption);
  }

  getServerSideEncryptionKeyId(): string | undefined {
    return this.metadata.get(OSSHeaders.OSS_SERVER_SIDE_ENCRYPTION_KEY_ID);
  }

  setServerSideEncryptionKeyId(serverSideEncryptionKeyId: string): void {
    this.metadata.set(OSSHeaders.OSS_SERVER_SIDE_ENCRYPTION_KEY_ID, serverSideEncryptionKeyId);
  }

  setServerSideDataEncryption(serverSideDataEncryption: string): void {
    this.metadata.set(OSSHeaders.OSS_SERVER_SIDE_DATA_ENCRYPTION, serverSideDataEncryption);
  }

  getServerSideDataEncryption(): string | undefined {
    return this.metadata.get(OSSHeaders.OSS_SERVER_SIDE_DATA_ENCRYPTION);
  }

  getObjectType(): string | undefined {
    return this.metadata.get(OSSHeaders.OSS_OBJECT_TYPE);
  }

  setObjectAcl(cannedAcl: string): void {
    this.metadata.set(OSSHeaders.OSS_OBJECT_ACL, cannedAcl || '');
  }

  getRawMetadata(): ReadonlyMap<string, ESObject> {
    return new Map(this.metadata);
  }

  getRequestId(): string | undefined {
    return this.metadata.get(OSSHeaders.OSS_HEADER_REQUEST_ID);
  }

  getVersionId(): string | undefined {
    return this.metadata.get(OSSHeaders.OSS_HEADER_VERSION_ID);
  }

  getServerCRC(): number | undefined {
    const strSrvCrc: ESObject = this.metadata.get(OSSHeaders.OSS_HASH_CRC64_ECMA);
    return strSrvCrc ? parseInt(strSrvCrc, 10) : undefined;
  }

  getObjectStorageClass(): StorageClass {
    const storageClassString: ESObject = this.metadata.get(OSSHeaders.OSS_STORAGE_CLASS);
    return storageClassString ? StorageClass.parse(storageClassString) : StorageClass.Standard;
  }

  getObjectRawRestore(): string | undefined {
    return this.metadata.get(OSSHeaders.OSS_RESTORE);
  }

  isRestoreCompleted(): boolean {
    const restoreString = this.getObjectRawRestore();
    if (restoreString === null) {
      throw new Error('Restore information is missing');
    }

    return restoreString !== OSSHeaders.OSS_ONGOING_RESTORE;
  }

  setObjectTagging(tags: Map<string, string>): void {
    if (tags && tags.size > 0) {
      let builder: string = "";
      tags.forEach((value, key) => {
        if (!key || !value) {
          throw new Error('Tag keys and values must not be empty');
        }
        builder += (builder.length > 0 ? "&" : "");
        builder += `${SignV2Utils.uriEncoding(key)}=${SignV2Utils.uriEncoding(value)}`;
      });
      this.metadata.set(OSSHeaders.OSS_TAGGING, builder);
    }
  }
}