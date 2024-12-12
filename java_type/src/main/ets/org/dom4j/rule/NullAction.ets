export default  class NullAction implements Action {
  public static readonly SINGLETON = new NullAction();

  constructor() {}

  public run(node: Node): void {
    // No operation
  }
}