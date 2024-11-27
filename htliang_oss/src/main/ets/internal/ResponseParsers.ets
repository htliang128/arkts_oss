import ResponseMessage from "../common/comm/ResponseMessage";
import ResponseParser from "../common/parser/ResponseParser";
import GenericResult from "../model/GenericResult";
import PutObjectResult from "../model/PutObjectResult";
import OSSHeaders from "./OSSHeaders";
import { OSSUtils } from "./OSSUtils";
import CheckedInputStream from '@htliang/java_type/src/main/ets/java/util/zip/CheckedInputStream';
import OSSErrorResult from './model/OSSErrorResult';
import DomParser from '../aa/DomParser';
import VoidResult from "../model/VoidResult";

namespace ResponseParsers {
  export class PutObjectResponseParser implements ResponseParser<PutObjectResult> {
    parse(response: ResponseMessage): PutObjectResult {
      let result = new PutObjectResult();
      try {
        result.setETag(OSSUtils.trimQuotes(response.getHeaders().get(OSSHeaders.ETAG)));
        result.setVersionId(response.getHeaders().get(OSSHeaders.OSS_HEADER_VERSION_ID));
        result.setRequestId(response.getRequestId() ?? "");
        setCRC(result, response);
        return result;
      } finally {
        safeCloseResponse(response);
      }
    }
  }

  export class PutObjectProcessResponseParser implements ResponseParser<PutObjectResult> {
    parse(response: ResponseMessage): PutObjectResult {
      let result = new PutObjectResult();
      result.setRequestId(response.getRequestId() ?? "");
      result.setETag(OSSUtils.trimQuotes(response.getHeaders().get(OSSHeaders.ETAG)) ?? "");
      result.setVersionId(response.getHeaders().get(OSSHeaders.OSS_HEADER_VERSION_ID));
      result.setCallbackResponseBody(response.getContent());
      result.setResponse(response);
      return result;
    }
  }

  export class RequestIdResponseParser implements ResponseParser<VoidResult> {
    parse(response: ResponseMessage) {
      try {
        let result = new VoidResult();
        result.setResponse(response);
        result.setRequestId(response.getRequestId());
        return result;
      } finally {
        safeCloseResponse(response);
      }
    }
  }

  export class EmptyResponseParser implements ResponseParser<ResponseMessage> {
    parse(response: ResponseMessage): ResponseMessage {
      OSSUtils.safeCloseResponse(response);
      return response;
    }
  }

  export class ErrorResponseParser implements ResponseParser<OSSErrorResult> {
    parse(response: ResponseMessage): OSSErrorResult {
      try {
        let errResponse = response.getErrorResponseAsString();

        return this.parseErrorResponse(errResponse);
      } finally {
        safeCloseResponse(response);
      }
    }

    parseErrorResponse(errResponse: string | undefined): OSSErrorResult {
      let ossErrorResult = new OSSErrorResult();
      if (!errResponse) {
        return ossErrorResult;
      }

      let root = DomParser.getXmlRootElement(errResponse);
      if (!root) {
        return ossErrorResult;
      }
      ossErrorResult.Code = root.getChildText("Code");
      ossErrorResult.Message = root.getChildText("Message");
      ossErrorResult.RequestId = root.getChildText("RequestId");
      ossErrorResult.HostId = root.getChildText("HostId");
      ossErrorResult.ResourceType = root.getChildText("ResourceType");
      ossErrorResult.Method = root.getChildText("Method");
      ossErrorResult.Header = root.getChildText("Header");
      ossErrorResult.EC = root.getChildText("EC");
      return ossErrorResult;
    }
  }

  function setCRC<ResultType extends GenericResult>(result: ResultType, response: ResponseMessage): void {
    const request = response.getRequest();
    const content = request.getContent();
    if (content && content instanceof CheckedInputStream) {
      let checkedIs = content as CheckedInputStream;
      result.setClientCRC(checkedIs.getCheckSum().getValue());
    }


    const strSrvCrc = response.getHeaders().get(OSSHeaders.OSS_HASH_CRC64_ECMA);
    if (strSrvCrc !== undefined) {
      const bi = BigInt(strSrvCrc);
      result.setServerCRC(Number(bi));
    }
  }

  function setServerCRC<ResultType extends GenericResult>(result: ResultType, response: ResponseMessage): void {
    const request = response.getRequest();
    if (request !== null) {
      const strSrvCrc = response.getHeaders().get(OSSHeaders.OSS_HASH_CRC64_ECMA);
      if (strSrvCrc !== undefined) {
        const bi = BigInt(strSrvCrc);
        result.setServerCRC(Number(bi));
      }
    }
  }

  function safeCloseResponse(response: ResponseMessage): void {
    try {
      response.close();
    } catch (ignore) {
    }
  }

  export const putObjectResponseParser = new PutObjectResponseParser();

  export const putObjectProcessResponseParser = new PutObjectProcessResponseParser();
}

export default ResponseParsers;




