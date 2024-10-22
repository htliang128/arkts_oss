import RequestMessage from './RequestMessage';

export default interface RequestHandler {

  handle(request: RequestMessage): void;

}