import { cryptoFramework } from '@kit.CryptoArchitectureKit';
import { buffer } from '@kit.ArkTS';
import util from '@ohos.util';

export default class CryptoUtil {
  private static readonly BASE64_HELPER = new util.Base64Helper();

  public static toBase64String(uint8Array: Uint8Array) {
    return CryptoUtil.BASE64_HELPER.encodeToStringSync(uint8Array);
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
    md.updateSync(CryptoUtil.getDataBlob(toCalc));
    return md.digestSync();
  }

  public static getUint8Array(input: string, algName:buffer.BufferEncoding): Uint8Array {
    return new Uint8Array(buffer.from(input, algName).buffer);
  }

  public static getUint8ArrayByHex(hexStr:string):Uint8Array {
    return new Uint8Array(buffer.from(hexStr, 'hex').buffer);
  }

  public static getDataBlob(input: string, algName:buffer.BufferEncoding = 'utf-8'): cryptoFramework.DataBlob {
    return {
      data: CryptoUtil.getUint8Array(input, algName)
    }
  }

  private static genSymKeyByData(symKeyBlob: cryptoFramework.DataBlob, algName: string) {
    let aesGenerator = cryptoFramework.createSymKeyGenerator(algName);
    let symKey = aesGenerator.convertKeySync(symKeyBlob);
    console.info('[Sync]convertKey success');
    return symKey;
  }

  public static hmacSha256DataBlob(key: cryptoFramework.DataBlob,
    data: cryptoFramework.DataBlob): cryptoFramework.DataBlob {
    let mac = cryptoFramework.createMac('SHA256');
    mac.initSync(CryptoUtil.genSymKeyByData(key, 'HMAC'));
    mac.updateSync(data);
    return mac.doFinalSync();
  }

  public static sm4Encrypt(key: string, toEncrypt: string): string {
    let symKey = CryptoUtil.genSymKeyByData(CryptoUtil.getDataBlob(key), 'SM4_128');
    let cipher = cryptoFramework.createCipher('SM4_128|ECB|PKCS7');
    cipher.initSync(cryptoFramework.CryptoMode.ENCRYPT_MODE, symKey, null);
    let result = cipher.doFinalSync(CryptoUtil.getDataBlob(toEncrypt));
    return buffer.from(result.data).toString('hex');
  }

  public static sm4Decrypt(key: string, toDecrypt: string):string {
    let symKey = CryptoUtil.genSymKeyByData(CryptoUtil.getDataBlob(key), 'SM4_128');
    let decoder = cryptoFramework.createCipher('SM4_128|ECB|PKCS7');
    decoder.initSync(cryptoFramework.CryptoMode.DECRYPT_MODE, symKey, null);
    let result = decoder.doFinalSync(CryptoUtil.getDataBlob(toDecrypt, 'hex'));
    return buffer.from(result.data).toString('hex');
  }

  public static sm3Encrypt(input: string): string {
    let md = cryptoFramework.createMd('SM3');
    md.updateSync(CryptoUtil.getDataBlob(input));
    let result = md.digestSync();
    return buffer.from(result.data).toString('hex');
  }

  private static convertStrToPubKey(keyStr: string): cryptoFramework.PubKey {
    let pubKeyStr = keyStr.startsWith('04') ? keyStr.slice(2) : keyStr
    let pkPart1 = pubKeyStr.slice(0, pubKeyStr.length / 2)
    let pkPart2 = pubKeyStr.slice(pubKeyStr.length / 2)
    let pubKeySpec: cryptoFramework.ECCPubKeySpec = {
      params: cryptoFramework.ECCKeyUtil.genECCCommonParamsSpec('NID_sm2'),
      algName: 'SM2',
      specType: cryptoFramework.AsyKeySpecType.PUBLIC_KEY_SPEC,
      pk: {
        x: BigInt(`0x${pkPart1}`),
        y: BigInt(`0x${pkPart2}`),
      }
    }
    let keypairGenerator = cryptoFramework.createAsyKeyGeneratorBySpec(pubKeySpec)
    return keypairGenerator.generatePubKeySync()
  }

  private static generateSM2PriKey(priKey: string): cryptoFramework.PriKey {
    let sm2CommonParamsSpec = cryptoFramework.ECCKeyUtil.genECCCommonParamsSpec('NID_sm2');
    let sm2KeyPairSpec: cryptoFramework.ECCPriKeySpec = {
      algName: "SM2",
      specType: cryptoFramework.AsyKeySpecType.PRIVATE_KEY_SPEC,
      params: sm2CommonParamsSpec,
      sk: BigInt(`0x${priKey}`),
    };
    let generatorBySpec = cryptoFramework.createAsyKeyGeneratorBySpec(sm2KeyPairSpec);
    return generatorBySpec.generatePriKeySync();
  }

  public static sm2Encrypt(priKeyStr: string, toEncrypt: string): string {
    let pubKey = CryptoUtil.convertStrToPubKey(priKeyStr);
    let cipher = cryptoFramework.createCipher('SM2_256|SM3');
    cipher.initSync(cryptoFramework.CryptoMode.ENCRYPT_MODE, pubKey, null);
    let result = cipher.doFinalSync(CryptoUtil.getDataBlob(toEncrypt));
    return buffer.from(result.data).toString('hex');
  }

  public static sm2Decrypt(priKeyStr: string, toDecrypt: string): string {
    let priKey = CryptoUtil.generateSM2PriKey(priKeyStr);
    let decoder = cryptoFramework.createCipher('SM2_256|SM3');
    decoder.initSync(cryptoFramework.CryptoMode.DECRYPT_MODE, priKey, null);
    let result = decoder.doFinalSync(CryptoUtil.getDataBlob(toDecrypt, 'hex'));
    return buffer.from(result.data).toString('hex');
  }

  public static sm2Sign(priKeyStr:string, toSign:string): string {
    let signer = cryptoFramework.createSign('SM2_256|SM3');
    signer.initSync(CryptoUtil.generateSM2PriKey(priKeyStr));
    let result = signer.signSync(CryptoUtil.getDataBlob(toSign));
    return buffer.from(result.data).toString('hex');
  }

  public static sm2Verify(pubKeyStr:string,unSignStr:string, signedData: string): boolean {
    let verifier = cryptoFramework.createVerify('SM2_256|SM3');
    verifier.initSync(CryptoUtil.convertStrToPubKey(pubKeyStr));

    return verifier.verifySync(CryptoUtil.getDataBlob(unSignStr), CryptoUtil.getDataBlob(signedData, 'hex'));
  }
}