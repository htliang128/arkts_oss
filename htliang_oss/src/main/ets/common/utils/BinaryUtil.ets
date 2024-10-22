import { cryptoFramework } from '@kit.CryptoArchitectureKit';
import { buffer } from '@kit.ArkTS';
import util from '@ohos.util';

export default class BinaryUtil {
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