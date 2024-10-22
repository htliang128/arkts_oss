import buffer from '@ohos.buffer';
import BinaryUtil from '../common/utils/BinaryUtil';

export default class SignV2Utils {
  static uriEncoding(uri: string): string {
    let result = '';

    for (const c of uri) {
      if (
        (c >= 'A' && c <= 'Z') ||
          (c >= 'a' && c <= 'z') ||
          (c >= '0' && c <= '9') ||
          c === '_' || c === '-' ||
          c === '~' || c === '.'
      ) {
        result += c;
      } else if (c === '/') {
        result += '%2F';
      } else {
        const bytes = BinaryUtil.getUtf8Array(c);
        for (const byte of bytes) {
          result += '%' + byte.toString(16).toUpperCase();
        }
      }
    }

    return result;
  }
}