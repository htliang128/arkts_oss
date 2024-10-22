import ResponseMessage from '../common/comm/ResponseMessage';

export default abstract class GenericResult {
  private requestId?: string;
  private clientCRC?: number;
  private serverCRC?: number;
  private response?: ResponseMessage;

  getRequestId(): string | undefined {
    return this.requestId;
  }

  setRequestId(requestId: string): void {
    this.requestId = requestId;
  }

  getClientCRC(): number | undefined {
    return this.clientCRC;
  }

  setClientCRC(clientCRC: number): void {
    this.clientCRC = clientCRC;
  }

  getServerCRC(): number | undefined {
    return this.serverCRC;
  }

  setServerCRC(serverCRC: number): void {
    this.serverCRC = serverCRC;
  }

  getResponse(): ResponseMessage | undefined {
    return this.response;
  }

  setResponse(response: ResponseMessage): void {
    this.response = response;
  }
}
