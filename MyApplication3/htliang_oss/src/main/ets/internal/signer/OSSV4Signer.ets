import RequestMessage from '../../common/comm/RequestMessage';
import OSSHeaders from '../OSSHeaders';
import { SignParameters } from '../SignParameters';
import OSSSignerBase from './OSSSignerBase';
import OSSSignerParams from './OSSSignerParams';
import HttpUtil from '../../common/utils/HttpUtil'
import BinaryUtil from '../../common/utils/BinaryUtil';
import { cryptoFramework } from '@kit.CryptoArchitectureKit';
import Credentials from '../../common/auth/Credentials';


export default class OSSV4Signer extends OSSSignerBase {
  static DEFAULT_SIGNED_HEADERS: Array<string> = ["content-type", "content-md5"]
  static ISO8601_DATETIME_FORMAT = "yyyyMMdd'T'HHmmss'Z'";
  static ISO8601_DATE_FORMAT = "yyyyMMdd";
  static SEPARATOR_BACKSLASH = "/";
  static OSS4_HMAC_SHA256 = "OSS4-HMAC-SHA256";
  static TERMINATOR = "aliyun_v4_request";
  static SECRET_KEY_PREFIX = "aliyun_v4";
  additionalSignedHeaders: Set<string> = new Set<string>();
  requestDateTime: Date = new Date();

  constructor(signerParams: OSSSignerParams) {
    super(signerParams);
  }

  private static getIso8601DateTime(date: Date): string {
    const year = date.getUTCFullYear();
    const month = ('0' + (date.getUTCMonth() + 1)).slice(-2);
    const day = ('0' + date.getUTCDate()).slice(-2);
    const hours = ('0' + date.getUTCHours()).slice(-2);
    const minutes = ('0' + date.getUTCMinutes()).slice(-2);
    const seconds = ('0' + date.getUTCSeconds()).slice(-2);

    return `${year}${month}${day}T${hours}${minutes}${seconds}Z`;
  }

  private static getIso8601Date(date: Date): string {
    ;
    const year = date.getUTCFullYear();
    const month = ('0' + (date.getUTCMonth() + 1)).slice(-2);
    const day = ('0' + date.getUTCDate()).slice(-2);

    return `${year}${month}${day}`;
  }

  private getDateTime(): string {
    return OSSV4Signer.getIso8601DateTime(this.requestDateTime);
  }

  private getDate(): string {
    return OSSV4Signer.getIso8601Date(this.requestDateTime);
  }


  private hasDefaultSignedHeaders(header: string): boolean {
    if (OSSV4Signer.DEFAULT_SIGNED_HEADERS.includes(header)) {
      return true;
    }
    return header.startsWith(OSSHeaders.OSS_PREFIX);
  }

  private hasSignedHeaders(header: string): boolean {
    if (this.hasDefaultSignedHeaders(header)) {
      return true;
    }
    return this.additionalSignedHeaders.has(header);
  }

  private hasAdditionalSignedHeaders(): boolean {
    return (this.additionalSignedHeaders != null) && this.additionalSignedHeaders.size > 0;
  }

  private sortMap(map: Map<string, string>): Map<string, string> {
    const sortedKeys = Array.from(map.keys()).sort(); // 对键进行排序
    const sortedMap = new Map<string, string>();

    for (const key of sortedKeys) {
      let value = map.get(key);
      if (!value) {
        continue
      }
      sortedMap.set(key, value);
    }

    return sortedMap;
  }

  private buildSortedHeadersMap(map: Map<string, string>): Map<string, string> {
    const unsortedMap = new Map<string, string>();
    for (const key of map.keys()) {
      let lowerKey = key.toLowerCase();
      if (this.hasSignedHeaders(lowerKey)) {
        let value = map.get(key);
        if (!value) {
          continue
        }

        unsortedMap.set(lowerKey, value);
      }
    }

    return this.sortMap(unsortedMap);
  }

  private resolveAdditionalSignedHeaders(request: RequestMessage, headerNames: Set<string>): void {
    const signedHeaders: Set<string> = new Set<string>();

    for (const additionalHeader of headerNames) {
      const additionalHeaderKey: string = additionalHeader.toLowerCase();

      for (const header of request.headers.entries()) {
        const headerKey: string = header[0].toLowerCase();

        if (headerKey === additionalHeaderKey && !this.hasDefaultSignedHeaders(additionalHeaderKey)) {
          signedHeaders.add(additionalHeaderKey);
        }
      }
    }

    this.additionalSignedHeaders = signedHeaders;
  }

  private addSignedHeaderIfNeeded(request: RequestMessage): void {
    const signedHeaders: Set<string> = this.additionalSignedHeaders;

    if (signedHeaders.has(OSSHeaders.HOST.toLowerCase()) &&
      !request.headers.has(OSSHeaders.HOST)) {
      request.addHeader(OSSHeaders.HOST, request.endpoint?.host ?? '');
    }
  }

