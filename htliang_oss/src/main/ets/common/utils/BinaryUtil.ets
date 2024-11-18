import { cryptoFramework } from '@kit.CryptoArchitectureKit';
import { buffer } from '@kit.ArkTS';
import util from '@ohos.util';

export default class BinaryUtil {
  static BUFFER_ENCODING: string[] =
    ['ascii', 'utf8', 'utf-8', 'utf16le', 'ucs2', 'ucs-2', 'base64', 'base64url', 'latin1', 'binary', 'hex'];
  static TEXT_ENCODING: string[] =
    ['utf-8ibm866', 'iso-8859-2', 'iso-8859-3', 'iso-8859-4', 'iso-8859-5', 'iso-8859-6', 'iso-8859-7', 'iso-8859-8',
      'iso-8859-8-i', 'iso-8859-10', 'iso-8859-13', 'iso-8859-14', 'iso-8859-15', 'koi8-r', 'koi8-u', 'macintosh',
      'windows-874', 'windows-1250', 'windows-1251', 'windows-1252', 'windows-1253', 'windows-1254', 'windows-1255',
      'windows-1256', 'windows-1257', 'windows-1258', 'x-mac-cyrillic', 'gbk', 'gb18030', 'big5', 'euc-jp',
      'iso-2022-jp', 'shift_jis', 'euc-kr', 'utf-16be', 'utf-16le', 'UTF-8', 'GBK', 'GB2312', 'gb2312', 'GB18030',
      'iso-8859-1']

  public static decodeBufferToString(buf: buffer.Buffer, encoding: string): string {
    let lowerCaseEncoding = encoding.toLowerCase();
    if (BinaryUtil.BUFFER_ENCODING.indexOf(lowerCaseEncoding) != -1) {
      return buf.toString(lowerCaseEncoding)
    }
    if (BinaryUtil.TEXT_ENCODING.indexOf(encoding) === -1) {
      throw new Error(`Currently, encoding ${encoding} is not supported`);
    }
    return BinaryUtil.decodeBufferToStringByTextDecoder(buf, encoding)
  }

  public static encodeToBuffer(str: string, encoding: string): buffer.Buffer {
    let lowerCaseEncoding = encoding.toLowerCase();
    if (BinaryUtil.BUFFER_ENCODING.indexOf(lowerCaseEncoding) != -1) {
      return buffer.from(str, lowerCaseEncoding as buffer.BufferEncoding);
    }
    if (BinaryUtil.TEXT_ENCODING.indexOf(encoding) === -1) {
      throw new Error(`Currently, encoding ${encoding} is not supported`);
    }
    return BinaryUtil.encodeToBufferByTextEncoder(str, encoding)
  }

  private static decodeBufferToStringByTextDecoder(buf: buffer.Buffer, encoding: string): string {
    let textDecoderOptions: util.TextDecoderOptions = {
      fatal: false,
      ignoreBOM: true
    }
    let textDecoder = util.TextDecoder.create(encoding, textDecoderOptions);
    return textDecoder.decodeToString(new Uint8Array(buf.buffer));
  }

  private static encodeToBufferByTextEncoder(str: string, encoding: string): buffer.Buffer {
    let textEncoder = new util.TextEncoder(encoding);
    let result = textEncoder.encodeInto(str);
    return buffer.from(result);
  }


  private static readonly BASE64_HELPER = new util.Base64Helper();

  public static toBase64String(uint8Array: Uint8Array) {
    return BinaryUtil.BASE64_HELPER.encodeToStringSync(uint8Array);
  }

  public static calculateMd5(binaryData: Uint8Array) {
    let md = cryptoFramework.createMd('MD5');
    md.updateSync({
      data: binaryData
    });
    return md.digestSync();
  }


  public static calculateSha256(toCalc: string): cryptoFramework.DataBlob {
    let md = cryptoFramework.createMd('SHA256');
    md.updateSync(BinaryUtil.getDataBlob(toCalc));
    return md.digestSync();
  }

  public static toHex(inputToHex: cryptoFramework.DataBlob): string {
    let uint8Array = inputToHex.data;
    if (!uint8Array) {
      return '';
    }

    return Array.from(uint8Array)
      .map(byte => ('0' + byte.toString(16)).slice(-2))
      .join('');
  }

  public static getUtf8Array(input: string): Uint8Array {
    return new Uint8Array(buffer.from(input, 'utf-8').buffer);
  }

  public static getDataBlob(input: string): cryptoFramework.DataBlob {
    return {
      data: BinaryUtil.getUtf8Array(input)
    }
  }

  private static genSymKeyByData(symKeyBlob: cryptoFramework.DataBlob) {
    let aesGenerator = cryptoFramework.createSymKeyGenerator('HMAC');
    let symKey = aesGenerator.convertKeySync(symKeyBlob);
    console.info('[Sync]convertKey success');
    return symKey;
  }

  public static hmacSha256DataBlob(key: cryptoFramework.DataBlob,
    data: cryptoFramework.DataBlob): cryptoFramework.DataBlob {
    let mac = cryptoFramework.createMac('SHA256');
    mac.initSync(BinaryUtil.genSymKeyByData(key));
    mac.updateSync(data);
    return mac.doFinalSync();
  }
}