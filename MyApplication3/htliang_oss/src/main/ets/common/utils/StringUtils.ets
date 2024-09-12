export default class StringUtils {
  private static readonly LOCALE_ENGLISH = 'en-US';
  public static DEFAULT_ENCODING = 'UTF-8';
  public static COMMA_SEPARATOR = ',';

  public static toInteger(value: string): number {
    return parseInt(value);
  }

  public static toString(value: string): string {
    return value;
  }

  public static toBoolean(value: string): boolean {
    return Boolean(value);
  }

  public static fromInteger(value: number): string {
    return value.toString();
  }

  public static fromLong(value: number): string {
    return value.toString();
  }

  public static fromString(value: string): string {
    return value;
  }

  public static fromBoolean(value: boolean): string {
    return value.toString();
  }

  public static fromBigInteger(value: number): string {
    return value.toString();
  }

  public static fromBigDecimal(value: number): string {
    return value.toString();
  }

  public static fromFloat(value: number): string {
    return value.toString();
  }

  public static fromDouble(value: number): string {
    return value.toString();
  }

  public static fromByte(value: number): string {
    return value.toString();
  }

  public static replace(originalString: string, partToMatch: string, replacement: string): string {
    return originalString.split(partToMatch).join(replacement);
  }

  public static replaceEach(text: string, searchList: string[], replacementList: string[]): string {
    const searchLength = searchList.length;
    const replacementLength = replacementList.length;

    if (StringUtils.isNullOrEmpty(text) || (searchLength === 0 && replacementLength === 0)) {
      return text;
    }

    if (searchLength !== replacementLength) {
      throw new Error(`Search and Replace array lengths don't match: ${searchLength} vs ${replacementLength}`);
    }

    const noMoreMatchesForReplIndex: boolean[] = new Array(searchLength).fill(false);
    let textIndex = -1;
    let replaceIndex = -1;
    let tempIndex = -1;

    for (let i = 0; i < searchLength; i++) {
      if (noMoreMatchesForReplIndex[i] || StringUtils.isNullOrEmpty(searchList[i]) || replacementList[i] === null) {
        continue;
      }
      tempIndex = text.indexOf(searchList[i]);

      if (tempIndex === -1) {
        noMoreMatchesForReplIndex[i] = true;
      } else {
        if (textIndex === -1 || tempIndex < textIndex) {
          textIndex = tempIndex;
          replaceIndex = i;
        }
      }
    }

    if (textIndex === -1) {
      return text;
    }

    let start = 0;
    let increase = 0;

    for (let i = 0; i < searchList.length; i++) {
      if (searchList[i] === null || replacementList[i] === null) {
        continue;
      }
      const greater = replacementList[i].length - searchList[i].length;
      if (greater > 0) {
        increase += 3 * greater;
      }
    }

    increase = Math.min(increase, Math.floor(text.length / 5));

    let buf: string = "";

    while (textIndex !== -1) {
      for (let i = start; i < textIndex; i++) {
        buf += text.charAt(i);
      }
      buf += replacementList[replaceIndex];

      start = textIndex + searchList[replaceIndex].length;

      textIndex = -1;
      replaceIndex = -1;
      tempIndex = -1;

      for (let i = 0; i < searchLength; i++) {
        if (noMoreMatchesForReplIndex[i] || searchList[i] === null || searchList[i] === '' ||
          replacementList[i] === null) {
          continue;
        }
        tempIndex = text.indexOf(searchList[i], start);

        if (tempIndex === -1) {
          noMoreMatchesForReplIndex[i] = true;
        } else {
          if (textIndex === -1 || tempIndex < textIndex) {
            textIndex = tempIndex;
            replaceIndex = i;
          }
        }
      }
    }

    const textLength = text.length;
    for (let i = start; i < textLength; i++) {
      buf += text.charAt(i);
    }

    return buf;
  }


  public static join(joiner: string, ...parts: string[]): string {
    return parts.join(joiner);
  }

  public static joinCollection(joiner: string, collection: string[]): string {
    return collection.join(joiner);
  }

  public static trim(value: string): string {
    return value.trim();
  }

  public static isNullOrEmpty(value: string): boolean {
    return !value || value.trim() === '';
  }

  public static hasValue(value: string): boolean {
    return !!value && value.trim() !== '';
  }

  public static lowerCase(str: string): string {
    return str.toLowerCase();
  }

  public static upperCase(str: string): string {
    return str.toUpperCase();
  }

  public static compare(str1: string, str2: string): number {
    if (!str1 || !str2) {
      throw new Error("Arguments cannot be null");
    }

    return str1.localeCompare(str2, StringUtils.LOCALE_ENGLISH);
  }

  private static isWhiteSpace(ch: string): boolean {
    return /\s/.test(ch);
  }

  public static appendCompactedString(destination: string, source: string): string {
    const compactedString = source.replace(/\s+/g, ' ');
    return destination + compactedString;
  }

  public static beginsWithIgnoreCase(data: string, seq: string): boolean {
    return data.toLowerCase().startsWith(seq.toLowerCase());
  }
}