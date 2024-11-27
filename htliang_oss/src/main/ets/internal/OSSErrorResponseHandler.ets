import { HttpStatusCode } from "@ohos/axios";
import ResponseHandler from "../common/comm/ResponseHandler";
import ResponseMessage from "../common/comm/ResponseMessage";
import ResponseParseException from "../common/parser/ResponseParseException";
import ExceptionFactory from "../common/utils/ExceptionFactory";
import OSSErrorCode from "../OSSErrorCode";
import OSSErrorResult from "./model/OSSErrorResult";
import OSSHeaders from "./OSSHeaders";
import { OSSUtils } from "./OSSUtils";
import ResponseParsers from "./ResponseParsers";

export default class OSSErrorResponseHandler implements ResponseHandler {
  private static errorResponseParser: ResponseParsers.ErrorResponseParser = new ResponseParsers.ErrorResponseParser();

  handle(response: ResponseMessage): void {
    if (response.isSuccessful()) {
      return;
    }

    let requestId = response.getRequestId();
    let statusCode = response.getStatusCode();
    if (response.getContent() === undefined) {
      let result: OSSErrorResult | undefined;
      try {
        if (response.getHeaders().hasKey(OSSHeaders.OSS_ERROR)) {
          result = OSSErrorResponseHandler.errorResponseParser.parseErrorResponse(response.getHeaders()
            .get(OSSHeaders.OSS_ERROR));
          if (result.Code === undefined) {
            result == undefined;
          }
        }
      } catch (ignore) {
      }

      if (result) {
        throw ExceptionFactory.createOSSException(result, undefined);
      } else if (statusCode === HttpStatusCode.NotFound) {
        throw ExceptionFactory.createOSSException(requestId, OSSErrorCode.NO_SUCH_KEY, "Not Found");
      } else if (statusCode == HttpStatusCode.NotModified) {
        throw ExceptionFactory.createOSSException(requestId, OSSErrorCode.NOT_MODIFIED, "Not Modified");
      } else if (statusCode == HttpStatusCode.PreconditionFailed) {
        throw ExceptionFactory.createOSSException(requestId, OSSErrorCode.PRECONDITION_FAILED, "Precondition Failed");
      } else if (statusCode == HttpStatusCode.Forbidden) {
        throw ExceptionFactory.createOSSException(requestId, OSSErrorCode.ACCESS_FORBIDDEN, "AccessForbidden");
      } else {
        throw ExceptionFactory.createUnknownOSSException(requestId, statusCode);
      }
    }

    try {
      let errorResult = OSSErrorResponseHandler.errorResponseParser.parse(response);
      throw ExceptionFactory.createOSSException(errorResult, response.getErrorResponseAsString());
    } catch (e) {
      if (e instanceof ResponseParseException) {
        throw ExceptionFactory.createInvalidResponseException(requestId, response.getErrorResponseAsString(),
          e as Error);
      }
      throw e as Error;
    } finally {
      OSSUtils.safeCloseResponse(response);
    }
  }
}