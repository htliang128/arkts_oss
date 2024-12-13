import ElementPath from "./ElementPath";

export default  interface ElementHandler {
  onStart(var1: ElementPath): void;
  onEnd(var1: ElementPath): void;
}