  private addOSSContentSha256Header(request: RequestMessage): void {
    request.addHeader(OSSHeaders.OSS_CONTENT_SHA256, "UNSIGNED-PAYLOAD");
  }


  protected addDateHeaderIfNeeded(request: RequestMessage): void {
    let now: Date = new Date();

    if (this.signerParams.tickOffset !== 0) {
      now.setTime(now.getTime() + this.signerParams.tickOffset);
    }

    this.requestDateTime = now;
    request.headers.set(OSSHeaders.OSS_DATE, this.getDateTime());
  }

  private buildCanonicalRequest(request: RequestMessage): string {
    const method: string = request.method;
    const resourcePath: string = this.signerParams.resourcePath;

    let canonicalString: string = "";

    // http method + "\n"
    canonicalString += method + "\n";

    // Canonical URI + "\n"
    canonicalString += HttpUtil.urlEncode(resourcePath, true) + SignParameters.NEW_LINE;

    // Canonical Query String + "\n"
    const parameters: Map<string, string> = request.parameters;
    let orderMap: Map<string, string> = new Map<string, string>();
    if (parameters) {
      parameters.forEach((value, key) => {
        orderMap.set(HttpUtil.urlEncode(key.trim(), false), HttpUtil.urlEncode(value.trim(), false));
      })
    }

    let separator: string = "";
    let canonicalPart: string = "";
    this.sortMap(orderMap).forEach((value, key) => {
      canonicalPart += separator + key;
      if (value && value.trim() !== "") {
        canonicalPart += "=" + value;
      }
      separator = "&";
    })

    canonicalString += canonicalPart + "\n";

    // Canonical Headers + "\n"
    orderMap = this.buildSortedHeadersMap(request.headers);
    canonicalPart = "";
    orderMap.forEach((value, key) => {
      canonicalPart += key + ":" + value.trim() + "\n";
    })

    canonicalString += canonicalPart + "\n";

    // Additional Headers + "\n"
    const canonicalPartStr: string = Array.from(this.additionalSignedHeaders).join(";");
    canonicalString += canonicalPartStr + "\n";

    // Hashed PayLoad
    let hashedPayLoad: string | undefined = request.headers.get(OSSHeaders.OSS_CONTENT_SHA256);
    if (!hashedPayLoad) {
      hashedPayLoad = "UNSIGNED-PAYLOAD";
    }
    canonicalString += hashedPayLoad;

    return canonicalString;
  }

  private getRegion(): string {
    if (this.signerParams.cloudBoxId) {
      return this.signerParams.cloudBoxId;
    }
    return this.signerParams.region ? this.signerParams.region : '';
  }

  private getProduct(): string {
    return this.signerParams.product ? this.signerParams.product : '';
  }

  private buildScope(): string {
    return `${this.getDate()}${OSSV4Signer.SEPARATOR_BACKSLASH}${this.getRegion()}${OSSV4Signer.SEPARATOR_BACKSLASH}${this.getProduct()}${OSSV4Signer.SEPARATOR_BACKSLASH}${OSSV4Signer.TERMINATOR}`;
  }

  private buildStringToSign(canonicalString: string): string {
    return `${OSSV4Signer.OSS4_HMAC_SHA256}${SignParameters.NEW_LINE}${this.getDateTime()}${SignParameters.NEW_LINE}${this.buildScope()}${SignParameters.NEW_LINE}${BinaryUtil.toHex(BinaryUtil.calculateSha256(canonicalString))}`;
  }

  private buildSigningKey(): cryptoFramework.DataBlob {
    let signingSecret =
      BinaryUtil.getDataBlob(OSSV4Signer.SECRET_KEY_PREFIX + this.signerParams.credentials.getSecretAccessKey());
    let signingDate = BinaryUtil.hmacSha256DataBlob(signingSecret, BinaryUtil.getDataBlob(this.getDate()));
    let signingRegion = BinaryUtil.hmacSha256DataBlob(signingDate, BinaryUtil.getDataBlob(this.getRegion()));
    let signingService = BinaryUtil.hmacSha256DataBlob(signingRegion, BinaryUtil.getDataBlob(this.getProduct()));

    return BinaryUtil.hmacSha256DataBlob(signingService, BinaryUtil.getDataBlob(OSSV4Signer.TERMINATOR));
  }

  private buildSignature(signingKey: cryptoFramework.DataBlob, stringToSign: string): string {
    let result = BinaryUtil.hmacSha256DataBlob(signingKey, BinaryUtil.getDataBlob(stringToSign));
    return BinaryUtil.toHex(result);
  }

