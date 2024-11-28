import BinaryUtil from '../common/utils/BinaryUtil';
import uri from '@ohos.uri'
import ClientConfiguration from '../ClientConfiguration';
import HttpUtil from '../common/utils/HttpUtil';
import ObjectMetadata from '../model/ObjectMetadata';
import DateUtil from '../common/utils/DateUtil';
import ResponseHeaderOverrides from './model/ResponseHeaderOverrides';
import CommonConstant from '../common/CommonConstant';
import ResponseMessage from '../common/comm/ResponseMessage';
import CallbackInfo from '../model/CallbackInfo';
import { CallbackBodyType } from '../model/CallbackBodyType';
import CodingUtils from '../common/utils/CodingUtils';
import OSSHeaders from './OSSHeaders';
import InconsistentException from '../common/exceptions/InconsistentException';
import { TreeMap } from '@kit.ArkTS';
import InputStream from '@htliang/java_type/src/main/ets/java/io/InputStream';

export class OSSUtils {
  private static readonly BUCKET_NAMING_CREATION_REGEX = /^[a-z0-9][a-z0-9-]{1,61}[a-z0-9]$/;
  private static readonly BUCKET_NAMING_REGEX = /^[a-z0-9][a-z0-9-_]{1,61}[a-z0-9]$/;
  private static readonly ENDPOINT_REGEX = /^[a-zA-Z0-9._-]+$/;

  static validateEndpoint(endpoint: string | null): boolean {
    return endpoint !== null && OSSUtils.ENDPOINT_REGEX.test(endpoint);
  }

  static ensureEndpointValid(endpoint: string): void {
    if (!OSSUtils.validateEndpoint(endpoint)) {
      throw new Error(`The endpoint ${endpoint} is invalid, please check it.`);
    }
  }

  static validateBucketName(bucketName: string | undefined): boolean {
    return bucketName !== undefined && OSSUtils.BUCKET_NAMING_REGEX.test(bucketName);
  }

  static ensureBucketNameValid(bucketName: string | undefined): void {
    if (!OSSUtils.validateBucketName(bucketName)) {
      throw new Error(`The bucket name "${bucketName}" is invalid. A bucket name must: 1) be comprised of lower-case characters, numbers or dash(-); 2) start with lower case or numbers; 3) be between 3-63 characters long.`);
    }
  }

  static validateBucketNameCreation(bucketName: string | null): boolean {
    return bucketName !== null && OSSUtils.BUCKET_NAMING_CREATION_REGEX.test(bucketName);
  }

  static ensureBucketNameCreationValid(bucketName: string): void {
    if (!OSSUtils.validateBucketNameCreation(bucketName)) {
      throw new Error(`The bucket name "${bucketName}" is invalid. A bucket name must: 1) be comprised of lower-case characters, numbers or dash(-); 2) start with lower case or numbers; 3) be between 3-63 characters long.`);
    }
  }

  static validateObjectKey(key: string | undefined): boolean {
    return OSSUtils.validateObjectKeyEx(key, false);
  }

  static validateObjectKeyEx(key: string | undefined, strict: boolean): boolean {
    if (key === undefined || key.length === 0) {
      return false;
    }

    let bytes: Uint8Array;
    try {
      bytes = BinaryUtil.getUtf8Array(key);
    } catch (e) {
      return false;
    }

    const firstChar = key.charAt(0);
    if (firstChar === '\\' || (strict && firstChar === '?')) {
      return false;
    }

    return bytes.length > 0 && bytes.length < 1024;
  }

  static ensureObjectKeyValid(key: string | undefined): void {
    if (!OSSUtils.validateObjectKey(key)) {
      throw new Error(`The object key "${key}" is invalid. An object name should be between 1 - 1023 bytes long when encoded as UTF-8 and cannot contain LF or CR or unsupported chars in XML1.0, and cannot begin with "/" or "\\".`);
    }
  }

  static ensureObjectKeyValidEx(key: string, strict: boolean): void {
    if (!OSSUtils.validateObjectKeyEx(key, strict)) {
      throw new Error(`The object key "${key}" is invalid. An object name should be between 1 - 1023 bytes long when encoded as UTF-8 and cannot contain LF or CR or unsupported chars in XML1.0, and cannot begin with "/" or "\\".`);
    }
  }

  static ensureLiveChannelNameValid(liveChannelName: string): void {
    if (!OSSUtils.validateObjectKey(liveChannelName)) {
      throw new Error(`The live channel "${liveChannelName}" is invalid..`);
    }
  }

