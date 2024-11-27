import CheckedInputStream from "@htliang/java_type/src/main/ets/java/util/zip/CheckedInputStream";
import CRC64 from "../utils/CRC64";
import ResponseHandler from "./ResponseHandler";
import ResponseMessage from "./ResponseMessage";

export default class ResponseChecksumHandler implements ResponseHandler {
  public handle(response: ResponseMessage): void {
    let originalInputStream = response.getContent();
    if (!originalInputStream) {
      return;
    }

    let crc = new CRC64();
    let checkedInputStream = new CheckedInputStream(originalInputStream, crc);
    response.setContent(checkedInputStream);
  }
}