  private buildAuthorization(signature: string): string {
    let credential =
      "Credential=" + this.signerParams.credentials.getAccessKeyId() + OSSV4Signer.SEPARATOR_BACKSLASH +
      this.buildScope();
    let signedHeaders = !this.hasAdditionalSignedHeaders() ? "" :
      ",AdditionalHeaders=" + Array.from(this.additionalSignedHeaders).join(";");
    let sign = ",Signature=" + signature;
    return "OSS4-HMAC-SHA256 " + credential + signedHeaders + sign;
  }

  protected addAuthorizationHeader(request: RequestMessage) {
    const canonicalRequest = this.buildCanonicalRequest(request);
    const stringToSign = this.buildStringToSign(canonicalRequest);
    const signingKey = this.buildSigningKey();
    const signature = this.buildSignature(signingKey, stringToSign);
    const authorization = this.buildAuthorization(signature);

    // 打印调试信息
    // console.log("canonicalRequest:\n" + canonicalRequest);
    // console.log("stringToSign:\n" + stringToSign);
    // console.log("signingKey:\n" + BinaryUtil.toHex(signingKey));
    // console.log("signature:\n" + signature);
    // console.log("authorization:\n" + authorization);

    request.addHeader(OSSHeaders.AUTHORIZATION, authorization);
  }

  public sign(request: RequestMessage) {
    try {
      this.addDateHeaderIfNeeded(request);
      if (this.isAnonymous()) {
        return;
      }
      this.resolveAdditionalSignedHeaders(request, request.originalRequest?.getAdditionalHeaderNames() ?? new Set());
      this.addSignedHeaderIfNeeded(request);
      this.addSecurityTokenHeaderIfNeeded(request);
      this.addOSSContentSha256Header(request);
      this.addAuthorizationHeader(request);
    } catch (error) {
      throw new Error("Error signing the request: " + error);
    }
  }

  public presign(request: RequestMessage): void {
    const cred: Credentials = this.signerParams.credentials;

    // date
    const requestDateTime: Date = new Date();
    const expiration: Date | undefined = this.signerParams.expiration;
    if (!expiration) {
      throw new Error("expiration cannot be null");
    }
    const expires: number = (expiration.getTime() - requestDateTime.getTime()) / 1000;
    const expiresStr: string = String(expires);
    request.addParameter("x-oss-date", OSSV4Signer.getIso8601DateTime(requestDateTime));
    request.addParameter("x-oss-expires", expiresStr);

    // signed header
    this.resolveAdditionalSignedHeaders(request, this.signerParams.additionalHeaderNames);
    this.addSignedHeaderIfNeeded(request);
    if (this.hasAdditionalSignedHeaders()) {
      request.addParameter("x-oss-additional-headers", Array.from(this.additionalSignedHeaders).join(";"));
    }

    // token
    if (cred.useSecurityToken()) {
      request.addParameter("x-oss-security-token", cred.getSecurityToken());
    }

    request.addParameter("x-oss-signature-version", "OSS4-HMAC-SHA256");
    request.addParameter("x-oss-credential",
      this.signerParams.credentials.getAccessKeyId() + "/" + this.buildScope());

    // sign
    const canonicalRequest: string = this.buildCanonicalRequest(request);
    const stringToSign: string = "OSS4-HMAC-SHA256\n" +
    this.getDateTime() + "\n" +
    this.buildScope() + "\n" +
    BinaryUtil.toHex(BinaryUtil.calculateSha256(canonicalRequest));
    const signingKey: cryptoFramework.DataBlob = this.buildSigningKey();
    const signature: string = this.buildSignature(signingKey, stringToSign);

    // console.log("canonicalRequest:\n" + canonicalRequest);
    // console.log("stringToSign:\n" + stringToSign);
    // console.log("signingKey:\n" + BinaryUtil.toHex(signingKey));
    // console.log("signature:\n" + signature);

    request.addParameter("x-oss-signature", signature);
  }

  private signPolicy(policy: string, date: Date): cryptoFramework.DataBlob {
    let signingSecret =
      BinaryUtil.getDataBlob(OSSV4Signer.SECRET_KEY_PREFIX + this.signerParams.credentials.getSecretAccessKey());
    let signingDate =
      BinaryUtil.hmacSha256DataBlob(signingSecret, BinaryUtil.getDataBlob(OSSV4Signer.getIso8601Date(date)));
    let signingRegion = BinaryUtil.hmacSha256DataBlob(signingDate, BinaryUtil.getDataBlob(this.getRegion()));
    let signingService = BinaryUtil.hmacSha256DataBlob(signingRegion, BinaryUtil.getDataBlob(this.getProduct()));
    let signingKey = BinaryUtil.hmacSha256DataBlob(signingService, BinaryUtil.getDataBlob(OSSV4Signer.TERMINATOR));
    return BinaryUtil.hmacSha256DataBlob(signingKey, BinaryUtil.getDataBlob(policy));
  }
}