  static determineFinalEndpoint(endpoint: uri.URI, bucket: string, clientConfig: ClientConfiguration): uri.URI {
    let combinedEndpoint = "";
    combinedEndpoint += `${endpoint.scheme}://`;
    combinedEndpoint += OSSUtils.buildCanonicalHost(endpoint, bucket, clientConfig);
    combinedEndpoint += parseInt(endpoint.port, 10) >= 0 ? `:${endpoint.port}` : "";
    combinedEndpoint += endpoint.path ?? CommonConstant.BLANK;
    return new uri.URI(combinedEndpoint);
  }

  private static buildCanonicalHost(endpoint: uri.URI, bucket: string, clientConfig: ClientConfiguration): string {
    const host = endpoint.host;
    const isCname =
      clientConfig.isSupportCname() && !OSSUtils.cnameExcludeFilter(host, clientConfig.getCnameExcludeList());

    return bucket && !isCname && !clientConfig.isSupportCname() ? `${bucket}.${host}` : host;
  }

  private static cnameExcludeFilter(hostToFilter: string, excludeList: string[]): boolean {
    if (hostToFilter && hostToFilter.trim() !== '') {
      const canonicalHost = hostToFilter.toLowerCase();
      return !excludeList.some(excl => canonicalHost.endsWith(excl));
    }
    throw new Error('Host name cannot be null.');
  }

  static determineResourcePath(bucket: string | undefined, key: string | undefined, sldEnabled: boolean): string {
    return sldEnabled ? OSSUtils.makeResourcePathWithBucket(bucket, key) : OSSUtils.makeResourcePathWithoutBucket(key);
  }

  static makeResourcePathWithoutBucket(key: string | undefined): string {
    return key ? OSSUtils.urlEncodeKey(key) : '';
  }

  static makeResourcePathWithBucket(bucket: string | undefined, key: string | undefined): string {
    return bucket ? `${bucket}/${key ? OSSUtils.urlEncodeKey(key) : ''}` : '';
  }

  private static urlEncodeKey(key: string): string {
    if (key.startsWith('/')) {
      return HttpUtil.urlEncodeByEncoding(key, 'UTF-8');
    }

    return key.split('/').map(part => HttpUtil.urlEncodeByEncoding(part, 'UTF-8')).join('/');
  }

  static populateRequestMetadata(headers: TreeMap<string, string>, metadata: ObjectMetadata): void {
    let rawMetadata: ReadonlyMap<string, ESObject> = metadata.getRawMetadata();
    if (rawMetadata) {
      rawMetadata.forEach((value: ESObject, key: string) => {
        if (key !== null && value !== null) {
          headers.set(key.trim(), value.toString().trim());
        }
      })
    }

    const userMetadata = metadata.getUserMetadata();
    if (userMetadata) {
      userMetadata.forEach((value: string, key: string) => {
        if (key !== null && value !== null) {
          headers.set(`x-oss-meta-${key.trim()}`, value.trim());
        }
      })
    }
  }

  static addHeader(headers: Map<string, string>, header: string, value: string | null): void {
    if (value !== null) {
      headers.set(header, value);
    }
  }

  static addDateHeader(headers: Map<string, string>, header: string, value: Date | null): void {
    if (value !== null) {
      headers.set(header, DateUtil.formatRfc822Date(value));
    }
  }

  static addStringListHeader(headers: Map<string, string>, header: string, values: string[]): void {
    if (values && values.length > 0) {
      headers.set(header, values.join(', '));
    }
  }

  static removeHeader(headers: Map<string, string>, header: string): void {
    headers.delete(header);
  }

  static join(strings: string[]): string {
    return strings.join(', ');
  }

  static trimQuotes(s: string | undefined): string | undefined {
    if (!s) {
      return undefined;
    }

    s = s.trim();
    if (s.startsWith("\"")) {
      return s.substring(1);
    }

    if (s.endsWith("\"")) {
      return s.substring(0, s.length - 1);
    }

    return s;
  }

  static populateResponseHeaderParameters(params: Map<string, string>, responseHeaders: ResponseHeaderOverrides): void {
    if (responseHeaders) {
      if (responseHeaders.getCacheControl()) {
        params.set(ResponseHeaderOverrides.RESPONSE_HEADER_CACHE_CONTROL,
          responseHeaders.getCacheControl() ?? CommonConstant.BLANK);
      }
      if (responseHeaders.getContentDisposition()) {
        params.set(ResponseHeaderOverrides.RESPONSE_HEADER_CONTENT_DISPOSITION,
          responseHeaders.getContentDisposition() ?? CommonConstant.BLANK);
      }
      if (responseHeaders.getContentEncoding()) {
        params.set(ResponseHeaderOverrides.RESPONSE_HEADER_CONTENT_ENCODING,
          responseHeaders.getContentEncoding() ?? CommonConstant.BLANK);
      }
      if (responseHeaders.getContentLanguage()) {
        params.set(ResponseHeaderOverrides.RESPONSE_HEADER_CONTENT_LANGUAGE,
          responseHeaders.getContentLanguage() ?? CommonConstant.BLANK);
      }
      if (responseHeaders.getContentType()) {
        params.set(ResponseHeaderOverrides.RESPONSE_HEADER_CONTENT_TYPE,
          responseHeaders.getContentType() ?? CommonConstant.BLANK);
      }
      if (responseHeaders.getExpires()) {
        params.set(ResponseHeaderOverrides.RESPONSE_HEADER_EXPIRES,
          responseHeaders.getExpires() ?? CommonConstant.BLANK);
      }
    }
  }

