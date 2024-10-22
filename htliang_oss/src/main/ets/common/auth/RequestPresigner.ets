import RequestMessage from '../comm/RequestMessage';

export interface RequestPresigner {
  presign(request: RequestMessage): void;
}