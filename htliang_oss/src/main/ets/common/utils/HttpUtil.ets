import StringUtils from './StringUtils';
import util from '@ohos.util';
import { TreeMap } from '@kit.ArkTS';
import CommonConstant from '../CommonConstant';

export default class HttpUtil {
  private static readonly ENCODED_CHARACTERS_WITH_SLASHES: string[] = ["+", "*", "%7E", "%2F"];
  private static readonly ENCODED_CHARACTERS_WITH_SLASHES_REPLACEMENTS: string[] = ["%20", "%2A", "~", "/"];
  private static readonly ENCODED_CHARACTERS_WITHOUT_SLASHES: string[] = ["+", "*", "%7E"];
  private static readonly ENCODED_CHARACTERS_WITHOUT_SLASHES_REPLACEMENTS: string[] = ["%20", "%2A", "~"];

  // Encode a URL segment with special chars replaced.
  public static urlEncodeByEncoding(value: string, encoding: string): string {
    if (value == null) {
      return "";
    }

    try {
      let encodedValue = encodeURIComponent(value);
      // Replace special characters as needed
      encodedValue =
        encodedValue.replace(/\+/g, '%20').replace(/\*/g, '%2A').replace(/~/g, '%7E').replace(/\//g, '%2F');

      return encodedValue;
    } catch (error) {
      console.error('Error encoding URL: ' + error);
      return value;
    }
  }

  public static urlDecode(value: string, encoding: string): string {
    if (StringUtils.isNullOrEmpty(value)) {
      return value;
    }

    try {
      let decodedValue = decodeURIComponent(value);

      return decodedValue;
    } catch (error) {
      throw new Error('Error decoding URL: ' + error);
    }
  }

  public static urlEncode(value: string, ignoreSlashes: boolean): string {
    if (StringUtils.isNullOrEmpty(value)) {
      return value;
    }

    try {
      let encodedValue = encodeURIComponent(value);

      if (ignoreSlashes) {
        encodedValue = encodedValue.replace(/%2F/g, '/');
      }

      return encodedValue;
    } catch (error) {
      throw new Error("FailedToEncodeUri " + value)
    }
  }

  private static replaceEach(str: string, searchList: string[], replacementList: string[]): string {
    return str.split('').map(char => {
      const index = searchList.indexOf(char);
      return index !== -1 ? replacementList[index] : char;
    }).join('');
  }

  public static paramToQueryString(params: TreeMap<string, string>, charset: string): string {
    if (params.isEmpty()) {
      return CommonConstant.BLANK;
    }

    let paramString: string = "";
    let first: boolean = true;

    params.forEach((value, key) => {
      if (!key) {
        return;
      }

      if (!first) {
        paramString += "&";
      }

      paramString += `${HttpUtil.urlEncodeByEncoding(key, charset)}`;
      if (value != null) {
        paramString += `=${HttpUtil.urlEncodeByEncoding(value, charset)}`;
      }

      first = false;
    });

    return paramString;
  }

  private static readonly ISO_8859_1_CHARSET: string = "iso-8859-1";
  private static readonly UTF8_CHARSET: string = "utf-8";

  public static convertHeaderCharsetFromIso88591(headers: TreeMap<string, string>): void {
    HttpUtil.convertHeaderCharset(headers, HttpUtil.ISO_8859_1_CHARSET, HttpUtil.UTF8_CHARSET);
  }

  public static convertHeaderCharsetToIso88591(headers: TreeMap<string, string>): void {
    HttpUtil.convertHeaderCharset(headers, HttpUtil.UTF8_CHARSET, HttpUtil.ISO_8859_1_CHARSET);
  }

  private static convertHeaderCharset(headers: TreeMap<string, string>, fromCharset: string, toCharset: string): void {
    headers.forEach((value, key) => {
      if (value == null) {
        return;
      }

      try {
        let textDecoder = util.TextDecoder.create(toCharset);
        let textEncoder = util.TextEncoder.create(fromCharset);

        headers.set(key, textDecoder.decodeToString(textEncoder.encodeInto(value)));
      } catch (error) {
        throw new Error("Invalid charset name: " + error.message);
      }
    });
  }
}