  static safeCloseResponse(response: ResponseMessage): void {
    try {
      response.close();
    } catch (e) {
      // Handle error
    }
  }

  static mandatoryCloseResponse(response: ResponseMessage): void {
    try {
      response.abort();
    } catch (e) {
      // Handle error
    }
  }

  static determineInputStreamLength(inputStream: InputStream, hintLength: number,
    useChunkEncoding: boolean = false): number {
    if (useChunkEncoding) {
      return -1;
    }

    if (hintLength <= 0 || !inputStream.markSupported()) {
      return -1;
    }

    return hintLength;
  }

  static joinETags(eTags: string[]): string {
    return eTags.join(', ');
  }

  static stringifyCallback(callback: CallbackInfo): string {
    let jsonBody = "{";
    jsonBody += `"callbackUrl":"${callback.getCallbackUrl()}"`;
    let callbackHost = callback.getCallbackHost();
    if (callbackHost && callbackHost.length > 0) {
      jsonBody += `"callbackHost":",${callback.getCallbackHost()}"`;
    }
    jsonBody += `",callbackBody":"${callback.getCallbackBody()}"`;
    if (callback.getCallbackBodyType() == CallbackBodyType.JSON) {
      jsonBody += `",callbackBodyType":"application/json"`;
    } else {
      jsonBody += `",callbackBodyType":"application/x-www-form-urlencoded"`;
    }
    // SNI, optional
    if (callback.getCallbackSNI()) {
      jsonBody += `",callbackSNI":"application/x-www-form-urlencoded"`;
    }
    jsonBody += `"callbackBody":${callback.getCallbackSNI()}`;
    jsonBody += "}";

    return jsonBody;
  }

  static stringifyCallbackVar(callback: CallbackInfo): string {
    let jsonBody = "{";
    const callbackVar: Map<string, string> = callback.getCallbackVar();
    callbackVar.forEach((value, key) => {
      if (value && key) {
        jsonBody += (jsonBody == "{") ? "" : ",";
        jsonBody += `"${key}":"${value}"`
      }
    })
    jsonBody += "}";

    return jsonBody;
  }

  static ensureCallbackValid(callback: CallbackInfo | undefined): void {
    if (callback) {
      CodingUtils.assertStringNotNullOrEmpty(callback.getCallbackUrl() ?? CommonConstant.BLANK, 'Callback.callbackUrl');
      CodingUtils.assertParameterNotNull(callback.getCallbackBody(), 'Callback.callbackBody');
    }
  }

  static populateRequestCallback(headers: TreeMap<string, string>, callback: CallbackInfo | undefined): void {
    if (callback) {
      const jsonCb = OSSUtils.stringifyCallback(callback);
      const base64Cb = BinaryUtil.toBase64String(BinaryUtil.getUtf8Array(jsonCb));

      headers.set(OSSHeaders.OSS_HEADER_CALLBACK, base64Cb);

      if (callback.hasCallbackVar()) {
        const jsonCbVar = OSSUtils.stringifyCallbackVar(callback);
        let base64CbVar = BinaryUtil.toBase64String(BinaryUtil.getUtf8Array(jsonCbVar));
        base64CbVar = base64CbVar.replace(/\n/g, '').replace(/\r/g, '');
        headers.set(OSSHeaders.OSS_HEADER_CALLBACK_VAR, base64CbVar);
      }
    }
  }

  static checkChecksum(clientChecksum: number | undefined, serverChecksum: number | undefined,
    requestId: string = CommonConstant.BLANK): void {
    if (clientChecksum && serverChecksum && clientChecksum !== serverChecksum) {
      throw new InconsistentException(clientChecksum, serverChecksum, requestId);
    }
  }

  static toEndpointURI(endpoint: string, defaultProtocol: string): uri.URI {
    if (endpoint && !endpoint.includes('://')) {
      endpoint = `${defaultProtocol}://${endpoint}`;
    }
    try {
      return new uri.URI(endpoint);
    } catch (e) {
      throw new Error(e.message);
    }
  }
}