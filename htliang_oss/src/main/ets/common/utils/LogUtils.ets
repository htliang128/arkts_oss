import hilog from "@ohos.hilog";
import OSSErrorCode from "../../OSSErrorCode";
import ServiceException from "../exceptions/ServiceException";

export default class LogUtils {
  private static readonly NAME = 'oss';
  private static errorCodeFilterList: string[] = [
    OSSErrorCode.NO_SUCH_BUCKET,
    OSSErrorCode.NO_SUCH_KEY,
    OSSErrorCode.NO_SUCH_UPLOAD,
    OSSErrorCode.NO_SUCH_CORS_CONFIGURATION,
    OSSErrorCode.NO_SUCH_WEBSITE_CONFIGURATION,
    OSSErrorCode.NO_SUCH_LIFECYCLE,
  ]

  public static logException(messagePrefix: string, e: ESObject, logEnabled: boolean = true) {
    let ex = e as Error;
    let detailMessage = messagePrefix + ex.message;
    if (ex instanceof ServiceException && LogUtils.errorCodeFilterList.includes(ex.errorCode ?? '')) {
      if (logEnabled) {
        hilog.debug(0x55, LogUtils.NAME, detailMessage);
      }
      return;
    }
    if (logEnabled) {
      hilog.warn(0x55, LogUtils.NAME, detailMessage);
    }
  }
}