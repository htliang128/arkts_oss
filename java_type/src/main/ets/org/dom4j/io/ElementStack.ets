export default class ElementStack implements ElementPath {
  protected stack: Element[];
  protected lastElementIndex: number;
  private handler: DispatchHandler | null;

  constructor(defaultCapacity: number = 50) {
    this.lastElementIndex = -1;
    this.handler = null;
    this.stack = new Array<Element>(defaultCapacity);
  }

  public setDispatchHandler(dispatchHandler: DispatchHandler): void {
    this.handler = dispatchHandler;
  }

  public getDispatchHandler(): DispatchHandler | null {
    return this.handler;
  }

  public clear(): void {
    this.lastElementIndex = -1;
  }

  public peekElement(): Element | null {
    return this.lastElementIndex < 0 ? null : this.stack[this.lastElementIndex];
  }

  public popElement(): Element | null {
    return this.lastElementIndex < 0 ? null : this.stack[this.lastElementIndex--];
  }

  public pushElement(element: Element): void {
    const length = this.stack.length;
    if (++this.lastElementIndex >= length) {
      this.reallocate(length * 2);
    }
    this.stack[this.lastElementIndex] = element;
  }

  protected reallocate(size: number): void {
    const oldStack = this.stack;
    this.stack = new Array<Element>(size);
    for (let i = 0; i < oldStack.length; i++) {
      this.stack[i] = oldStack[i];
    }
  }

  public size(): number {
    return this.lastElementIndex + 1;
  }

  public getElement(depth: number): Element | null {
    let element: Element | null;
    try {
      element = this.stack[depth];
    } catch (error) {
      element = null;
    }
    return element;
  }

  public getPath(): string {
    if (this.handler === null) {
      this.setDispatchHandler(new DispatchHandler());
    }
    return this.handler.getPath();
  }

  public getCurrent(): Element | null {
    return this.peekElement();
  }

  public addHandler(path: string, elementHandler: ElementHandler): void {
    this.handler?.addHandler(this.getHandlerPath(path), elementHandler);
  }

  public removeHandler(path: string): void {
    this.handler?.removeHandler(this.getHandlerPath(path));
  }

  public containsHandler(path: string): boolean {
    return this.handler ? this.handler.containsHandler(path) : false;
  }

  private getHandlerPath(path: string): string {
    if (this.handler === null) {
      this.setDispatchHandler(new DispatchHandler());
    }

    let handlerPath: string;
    if (path.startsWith("/")) {
      handlerPath = path;
    } else if (this.getPath() === "/") {
      handlerPath = this.getPath() + path;
    } else {
      handlerPath = this.getPath() + "/" + path;
    }
    return handlerPath;
  }
}