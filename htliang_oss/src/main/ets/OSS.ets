import Credentials from './common/auth/Credentials';
import { SignVersion } from './common/comm/SignVersion';
import fs from '@ohos.file.fs';
import PutObjectResult from './model/PutObjectResult';
import PutObjectRequest from './model/PutObjectRequest';

export default interface OSS {
  switchCredentials(credentials: Credentials): void;

  switchSignatureVersion(signatureVersion: SignVersion): void;

  shutdown(): void;

  getConnectionPoolStats(): string;

  putObject(request: PutObjectRequest): Promise<PutObjectResult>;

  // putObject(bucketName: string, key: string, input: fs.ReadStream): Promise<PutObjectResult>;

  // putObject(bucketName: string, key: string, input: fs.ReadStream, metadata: ObjectMetadata): Promise<PutObjectResult>;
  //
  // putObject(bucketName: string, key: string, file: File, metadata: ObjectMetadata): Promise<PutObjectResult>;
  //
  // putObject(bucketName: string, key: string, file: File): Promise<PutObjectResult>;
  //
  //
  // putObject(signedUrl: URL, filePath: string, requestHeaders: Map<string, string>): Promise<PutObjectResult>;
  //
  // putObject(signedUrl: URL, filePath: string, requestHeaders: Map<string, string>,
  //   useChunkEncoding: boolean): Promise<PutObjectResult>;
  //
  // putObject(signedUrl: URL, requestContent: InputStream, contentLength: number,
  //   requestHeaders: Map<string, string>): Promise<PutObjectResult>;
  //
  // putObject(signedUrl: URL, requestContent: InputStream, contentLength: number, requestHeaders: Map<string, string>,
  //   useChunkEncoding: boolean): Promise<PutObjectResult>;


