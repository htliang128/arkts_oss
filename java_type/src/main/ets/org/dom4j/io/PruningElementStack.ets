export default class PruningElementStack extends ElementStack {
  private elementHandler: ElementHandler;
  private path: string[];
  private matchingElementIndex: number;

  constructor(path: string[], elementHandler: ElementHandler) {
    super();
    this.path = path;
    this.elementHandler = elementHandler;
    this.checkPath();
  }

  constructor(path: string[], elementHandler: ElementHandler, defaultCapacity: number) {
    super(defaultCapacity);
    this.path = path;
    this.elementHandler = elementHandler;
    this.checkPath();
  }

  public popElement(): Element | null {
    const answer = super.popElement();
    if (this.lastElementIndex === this.matchingElementIndex && this.lastElementIndex >= 0 && this.validElement(answer, this.lastElementIndex + 1)) {
      let parent: Element | null = null;

      for (let i = 0; i <= this.lastElementIndex; i++) {
        parent = this.stack[i];
        if (!this.validElement(parent, i)) {
          parent = null;
          break;
        }
      }

      if (parent !== null) {
        this.pathMatches(parent, answer);
      }
    }

    return answer;
  }

  protected pathMatches(parent: Element, selectedNode: Element): void {
    this.elementHandler.onEnd(this);
    parent.remove(selectedNode);
  }

  protected validElement(element: Element, index: number): boolean {
    const requiredName = this.path[index];
    const name = element.getName();
    return requiredName === name || (requiredName !== null && name !== null && requiredName === name);
  }

  private checkPath(): void {
    if (this.path.length < 2) {
      throw new Error(`Invalid path of length: ${this.path.length} it must be greater than 2`);
    } else {
      this.matchingElementIndex = this.path.length - 2;
    }
  }
}