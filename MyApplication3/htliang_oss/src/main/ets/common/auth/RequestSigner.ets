import RequestMessage from '../comm/RequestMessage';

export interface RequestSigner {
  sign(request: RequestMessage): void;
}