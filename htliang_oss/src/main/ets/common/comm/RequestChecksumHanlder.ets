import CheckedInputStream from "@htliang/java_type/src/main/ets/java/util/zip/CheckedInputStream";
import CRC64 from "../utils/CRC64";
import RequestHandler from "./RequestHandler";
import RequestMessage from "./RequestMessage";

export default class RequestChecksumHandler implements RequestHandler {
  public handle(request: RequestMessage): void {
    let originalInputStream = request.getContent();
    if (!originalInputStream) {
      return;
    }

    let crc = new CRC64();
    let checkedInputStream = new CheckedInputStream(originalInputStream, crc);
    request.setContent(checkedInputStream);
  }
}