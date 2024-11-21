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
import ResponseParser from '../common/parser/ResponseParser';
import ResponseParsers from './ResponseParsers';
import { ProgressEventType } from '../event/ProgressEventType';
import InputStream from '@htliang/java_type/src/main/ets/java/io/InputStream';
import FileInputStream from '@htliang/java_type/src/main/ets/java/io/FileInputStream';
import AssertUtil from '@htliang/java_type/src/main/ets/java/util/AssertUtil'
import LogUtils from '../common/utils/LogUtils';
import Payer from '../model/Payer';
import OSSHeaders from './OSSHeaders';

export default class OSSObjectOperation extends OSSOperation {
  constructor(serviceClient: ServiceClient, credentialProvider: CredentialsProvider) {
    super(serviceClient, credentialProvider);
  }

  public putObject(putObjectRequest: PutObjectRequest): PutObjectResult {
    CodingUtils.assertParameterNotNull(putObjectRequest, "putObjectRequest");
    let result: PutObjectResult | undefined = undefined;
    if (!OSSObjectOperation.isNeedReturnResponse(putObjectRequest)) {
      result = this.writeObjectInternal(WriteMode.OVERWRITE, putObjectRequest, ResponseParsers.putObjectResponseParser)
    } else {
      result =
        this.writeObjectInternal(WriteMode.OVERWRITE, putObjectRequest, ResponseParsers.putObjectProcessResponseParser)
    }

    if (this.isCrcCheckEnabled()) {
      OSSUtils.checkChecksum(result.getClientCRC(), result.getServerCRC(), result.getRequestId());
    }

    return result;
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

    let repeatableInputStream: InputStream | null = null;
    const fileToUpload = originalRequest.getFile();

    if (fileToUpload) {
      if (!IOUtils.checkFile(fileToUpload)) {
        LogUtils.info("Illegal file path: " + fileToUpload.path);
        throw new ClientException("Illegal file path: " + fileToUpload.path);
      }

      metadata.setContentLength(fs.statSync(fileToUpload.path).size);
      if (!metadata.getContentType()) {
        metadata.setContentType(Mimetypes.getInstance().getMimetype(fileToUpload.name, key));
      }

      try {
        repeatableInputStream = new FileInputStream(fileToUpload.path);
      } catch (ex) {
        LogUtils.logException("Cannot locate file to upload: ", ex);
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
        if (!originalInputStream.markSupported()) {
          throw new Error('Current Version support MARK_SUPPORTED InputStream Only')
        }
        repeatableInputStream = originalInputStream;
      } catch (ex) {
        LogUtils.logException("Cannot wrap to repeatable input stream: ", ex);
        throw new ClientException("Cannot wrap to repeatable input stream: ", ex);
      }
    }

    const headers: Map<string, string> = new Map<string, string>();
    OSSUtils.populateRequestMetadata(headers, metadata);
    OSSUtils.populateRequestCallback(headers, originalRequest.getCallback());
    OSSObjectOperation.populateRequestPayerHeader(headers, originalRequest.getRequestPayer());
    OSSObjectOperation.populateTrafficLimitHeader(headers, originalRequest.getTrafficLimit());

    const params: Map<string, string> = new Map<string,string>();
    OSSObjectOperation.populateWriteObjectParams(mode, originalRequest, params);

    let httpRequest = new OSSRequestMessageBuilder(getInnerClient())
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

  static populateWriteObjectParams<RequestType extends PutObjectRequest>(mode: WriteMode, originalRequest: RequestType,
    params: Map<string, string>):void {
    if (mode === WriteMode.OVERWRITE) {
      return;
    }

    throw new Error('Current Version support OVERWRITE mode only.')
    // AssertUtil.assertInstanceOf(originalRequest, A)
  }

  private static populateRequestPayerHeader(headers: Map<string, string>, payer: Payer | undefined):void {
    if (payer && payer === Payer.Requester) {
      headers.set(OSSHeaders.OSS_REQUEST_PAYER, payer.toLowerCase());
    }
  }

  private static populateTrafficLimitHeader(headers: Map<string, string>, limit: number | undefined):void {
    if (limit && limit > 0) {
      headers.set(OSSHeaders.OSS_HEADER_TRAFFIC_LIMIT, limit.toString());
    }
  }


  public static isNeedReturnResponse(putObjectRequest: PutObjectRequest): boolean {
    return putObjectRequest.getCallback() !== undefined || putObjectRequest.getProcess() !== undefined;
  }
}