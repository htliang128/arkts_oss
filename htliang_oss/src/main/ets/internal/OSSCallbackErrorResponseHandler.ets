import { HttpStatusCode } from "@ohos/axios";
import ResponseHandler from "../common/comm/ResponseHandler";
import ResponseMessage from "../common/comm/ResponseMessage";
import ResponseParseException from "../common/parser/ResponseParseException";
import ExceptionFactory from "../common/utils/ExceptionFactory";
import { OSSUtils } from "./OSSUtils";
import ResponseParsers from "./ResponseParsers";

export default class OSSCallbackErrorResponseHandler implements ResponseHandler {
  private static errorResponseParser: ResponseParsers.ErrorResponseParser = new ResponseParsers.ErrorResponseParser();

  handle(response: ResponseMessage): void {
    if (response.getStatusCode() === HttpStatusCode.NonAuthoritativeInformation) {
      try {
        let errorResult = OSSCallbackErrorResponseHandler.errorResponseParser.parse(response);
        throw ExceptionFactory.createOSSException(errorResult, response.getErrorResponseAsString());
      } catch (e) {
        if (e instanceof ResponseParseException) {
          throw ExceptionFactory.createInvalidResponseException(response.getRequestId(),
            response.getErrorResponseAsString(), e as Error);
        }
        throw e as Error;
      } finally {
        OSSUtils.safeCloseResponse(response);
      }
    }
  }
}