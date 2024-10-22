import CredentialsProvider from '../common/auth/CredentialsProvider';
import { ServiceClient } from '../common/comm/SeviceClient';
import CommonConstant from '../common/CommonConstant';
import CodingUtils from '../common/utils/CodingUtils';
import ObjectMetadata from '../model/ObjectMetadata';
import PutObjectRequest from '../model/PutObjectRequest';
import PutObjectResult from '../model/PutObjectResult';
import WriteMode from '../model/WriteMode';
import OSSOperation from './OSSOperation';
import { OSSUtils } from './OSSUtils';
import fs from '@ohos.file.fs';
import IOUtils from '../common/utils/IOUtils';
import ClientException from '../ClientException';
import Mimetypes from './Mimetypes';
import RepeatableFileInputStream from '../common/comm/io/RepeatableFileInputStream';
import ResponseParser from '../common/parser/ResponseParser';

export default class OSSObjectOperation extends OSSOperation {
  constructor(serviceClient: ServiceClient, credentialProvider: CredentialsProvider) {
    super(serviceClient, credentialProvider);
  }

  public putObject(putObjectRequest: PutObjectRequest):PutObjectResult {
    CodingUtils.assertParameterNotNull(putObjectRequest, "putObjectRequest");
    let result: PutObjectResult | undefined = undefined;
    if (!OSSObjectOperation.isNeedReturnResponse(putObjectRequest)) {
      return this.writeObjectInternal(WriteMode.OVERWRITE, putObjectRequest, )
    }


  }

  public writeObjectInternal<RequestType extends PutObjectRequest, ResponseType>(
    mode: WriteMode,
    originalRequest: RequestType,
    responseParser: ResponseParser<ResponseType>
  ): ResponseType {
    const bucketName = originalRequest.getBucketName() ?? CommonConstant.BLANK;
    const key = originalRequest.getKey() ?? CommonConstant.BLANK;
    let originalInputStream = originalRequest.getInputStream();
    let metadata: ObjectMetadata = originalRequest.getMetadata() ?? new ObjectMetadata();

    CodingUtils.assertStringNotNullOrEmpty(bucketName, "bucketName");
    CodingUtils.assertStringNotNullOrEmpty(key, "key");
    OSSUtils.ensureBucketNameValid(bucketName);
    OSSUtils.ensureObjectKeyValid(key);
    OSSUtils.ensureCallbackValid(originalRequest.getCallback());

    let repeatableInputStream: fs.ReadStream | null = null;
    const fileToUpload = originalRequest.getFile();

    if (fileToUpload) {
      if (!IOUtils.checkFile(fileToUpload)) {
        console.info("Illegal file path: " + fileToUpload.path);
        throw new ClientException("Illegal file path: " + fileToUpload.path);
      }

      metadata.setContentLength(fs.statSync(fileToUpload.path).size);
      if (!metadata.getContentType()) {
        metadata.setContentType(Mimetypes.getInstance().getMimetype(fileToUpload.name, key));
      }

      try {
        repeatableInputStream = new RepeatableFileInputStream(undefined, fileToUpload);
      } catch (ex) {
        console.log("Cannot locate file to upload: ", ex);
        throw new ClientException("Cannot locate file to upload: ", ex);
      }
    } else {
      if (!originalInputStream) {
        throw new Error("Please specify input stream or file to upload");
      }

      if (!metadata.getContentType()) {
        metadata.setContentType(Mimetypes.getInstance().getMimetype(key));
      }

      try {
        repeatableInputStream = new RepeatableFileInputStream(originalInputStream,undefined);
      } catch (ex) {
        // logException("Cannot wrap to repeatable input stream: ", ex);
        throw new ClientException("Cannot wrap to repeatable input stream: ", ex);
      }
    }

    const headers: Record<string, string> = {};
    populateRequestMetadata(headers, metadata);
    populateRequestCallback(headers, originalRequest.getCallback());
    populateRequestPayerHeader(headers, originalRequest.getRequestPayer());
    populateTrafficLimitHeader(headers, originalRequest.getTrafficLimit());

    const params: Record<string, string> = {};
    populateWriteObjectParams(mode, originalRequest, params);

    const httpRequest = new OSSRequestMessageBuilder(getInnerClient())
      .setEndpoint(getEndpoint(originalRequest))
      .setMethod(WriteMode.getMappingMethod(mode))
      .setBucket(bucketName)
      .setKey(key)
      .setHeaders(headers)
      .setParameters(params)
      .setInputStream(repeatableInputStream)
      .setInputSize(determineInputStreamLength(repeatableInputStream, metadata.getContentLength()))
      .setOriginalRequest(originalRequest)
      .build();

    const responseHandlers: Array<any> = [new OSSCallbackErrorResponseHandler()];

    const listener = originalRequest.getProgressListener();
    let result: ResponseType;

    try {
      publishProgress(listener, ProgressEventType.TRANSFER_STARTED_EVENT);
      if (!originalRequest.getCallback()) {
        result = doOperation(httpRequest, responseParser, bucketName, key, true);
      } else {
        result = doOperation(httpRequest, responseParser, bucketName, key, true, null, responseHandlers);
      }
      publishProgress(listener, ProgressEventType.TRANSFER_COMPLETED_EVENT);
    } catch (e) {
      publishProgress(listener, ProgressEventType.TRANSFER_FAILED_EVENT);
      throw e;
    }

    return result;
  }

  public static isNeedReturnResponse(putObjectRequest: PutObjectRequest): boolean {
    return putObjectRequest.getCallback() !== undefined || putObjectRequest.getProcess() !== undefined;
  }
}