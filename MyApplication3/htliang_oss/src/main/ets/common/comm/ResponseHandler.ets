import ResponseMessage from './ResponseMessage';

export default interface ResponseHandler {

  handle(response: ResponseMessage): void;

}