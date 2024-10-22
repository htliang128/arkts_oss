import CallbackResult from './CallbackResult';
import GenericResult from './GenericResult';
import fs from '@ohos.file.fs';
import CommonConstant from '../common/CommonConstant';

export default class PutObjectResult extends GenericResult implements CallbackResult {
  eTag?: string;
  versionId?: string;
  callbackResponseBody: string = CommonConstant.BLANK;

  public getETag() {
    return this.eTag;
  }

  public setETag(eTag: string) {
    this.eTag = eTag;
  }

  public getVersionId() {
    return this.versionId;
  }

  public setVersionId(versionId: string) {
    this.versionId = versionId;
  }

  getCallbackResponseBody(): string {
    return this.callbackResponseBody;
  }

  setCallbackResponseBody(callbackResponseBody: string): void {
    throw new Error('Method not implemented.');
  }
}