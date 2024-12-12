export default class PruningDispatchHandler extends DispatchHandler {
  constructor() {
    super();
  }

  onEnd(elementPath: ElementPath): void {
    super.onEnd(elementPath);
    if (this.getActiveHandlerCount() === 0) {
      elementPath.getCurrent().detach();
    }
  }
}