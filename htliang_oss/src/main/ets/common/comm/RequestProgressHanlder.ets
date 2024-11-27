// import ProgressListener from "../../event/ProgressListener";
// import { WebServiceRequest } from "../../internal/model/WebServiceRequest";
// import NullPointerException from "@htliang/java_type/src/main/ets/java/lang/NullPointerException"
// import HttpHeaders from "../utils/HttpHeaders";
// import RequestHandler from "./RequestHandler";
// import RequestMessage from "./RequestMessage";
//
// export default class RequestProgressHandler implements RequestHandler {
//   public handle( request:RequestMessage) :void {
//
//   const originalRequest:WebServiceRequest | undefined = request.getOriginalRequest();
//   if (!originalRequest) {
//     throw new NullPointerException('originalRequest is undefined');
//   }
//   let  listener:ProgressListener = originalRequest.getProgressListener();
//   const  headers = request.getHeaders();
//   let contentLengthStr = headers.get(HttpHeaders.CONTENT_LENGTH);
//   if (contentLengthStr) {
//   try {
//   let contentLength = Number.parseInt(contentLengthStr);
//   publishRequestContentLength(listener, contentLength);
// } catch (NumberFormatException e) {
//   logException("Cannot parse the Content-Length header of the request: ", e);
// }
// }
//
// InputStream content = request.getContent();
// if (content == null) {
//   return;
// }
// if (!content.markSupported()) {
//   content = new BufferedInputStream(content);
// }
// request.setContent(listener == ProgressListener.NOOP ? content
//   : ProgressInputStream.inputStreamForRequest(content, originalRequest));
// }
// }