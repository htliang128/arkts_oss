export default  class StringUtils {
  private constructor() {}

  public static startsWithWhitespace(charSeq: string): boolean {
    return charSeq.length === 0 ? false : /\s/.test(charSeq.charAt(0));
  }

  public static endsWithWhitespace(charSeq: string): boolean {
    return charSeq.length === 0 ? false : /\s/.test(charSeq.charAt(charSeq.length - 1));
  }
}