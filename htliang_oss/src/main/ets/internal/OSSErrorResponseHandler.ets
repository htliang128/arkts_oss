import ResponseHandler from "../common/comm/ResponseHandler";
import ResponseMessage from "../common/comm/ResponseMessage";
import BinaryUtil from "../common/utils/BinaryUtil";
import ExceptionFactory from "../common/utils/ExceptionFactory";
import OSSErrorResult from "./model/OSSErrorResult";
import OSSHeaders from "./OSSHeaders";
import ResponseParsers from "./ResponseParsers";

export default class OSSErrorResponseHandler implements ResponseHandler {
  private static  errorResponseParser:ResponseParsers.ErrorResponseParser = new ResponseParsers.ErrorResponseParser();
  handle(response: ResponseMessage): void {
    if (response.isSuccessful()) {
      return;
    }

    let requestId = response.getRequestId();
    let statusCode = response.getStatusCode();
    if (response.content === undefined) {
      let result:OSSErrorResult | undefined;
      try {
        if (response.headers.hasKey(OSSHeaders.OSS_ERROR)) {
          result = OSSErrorResponseHandler.errorResponseParser.parseErrorResponse(response.headers.get(OSSHeaders.OSS_ERROR));
          if (result.Code === undefined) {
            result == undefined;
          }
        }
      } catch (ignore) {
      }

      if (result) {
        throw ExceptionFactory.createNetworkException()
      }
    }


    throw new Error("Method not implemented.");
  }
}