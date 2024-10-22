import ResponseMessage from "../common/comm/ResponseMessage";
import ResponseParser from "../common/parser/ResponseParser";
import GenericResult from "../model/GenericResult";
import PutObjectResult from "../model/PutObjectResult";
import OSSHeaders from "./OSSHeaders";
import { OSSUtils } from "./OSSUtils";

export class PutObjectReponseParser implements ResponseParser<PutObjectResult> {
  parse(response: ResponseMessage): PutObjectResult {
    let result = new PutObjectResult();
    try {
      result.setETag(OSSUtils.trimQuotes(response.headers.get(OSSHeaders.ETAG))??"");
      result.setVersionId(response.headers.get(OSSHeaders.OSS_HEADER_VERSION_ID));
      result.setRequestId(response.getRequestId()??"");
      setCRC(result, response);
      return result;
    } finally {
      safeCloseResponse(response);
    }


    throw new Error("Method not implemented.");
  }

}

function setCRC<ResultType extends GenericResult>(result: ResultType, response: ResponseMessage): void {
  const request = response.getRequest();
  if (request !== null) {
    const inputStream = request.content();
    if (inputStream instanceof CheckedInputStream) {
      const checkedInputStream = inputStream as CheckedInputStream;
      result.setClientCRC(checkedInputStream.getChecksum().getValue());
    }

    const strSrvCrc = response.getHeaders()[OSSHeaders.OSS_HASH_CRC64_ECMA];
    if (strSrvCrc !== undefined) {
      const bi = BigInt(strSrvCrc);
      result.setServerCRC(Number(bi));
    }
  }
}