  // createBucket(bucketName: string): Promise<Bucket>;
  //
  // createBucket(request: CreateBucketRequest): Promise<Bucket>;
  //
  // deleteBucket(bucketName: string): Promise<VoidResult>;
  //
  // deleteBucket(request: GenericRequest): Promise<VoidResult>;
  //
  // listBuckets(): Promise<Bucket[]>;
  //
  // listBuckets(prefix: string, marker: string, maxKeys: number): Promise<BucketList>;
  //
  // listBuckets(request: ListBucketsRequest): Promise<BucketList>;
  //
  // setBucketAcl(bucketName: string, acl: CannedAccessControlList): Promise<VoidResult>;
  //
  // setBucketAcl(request: SetBucketAclRequest): Promise<VoidResult>;
  //
  // getBucketAcl(bucketName: string): Promise<AccessControlList>;
  //
  // getBucketAcl(request: GenericRequest): Promise<AccessControlList>;
  //
  // getBucketMetadata(bucketName: string): Promise<BucketMetadata>;
  //
  // getBucketMetadata(request: GenericRequest): Promise<BucketMetadata>;
  //
  // setBucketReferer(bucketName: string, referer: BucketReferer): Promise<VoidResult>;
  //
  // setBucketReferer(request: SetBucketRefererRequest): Promise<VoidResult>;
  //
  // getBucketReferer(bucketName: string): Promise<BucketReferer>;
  //
  // getBucketReferer(request: GenericRequest): Promise<BucketReferer>;
  //
  // getBucketLocation(bucketName: string): Promise<string>;
  //
  // getBucketLocation(request: GenericRequest): Promise<string>;
  //
  // setBucketTagging(bucketName: string, tags: Map<string, string>): Promise<VoidResult>;
  //
  // setBucketTagging(bucketName: string, tagSet: TagSet): Promise<VoidResult>;
  //
  // setBucketTagging(request: SetBucketTaggingRequest): Promise<VoidResult>;
  //
  // getBucketTagging(bucketName: string): Promise<TagSet>;
  //
  // getBucketTagging(request: GenericRequest): Promise<TagSet>;
  //
  // deleteBucketTagging(bucketName: string): Promise<VoidResult>;
  //
  // deleteBucketTagging(request: GenericRequest): Promise<VoidResult>;
  //
  // getBucketVersioning(bucketName: string): Promise<BucketVersioningConfiguration>;
  //
  // getBucketVersioning(request: GenericRequest): Promise<BucketVersioningConfiguration>;
  //
  // setBucketVersioning(request: SetBucketVersioningRequest): Promise<VoidResult>;
  //
  // doesBucketExist(bucketName: string): Promise<boolean>;
  //
  // doesBucketExist(request: GenericRequest): Promise<boolean>;
  //
  // listObjects(bucketName: string): Promise<ObjectListing>;
  //
  // listObjects(bucketName: string, prefix: string): Promise<ObjectListing>;
  //
  // listObjects(request: ListObjectsRequest): Promise<ObjectListing>;
  //
  // listObjectsV2(request: ListObjectsV2Request): Promise<ListObjectsV2Result>;
  //
  // listObjectsV2(bucketName: string): Promise<ListObjectsV2Result>;
  //
  // listObjectsV2(bucketName: string, prefix: string): Promise<ListObjectsV2Result>;
  //
  // listObjectsV2(bucketName: string, prefix: string, continuationToken: string, startAfter: string, delimiter: string,
  //   maxKeys: number, encodingType: string, fetchOwner: boolean): Promise<ListObjectsV2Result>;
  //
  // listVersions(bucketName: string, prefix: string): Promise<VersionListing>;
  //
  // listVersions(bucketName: string, prefix: string, keyMarker: string, versionIdMarker: string, delimiter: string,
  //   maxResults: number): Promise<VersionListing>;
  //
  // listVersions(request: ListVersionsRequest): Promise<VersionListing>;
  //
  //
  //
  // copyObject(sourceBucketName: string, sourceKey: string, destinationBucketName: string,
  //   destinationKey: string): Promise<CopyObjectResult>;
  //
  // copyObject(request: CopyObjectRequest): Promise<CopyObjectResult>;
  //
  // getObject(bucketName: string, key: string): Promise<OSSObject>;
  //
  // getObject(request: GetObjectRequest, file: File): Promise<ObjectMetadata>;
  //
  // getObject(request: GetObjectRequest): Promise<OSSObject>;
  //
  // selectObject(request: SelectObjectRequest): Promise<OSSObject>;
  //
  // getObject(signedUrl: URL, requestHeaders: Map<string, string>): Promise<OSSObject>;
  //
  // getSimplifiedObjectMeta(bucketName: string, key: string): Promise<SimplifiedObjectMeta>;
  //
  // getSimplifiedObjectMeta(request: GenericRequest): Promise<SimplifiedObjectMeta>;
  //
  // getObjectMetadata(bucketName: string, key: string): Promise<ObjectMetadata>;
  //
  // getObjectMetadata(request: GenericRequest): Promise<ObjectMetadata>;
  //
  // createSelectObjectMetadata(request: CreateSelectObjectMetadataRequest): Promise<SelectObjectMetadata>;
  //
  // headObject(bucketName: string, key: string): Promise<ObjectMetadata>;
  //
  // headObject(request: HeadObjectRequest): Promise<ObjectMetadata>;
  //
  // appendObject(request: AppendObjectRequest): Promise<AppendObjectResult>;
  //
  // deleteObject(bucketName: string, key: string): Promise<VoidResult>;
  //
  // deleteObject(request: GenericRequest): Promise<VoidResult>;
  //
  // deleteObjects(request: DeleteObjectsRequest): Promise<DeleteObjectsResult>;
  //
  // deleteVersion(bucketName: string, key: string, versionId: string): Promise<VoidResult>;
  //
  // deleteVersion(request: DeleteVersionRequest): Promise<VoidResult>;
  //
  // deleteVersions(request: DeleteVersionsRequest): Promise<DeleteVersionsResult>;
  //
  // doesObjectExist(bucketName: string, key: string): Promise<boolean>;
  //
  // doesObjectExist(request: GenericRequest): Promise<boolean>;
  //
  // doesObjectExist(bucketName: string, key: string, isOnlyInOSS: boolean): boolean;
  //
  // doesObjectExist(request: GenericRequest, isOnlyInOSS: boolean): Promise<boolean>;
  //
  // setObjectAcl(bucketName: string, key: string, cannedAcl: CannedAccessControlList): Promise<VoidResult>;
  //
  // setObjectAcl(request: SetObjectAclRequest): Promise<VoidResult>;
  //
  // getObjectAcl(bucketName: string, key: string): Promise<ObjectAcl>;
  //
  // getObjectAcl(request: GenericRequest): Promise<ObjectAcl>;
  //
  // restoreObject(bucketName: string, key: string): Promise<RestoreObjectResult>;
  //
  // restoreObject(request: GenericRequest): Promise<RestoreObjectResult>;
  //
  // restoreObject(bucketName: string, key: string,
  //   restoreConfiguration: RestoreConfiguration): Promise<RestoreObjectResult>;
  //
  // restoreObject(request: RestoreObjectRequest): Promise<RestoreObjectResult>;
  //
  // setObjectTagging(bucketName: string, key: string, tags: Map<string, string>): Promise<VoidResult>;
  //
  // setObjectTagging(bucketName: string, key: string, tagSet: TagSet): Promise<VoidResult>;
  //
  // setObjectTagging(request: SetObjectTaggingRequest): Promise<VoidResult>;
  //
  // getObjectTagging(bucketName: string, key: string): Promise<TagSet>;
  //
  // getObjectTagging(request: GenericRequest): Promise<TagSet>;
  //
  // deleteObjectTagging(bucketName: string, key: string): Promise<VoidResult>;
  //
  // deleteObjectTagging(request: GenericRequest): Promise<VoidResult>;
  //
  // generatePresignedUrl(bucketName: string, key: string, expiration: Date): Promise<URL>;
  //
  // generatePresignedUrl(bucketName: string, key: string, expiration: Date, method: HttpMethod): Promise<URL>;
  //
  // generatePresignedUrl(request: GeneratePresignedUrlRequest): Promise<URL>;
  //
  // putBucketImage(request: PutBucketImageRequest): Promise<VoidResult>;
  //
  // getBucketImage(bucketName: string): Promise<GetBucketImageResult>;
  //
  // getBucketImage(bucketName: string, request: GenericRequest): Promise<GetBucketImageResult>;
  //
  // deleteBucketImage(bucketName: string): Promise<VoidResult>;
  //
  // deleteBucketImage(bucketName: string, request: GenericRequest): Promise<VoidResult>;
  //
  // deleteImageStyle(bucketName: string, styleName: string): Promise<VoidResult>;
  //
  // deleteImageStyle(bucketName: string, styleName: string, request: GenericRequest): Promise<VoidResult>;
  //
  // putImageStyle(request: PutImageStyleRequest): Promise<VoidResult>;
  //
  // getImageStyle(bucketName: string, styleName: string): Promise<GetImageStyleResult>;
  //
  // getImageStyle(bucketName: string, styleName: string, request: GenericRequest): Promise<GetImageStyleResult>;
  //
  // listImageStyle(bucketName: string): Promise<Style[]>;
  //
  // listImageStyle(bucketName: string, request: GenericRequest): Promise<Style[]>;
  //
  // setBucketProcess(request: SetBucketProcessRequest): Promise<VoidResult>;
  //
  // getBucketProcess(bucketName: string): Promise<BucketProcess>;
  //
  // getBucketProcess(request: GenericRequest): Promise<BucketProcess>;
  //
  // initiateMultipartUpload(request: InitiateMultipartUploadRequest): Promise<InitiateMultipartUploadResult>;
  //
  // listMultipartUploads(request: ListMultipartUploadsRequest): Promise<MultipartUploadListing>;
  //
  // listParts(request: ListPartsRequest): Promise<PartListing>;
  //
  // uploadPart(request: UploadPartRequest): Promise<UploadPartResult>;
  //
  // uploadPartCopy(request: UploadPartCopyRequest): Promise<UploadPartCopyResult>;
  //
  // abortMultipartUpload(request: AbortMultipartUploadRequest): Promise<VoidResult>;
  //
  // completeMultipartUpload(request: CompleteMultipartUploadRequest): Promise<CompleteMultipartUploadResult>;
  //
  // setBucketCORS(request: SetBucketCORSRequest): Promise<VoidResult>;
  //
  // getBucketCORSRules(bucketName: string): Promise<CORSRule[]>;
  //
  // getBucketCORSRules(request: GenericRequest): Promise<CORSRule[]>;
  //
  // getBucketCORS(request: GenericRequest): Promise<CORSConfiguration>;
  //
  // deleteBucketCORSRules(bucketName: string): Promise<VoidResult>;
  //
  // deleteBucketCORSRules(request: GenericRequest): Promise<VoidResult>;
  //
  // setBucketLogging(request: SetBucketLoggingRequest): Promise<VoidResult>;
  //
  // getBucketLogging(bucketName: string): Promise<BucketLoggingResult>;
  //
  // getBucketLogging(request: GenericRequest): Promise<BucketLoggingResult>;
  //
  // deleteBucketLogging(bucketName: string): Promise<VoidResult>;
  //
  // deleteBucketLogging(request: GenericRequest): Promise<VoidResult>;
  //
  // setBucketWebsite(request: SetBucketWebsiteRequest): Promise<VoidResult>;
  //
  // getBucketWebsite(bucketName: string): Promise<BucketWebsiteResult>;
  //
  // getBucketWebsite(request: GenericRequest): Promise<BucketWebsiteResult>;
  //
  // deleteBucketWebsite(bucketName: string): Promise<VoidResult>;
  //
  // deleteBucketWebsite(request: GenericRequest): Promise<VoidResult>;
  //
  // generatePostPolicy(expiration: Date, conds: PolicyConditions): Promise<string>;
  //
  // calculatePostSignature(postPolicy: string): Promise<string>;
  //
  // calculatePostSignature(postPolicy: string, date: Date): Promise<string>;
  //
  // setBucketLifecycle(request: SetBucketLifecycleRequest): Promise<VoidResult>;
  //
  // getBucketLifecycle(bucketName: string): Promise<LifecycleRule[]>;
  //
  // getBucketLifecycle(request: GenericRequest): Promise<LifecycleRule[]>;
  //
  // deleteBucketLifecycle(bucketName: string): Promise<VoidResult>;
  //
  // deleteBucketLifecycle(request: GenericRequest): Promise<VoidResult>;
  //
  // addBucketReplication(request: AddBucketReplicationRequest): Promise<VoidResult>;
  //
  // getBucketReplication(bucketName: string): Promise<ReplicationRule[]>;
  //
  // getBucketReplication(request: GenericRequest): Promise<ReplicationRule[]>;
  //
  // deleteBucketReplication(bucketName: string, replicationRuleID: string): Promise<VoidResult>;
  //
  // deleteBucketReplication(request: DeleteBucketReplicationRequest): Promise<VoidResult>;
  //
  // getBucketReplicationProgress(bucketName: string, replicationRuleID: string): Promise<BucketReplicationProgress>;
  //
  // getBucketReplicationProgress(request: GetBucketReplicationProgressRequest): Promise<BucketReplicationProgress>;
  //
  // getBucketReplicationLocation(bucketName: string): Promise<string[]>;
  //
  // getBucketReplicationLocation(request: GenericRequest): Promise<string[]>;
  //
  // addBucketCname(request: AddBucketCnameRequest): Promise<AddBucketCnameResult>;
  //
  // getBucketCname(bucketName: string): Promise<CnameConfiguration[]>;
  //
  // getBucketCname(request: GenericRequest): Promise<CnameConfiguration[]>;
  //
  // deleteBucketCname(bucketName: string, domain: string): Promise<VoidResult>;
  //
  // deleteBucketCname(request: DeleteBucketCnameRequest): Promise<VoidResult>;
  //
  // createBucketCnameToken(request: CreateBucketCnameTokenRequest): Promise<CreateBucketCnameTokenResult>;
  //
  // getBucketCnameToken(request: GetBucketCnameTokenRequest): Promise<GetBucketCnameTokenResult>;
  //
  // getBucketInfo(bucketName: string): Promise<BucketInfo>;
  //
  // getBucketInfo(request: GenericRequest): Promise<BucketInfo>;
  //
  // getBucketStat(bucketName: string): Promise<BucketStat>;
  //
  // getBucketStat(request: GenericRequest): Promise<BucketStat>;
  //
  // setBucketStorageCapacity(bucketName: string, userQos: UserQos): Promise<VoidResult>;
  //
  // setBucketStorageCapacity(request: SetBucketStorageCapacityRequest): Promise<VoidResult>;
  //
  // getBucketStorageCapacity(bucketName: string): Promise<UserQos>;
  //
  // getBucketStorageCapacity(request: GenericRequest): Promise<UserQos>;
  //
  // setBucketEncryption(request: SetBucketEncryptionRequest): Promise<VoidResult>;
  //
  // getBucketEncryption(bucketName: string): Promise<ServerSideEncryptionConfiguration>;
  //
  // getBucketEncryption(request: GenericRequest): Promise<ServerSideEncryptionConfiguration>;
  //
  // deleteBucketEncryption(bucketName: string): Promise<VoidResult>;
  //
  // deleteBucketEncryption(request: GenericRequest): Promise<VoidResult>;
  //
  // setBucketPolicy(bucketName: string, policyText: string): Promise<VoidResult>;
  //
  // setBucketPolicy(request: SetBucketPolicyRequest): Promise<VoidResult>;
  //
  // getBucketPolicy(request: GenericRequest): Promise<GetBucketPolicyResult>;
  //
  // getBucketPolicy(bucketName: string): Promise<GetBucketPolicyResult>;
  //
  // deleteBucketPolicy(request: GenericRequest): Promise<VoidResult>;
  //
  // deleteBucketPolicy(bucketName: string): Promise<VoidResult>;
  //
  // uploadFile(request: UploadFileRequest): Promise<UploadFileResult>;
  //
  // downloadFile(request: DownloadFileRequest): Promise<DownloadFileResult>;
  //
  // createLiveChannel(request: CreateLiveChannelRequest): Promise<CreateLiveChannelResult>;
  //
  // setLiveChannelStatus(bucketName: string, liveChannel: string, status: LiveChannelStatus): Promise<VoidResult>;
  //
  // setLiveChannelStatus(request: SetLiveChannelRequest): Promise<VoidResult>;
  //
  // getLiveChannelInfo(bucketName: string, liveChannel: string): Promise<LiveChannelInfo>;
  //
  // getLiveChannelInfo(request: LiveChannelGenericRequest): Promise<LiveChannelInfo>;
  //
  // getLiveChannelStat(bucketName: string, liveChannel: string): Promise<LiveChannelStat>;
  //
  // getLiveChannelStat(request: LiveChannelGenericRequest): Promise<LiveChannelStat>;
  //
  // deleteLiveChannel(bucketName: string, liveChannel: string): Promise<VoidResult>;
  //
  // deleteLiveChannel(request: LiveChannelGenericRequest): Promise<VoidResult>;
  //
  // listLiveChannels(bucketName: string): Promise<LiveChannel[]>;
  //
  // listLiveChannels(request: ListLiveChannelsRequest): Promise<LiveChannelListing>;
  //
  // getLiveChannelHistory(bucketName: string, liveChannel: string): Promise<LiveRecord[]>;
  //
  // getLiveChannelHistory(request: LiveChannelGenericRequest): Promise<LiveRecord[]>;
  //
  // generateVodPlaylist(bucketName: string, liveChannelName: string, PlaylistName: string, startTime: number,
  //   endTime: number): Promise<VoidResult>;
  //
  // generateVodPlaylist(request: GenerateVodPlaylistRequest): Promise<VoidResult>;
  //
  // getVodPlaylist(bucketName: string, liveChannelName: string, startTime: number, endTime: number): Promise<OSSObject>;
  //
  // getVodPlaylist(request: GetVodPlaylistRequest): Promise<OSSObject>;
  //
  // generateRtmpUri(bucketName: string, liveChannelName: string, PlaylistName: string, expires: number): Promise<string>;
  //
  // generateRtmpUri(request: GenerateRtmpUriRequest): Promise<string>;
  //
  // createSymlink(bucketName: string, symlink: string, target: string): Promise<VoidResult>;
  //
  // createSymlink(request: CreateSymlinkRequest): Promise<VoidResult>;
  //
  // getSymlink(bucketName: string, symlink: string): Promise<OSSSymlink>;
  //
  // getSymlink(request: GenericRequest): Promise<OSSSymlink>;
  //
  // processObject(request: ProcessObjectRequest): Promise<GenericResult>;
  //
  // setBucketRequestPayment(bucketName: string, payer: Payer): Promise<VoidResult>;
  //
  // setBucketRequestPayment(request: SetBucketRequestPaymentRequest): Promise<VoidResult>;
  //
  // getBucketRequestPayment(bucketName: string): Promise<GetBucketRequestPaymentResult>;
  //
  // getBucketRequestPayment(request: GenericRequest): Promise<GetBucketRequestPaymentResult>;
  //
  // setBucketQosInfo(bucketName: string, bucketQosInfo: BucketQosInfo): Promise<VoidResult>;
  //
  // setBucketQosInfo(request: SetBucketQosInfoRequest): Promise<VoidResult>;
  //
  // getBucketQosInfo(bucketName: string): Promise<BucketQosInfo>;
  //
  // getBucketQosInfo(request: GenericRequest): Promise<BucketQosInfo>;
  //
  // deleteBucketQosInfo(bucketName: string): Promise<VoidResult>;
  //
  // deleteBucketQosInfo(request: GenericRequest): Promise<VoidResult>;
  //
  // getUserQosInfo(): Promise<UserQosInfo>;
  //
  // setAsyncFetchTask(bucketName: string,
  //   asyncFetchTaskConfiguration: AsyncFetchTaskConfiguration): Promise<SetAsyncFetchTaskResult>;
  //
  // setAsyncFetchTask(request: SetAsyncFetchTaskRequest): Promise<SetAsyncFetchTaskResult>;
  //
  // getAsyncFetchTask(bucketName: string, taskId: string): Promise<GetAsyncFetchTaskResult>;
  //
  // getAsyncFetchTask(request: GetAsyncFetchTaskRequest): Promise<GetAsyncFetchTaskResult>;
  //
  // createVpcip(request: CreateVpcipRequest): Promise<CreateVpcipResult>;
  //
  // listVpcip(): Promise<Vpcip[]>;
  //
  // deleteVpcip(request: DeleteVpcipRequest): Promise<VoidResult>;
  //
  // createBucketVpcip(request: CreateBucketVpcipRequest): Promise<VoidResult>;
  //
  // getBucketVpcip(request: GenericRequest): Promise<VpcPolicy[]>;
  //
  // deleteBucketVpcip(request: DeleteBucketVpcipRequest): Promise<VoidResult>;
  //
  // setBucketInventoryConfiguration(bucketName: string,
  //   inventoryConfiguration: InventoryConfiguration): Promise<VoidResult>;
  //
  // setBucketInventoryConfiguration(request: SetBucketInventoryConfigurationRequest): Promise<VoidResult>;
  //
  // getBucketInventoryConfiguration(bucketName: string, id: string): Promise<GetBucketInventoryConfigurationResult>;
  //
  // getBucketInventoryConfiguration(request: GetBucketInventoryConfigurationRequest): Promise<GetBucketInventoryConfigurationResult>;
  //
  // listBucketInventoryConfigurations(bucketName: string): Promise<ListBucketInventoryConfigurationsResult>;
  //
  // listBucketInventoryConfigurations(bucketName: string,
  //   continuationToken: string): Promise<ListBucketInventoryConfigurationsResult>;
  //
  // listBucketInventoryConfigurations(request: ListBucketInventoryConfigurationsRequest): Promise<ListBucketInventoryConfigurationsResult>;
  //
  // deleteBucketInventoryConfiguration(bucketName: string, id: string): Promise<VoidResult>;
  //
  // deleteBucketInventoryConfiguration(request: DeleteBucketInventoryConfigurationRequest): Promise<VoidResult>;
  //
  // initiateBucketWorm(request: InitiateBucketWormRequest): Promise<InitiateBucketWormResult>;
  //
  // initiateBucketWorm(bucketName: string, retentionPeriodInDays: number): Promise<InitiateBucketWormResult>;
  //
  // abortBucketWorm(bucketName: string): Promise<VoidResult>;
  //
  // abortBucketWorm(request: GenericRequest): Promise<VoidResult>;
  //
  // completeBucketWorm(bucketName: string, wormId: string): Promise<VoidResult>;
  //
  // completeBucketWorm(request: CompleteBucketWormRequest): Promise<VoidResult>;
  //
  // extendBucketWorm(bucketName: string, wormId: string, retentionPeriodInDays: number): Promise<VoidResult>;
  //
  // extendBucketWorm(request: ExtendBucketWormRequest): Promise<VoidResult>;
  //
  // getBucketWorm(bucketName: string): Promise<GetBucketWormResult>;
  //
  // getBucketWorm(request: GenericRequest): Promise<GetBucketWormResult>;
  //
  // createDirectory(bucketName: string, dirName: string): Promise<VoidResult>;
  //
  // createDirectory(request: CreateDirectoryRequest): Promise<VoidResult>;
  //
  // deleteDirectory(bucketName: string, dirName: string): Promise<DeleteDirectoryResult>;
  //
  // deleteDirectory(bucketName: string, dirName: string, deleteRecursive: boolean,
  //   nextDeleteToken: string): Promise<DeleteDirectoryResult>;
  //
  // deleteDirectory(request: DeleteDirectoryRequest): Promise<DeleteDirectoryResult>;
  //
  // renameObject(bucketName: string, sourceObjectName: string, destinationObjectName: string): Promise<VoidResult>;
  //
  // renameObject(request: RenameObjectRequest): Promise<VoidResult>;
  //
  // setBucketResourceGroup(request: SetBucketResourceGroupRequest): Promise<VoidResult>;
  //
  // getBucketResourceGroup(bucketName: string): Promise<GetBucketResourceGroupResult>;
  //
  // createUdf(request: CreateUdfRequest): Promise<VoidResult>;
  //
  // getUdfInfo(request: UdfGenericRequest): Promise<UdfInfo>;
  //
  // listUdfs(): Promise<UdfInfo[]>;
  //
  // deleteUdf(request: UdfGenericRequest): Promise<VoidResult>;
  //
  // uploadUdfImage(request: UploadUdfImageRequest): Promise<VoidResult>;
  //
  // getUdfImageInfo(request: UdfGenericRequest): Promise<UdfImageInfo[]>;
  //
  // deleteUdfImage(request: UdfGenericRequest): Promise<VoidResult>;
  //
  // createUdfApplication(request: CreateUdfApplicationRequest): Promise<VoidResult>;
  //
  // getUdfApplicationInfo(request: UdfGenericRequest): Promise<UdfApplicationInfo>;
  //
  // listUdfApplications(): Promise<UdfApplicationInfo[]>;
  //
  // deleteUdfApplication(request: UdfGenericRequest): Promise<VoidResult>;
  //
  // upgradeUdfApplication(request: UpgradeUdfApplicationRequest): Promise<VoidResult>;
  //
  // resizeUdfApplication(request: ResizeUdfApplicationRequest): Promise<VoidResult>;
  //
  // getUdfApplicationLog(request: GetUdfApplicationLogRequest): Promise<UdfApplicationLog>;
  //
  // setBucketTransferAcceleration(bucketName: string, enable: boolean): Promise<VoidResult>;
  //
  // getBucketTransferAcceleration(bucketName: string): Promise<TransferAcceleration>;
  //
  // deleteBucketTransferAcceleration(bucketName: string): Promise<VoidResult>;
  //
  // putBucketAccessMonitor(bucketName: string, status: string): Promise<VoidResult>;
  //
  // getBucketAccessMonitor(bucketName: string): Promise<AccessMonitor>;
  //
  // openMetaQuery(bucketName: string): Promise<VoidResult>;
  //
  // getMetaQueryStatus(bucketName: string): Promise<GetMetaQueryStatusResult>;
  //
  // doMetaQuery(request: DoMetaQueryRequest): Promise<DoMetaQueryResult>;
  //
  // closeMetaQuery(bucketName: string): Promise<VoidResult>;
  //
  // describeRegions(request: DescribeRegionsRequest): Promise<DescribeRegionsResult>;
  //
  // setBucketCallbackPolicy(request: SetBucketCallbackPolicyRequest): Promise<VoidResult>;
  //
  // getBucketCallbackPolicy(request: GenericRequest): Promise<GetBucketCallbackPolicyResult>;
  //
  // deleteBucketCallbackPolicy(request: GenericRequest): Promise<VoidResult>;
  //
  // asyncProcessObject(request: AsyncProcessObjectRequest): Promise<AsyncProcessObjectResult>;
  //
  // writeGetObjectResponse(request: WriteGetObjectResponseRequest): Promise<VoidResult>;
  //
  // putBucketArchiveDirectRead(request: PutBucketArchiveDirectReadRequest): Promise<VoidResult>;
  //
  // getBucketArchiveDirectRead(bucketName: string): Promise<GetBucketArchiveDirectReadResult>;
  //
  // putBucketHttpsConfig(request: PutBucketHttpsConfigRequest): Promise<VoidResult>;
  //
  // getBucketHttpsConfig(bucketName: string): Promise<GetBucketHttpsConfigResult>;
  //
  // putPublicAccessBlock(request: PutPublicAccessBlockRequest): Promise<VoidResult>;
  //
  // getPublicAccessBlock(): Promise<GetPublicAccessBlockResult>;
  //
  // deletePublicAccessBlock(): Promise<VoidResult>;
  //
  // putBucketPublicAccessBlock(request: PutBucketPublicAccessBlockRequest): Promise<VoidResult>;
  //
  // getBucketPublicAccessBlock(bucketName: string): Promise<GetBucketPublicAccessBlockResult>;
  //
  // deleteBucketPublicAccessBlock(bucketName: string): Promise<VoidResult>;
  //
  // getBucketPolicyStatus(bucketName: string): Promise<GetBucketPolicyStatusResult>;
  //
  // createBucketDataRedundancyTransition(bucketName: string): Promise<CreateBucketDataRedundancyTransitionResult>;
  //
  // createBucketDataRedundancyTransition(bucketName: string,
  //   targetType: string): Promise<CreateBucketDataRedundancyTransitionResult>;
  //
  // createBucketDataRedundancyTransition(bucketName: string,
  //   targetType: DataRedundancyType): Promise<CreateBucketDataRedundancyTransitionResult>;
  //
  // createBucketDataRedundancyTransition(request: CreateBucketDataRedundancyTransitionRequest): Promise<CreateBucketDataRedundancyTransitionResult>;
  //
  // getBucketDataRedundancyTransition(bucketName: string,
  //   taskId: string): Promise<GetBucketDataRedundancyTransitionResult>;
  //
  // getBucketDataRedundancyTransition(request: GetBucketDataRedundancyTransitionRequest): Promise<GetBucketDataRedundancyTransitionResult>;
  //
  // deleteBucketDataRedundancyTransition(bucketName: string, taskId: string): Promise<VoidResult>;
  //
  // deleteBucketDataRedundancyTransition(request: DeleteBucketDataRedundancyTransitionRequest): Promise<VoidResult>;
  //
  // listUserDataRedundancyTransition(request: ListUserDataRedundancyTransitionRequest): Promise<ListUserDataRedundancyTransitionResult>;
  //
  // listBucketDataRedundancyTransition(bucketName: string): Promise<GetBucketDataRedundancyTransitionResult[]>;
  //
  // listBucketDataRedundancyTransition(request: GenericRequest): Promise<GetBucketDataRedundancyTransitionResult[]>;
  //
  // createAccessPoint(request: CreateAccessPointRequest): Promise<CreateAccessPointResult>;
  //
  // getAccessPoint(request: GetAccessPointRequest): Promise<GetAccessPointResult>;
  //
  // deleteAccessPoint(request: DeleteAccessPointRequest): Promise<VoidResult>;
  //
  // putAccessPointPolicy(request: PutAccessPointPolicyRequest): Promise<VoidResult>;
  //
  // getAccessPointPolicy(request: GetAccessPointPolicyRequest): Promise<GetAccessPointPolicyResult>;
  //
  // deleteAccessPointPolicy(request: DeleteAccessPointPolicyRequest): Promise<VoidResult>;
  //
  // listAccessPoints(request: ListAccessPointsRequest): Promise<ListAccessPointsResult>;
  //
  // listBucketAccessPoints(request: ListBucketAccessPointsRequest): Promise<ListAccessPointsResult>;
}
