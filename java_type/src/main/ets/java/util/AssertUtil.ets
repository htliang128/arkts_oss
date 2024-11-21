import Throwable from "../lang/Throwable";

export default class AssertUtil {
  public static assertTrue(actual: boolean) {
    if (!actual) {
      throw new AssertException('Assert True fail.');
    }
  }

  public static assertInstanceOf(actual: ESObject, expect: ESObject) {
    if (!(actual instanceof expect)) {
      throw new AssertException('Assert InstanceOf fail.');
    }
  }
}

class AssertException extends Throwable {
  constructor(message: string) {
    super(message);
    this.name = 'AssertException';
  }
}