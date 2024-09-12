import Credentials from '../../common/auth/Credentials';

export default class OSSSignerParams {
  private _resourcePath: string;

  public set resourcePath(value: string) {
    this._resourcePath = value;
  }

  public get resourcePath(): string {
    return this._resourcePath;
  }

  private _credentials: Credentials;

  public set credentials(value: Credentials) {
    this._credentials = value;
  }

  public get credentials(): Credentials {
    return this._credentials;
  }

  private _product: string | undefined;

  public set product(value: string | undefined) {
    this._product = value;
  }

  public get product(): string | undefined {
    return this._product;
  }

  private _region: string | undefined;

  public set region(value: string | undefined) {
    this._region = value;
  }

  public get region(): string | undefined {
    return this._region;
  }

  private _tickOffset: number;

  public set tickOffset(value: number) {
    this._tickOffset = value;
  }

  public get tickOffset(): number {
    return this._tickOffset;
  }

  private _cloudBoxId: string | undefined;

  public set cloudBoxId(value: string | undefined) {
    this._cloudBoxId = value;
  }

  public get cloudBoxId(): string | undefined {
    return this._cloudBoxId;
  }

  private _expiration: Date | undefined;

  public set expiration(value: Date | undefined) {
    this._expiration = value;
  }

  public get expiration(): Date | undefined {
    return this._expiration;
  }

  private _additionalHeaderNames: Set<string> = new Set();

  public set additionalHeaderNames(value: Set<string>) {
    this._additionalHeaderNames = value;
  }

  public get additionalHeaderNames(): Set<string> {
    return this._additionalHeaderNames;
  }

  constructor(resourcePath: string, credentials: Credentials) {
    this._resourcePath = resourcePath;
    this._credentials = credentials;
    this._tickOffset = 0;
  }
}