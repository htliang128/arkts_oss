import CommonConstant from '../CommonConstant';
import ServiceException from './ServiceException';

export default class OSSException extends ServiceException {
  resourceType: string;
  header: string;
  method: string;

  constructor(resourceType?: string, header?: string, method?: string, errorMessage?: string, cause?: Error,
    errorCode?: string, requestId?: string, hostId?: string,
    rawResponseError?: string,
    ec?: string) {
    super(errorMessage, cause, errorCode, requestId, hostId, rawResponseError, ec);
    this.resourceType = resourceType ?? CommonConstant.BLANK;
    this.header = header ?? CommonConstant.BLANK;
    this.method = method ?? CommonConstant.BLANK;

    this.message += this.resourceType == CommonConstant.BLANK?CommonConstant.BLANK: "\n[ResourceType]: " + this.resourceType;
    this.message += this.header == CommonConstant.BLANK?CommonConstant.BLANK: "\n[Header]: " + this.header;
    this.message += this.method == CommonConstant.BLANK?CommonConstant.BLANK: "\n[Method]: " + this.method;
  }
}