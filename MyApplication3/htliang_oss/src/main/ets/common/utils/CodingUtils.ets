import IOUtils from './IOUtils';

export default class CodingUtils {
  public static assertParameterNotNull(param: ESObject, paramName: string): void {
    if (param === null || param === undefined) {
      throw new Error(`Parameter '${paramName}' cannot be null or undefined`);
    }
  }

  public static assertParameterInRange(param: number, lower: number, upper: number): void {
    if (!CodingUtils.checkParamRange(param, lower, true, upper, true)) {
      throw new Error(`${param} is not in the valid range [${lower}, ${upper}]`);
    }
  }

  public static assertStringNotNullOrEmpty(param: string, paramName: string): void {
    CodingUtils.assertParameterNotNull(param, paramName);
    if (param.trim().length === 0) {
      throw new Error(`Parameter '${paramName}' cannot be empty or whitespace`);
    }
  }

  public static assertListNotNullOrEmpty(param: ESObject[], paramName: string): void {
    CodingUtils.assertParameterNotNull(param, paramName);
    if (param.length === 0) {
      throw new Error(`Parameter '${paramName}' cannot be an empty list`);
    }
  }

  public static isNullOrEmpty(value: string): boolean {
    return value === null || value.trim().length === 0;
  }

  public static assertTrue(condition: boolean, message: string): void {
    if (!condition) {
      throw new Error(message);
    }
  }

  public static checkParamRange(param: number, from: number, leftInclusive: boolean, to: number,
    rightInclusive: boolean): boolean {
    if (leftInclusive && rightInclusive) {
      return from <= param && param <= to;
    }
    if (leftInclusive && !rightInclusive) {
      return from <= param && param < to;
    }
    if (!leftInclusive && !rightInclusive) {
      return from < param && param < to;
    }
    return from < param && param <= to;
  }

  public static assertFileExist(filePath: string, key: string): void {
    if (!IOUtils.checkFilePath(filePath)) {
      throw new Error(`File at path '${filePath}' does not exist for key '${key}'`);
    }
  }
}
