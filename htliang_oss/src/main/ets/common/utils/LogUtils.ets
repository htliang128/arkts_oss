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

  public static logException(messagePrefix: string, ex: Error, logEnabled: boolean = true) {
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

  public static warn(detailMessage: string) {
    hilog.debug(0x55, LogUtils.NAME, detailMessage);
  }

  static debug(detailMessage: string) {
    hilog.debug(0x55, LogUtils.NAME, detailMessage);
  }

  static info(detailMessage: string) {
    hilog.info(0x55, LogUtils.NAME, detailMessage);
  }
}