import ResponseMessage from "../common/comm/ResponseMessage";
import ResponseParser from "../common/parser/ResponseParser";
import GenericResult from "../model/GenericResult";
import PutObjectResult from "../model/PutObjectResult";
import OSSHeaders from "./OSSHeaders";
import { OSSUtils } from "./OSSUtils";
import CheckedInputStream from '@htliang/java_type/src/main/ets/java/util/zip/CheckedInputStream';

namespace ResponseParsers {
  export class PutObjectResponseParser implements ResponseParser<PutObjectResult> {
    parse(response: ResponseMessage): PutObjectResult {
      let result = new PutObjectResult();
      try {
        result.setETag(OSSUtils.trimQuotes(response.headers.get(OSSHeaders.ETAG)) ?? "");
        result.setVersionId(response.headers.get(OSSHeaders.OSS_HEADER_VERSION_ID));
        result.setRequestId(response.getRequestId() ?? "");
        setCRC(result, response);
        return result;
      } finally {
        safeCloseResponse(response);
      }
    }
  }


  function setCRC<ResultType extends GenericResult>(result: ResultType, response: ResponseMessage): void {
    const request = response.getRequest();
    if (request !== null) {
      const content = request.content;
      if (content && content instanceof CheckedInputStream) {
        let checkedIs = content as CheckedInputStream;
        result.setClientCRC(checkedIs.getCheckSum().getValue());
      }


      const strSrvCrc = response.headers.get(OSSHeaders.OSS_HASH_CRC64_ECMA);
      if (strSrvCrc !== undefined) {
        const bi = BigInt(strSrvCrc);
        result.setServerCRC(Number(bi));
      }
    }
  }

  function setServerCRC<ResultType extends GenericResult>(result: ResultType, response: ResponseMessage): void {
    const request = response.getRequest();
    if (request !== null) {
      const strSrvCrc = response.headers.get(OSSHeaders.OSS_HASH_CRC64_ECMA);
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
}




