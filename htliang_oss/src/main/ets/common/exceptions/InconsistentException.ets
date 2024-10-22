export default class InconsistentException extends Error {
  private _clientChecksum: number;

  public set clientChecksum(value: number) {
    this._clientChecksum = value;
  }

  public get clientChecksum(): number {
    return this._clientChecksum;
  }

  private _serverChecksum: number;

  public set serverChecksum(value: number) {
    this._serverChecksum = value;
  }

  public get serverChecksum(): number {
    return this._serverChecksum;
  }

  private _requestId: string;

  public set requestId(value: string) {
    this._requestId = value;
  }

  public get requestId(): string {
    return this._requestId;
  }

  constructor(clientChecksum: number, serverChecksum: number, requestId: string) {
    super();
    this._clientChecksum = clientChecksum;
    this._serverChecksum = serverChecksum;
    this._requestId = requestId;

    this.name = "InconsistentException";
    this.message = "InconsistentException " + "\n[RequestId]: " + this._requestId + "\n[ClientChecksum]: "
      + this._clientChecksum + "\n[ServerChecksum]: " + this._serverChecksum;
  }
}