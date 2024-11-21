import CallbackResult from './CallbackResult';
import GenericResult from './GenericResult';
import fs from '@ohos.file.fs';
import CommonConstant from '../common/CommonConstant';
import InputStream from '@htliang/java_type/src/main/ets/java/io/InputStream';

export default class PutObjectResult extends GenericResult implements CallbackResult {
  eTag?: string;
  versionId?: string;
  callbackResponseBody?: InputStream;

  public getETag(): string| undefined {
    return this.eTag;
  }

  public setETag(eTag: string):void {
    this.eTag = eTag;
  }

  public getVersionId():string|undefined {
    return this.versionId;
  }

  public setVersionId(versionId: string):void {
    this.versionId = versionId;
  }

  getCallbackResponseBody(): InputStream | undefined {
    return this.callbackResponseBody;
  }

  setCallbackResponseBody(callbackResponseBody: InputStream | undefined): void {
    this.callbackResponseBody = callbackResponseBody;
  }
}