import Element from "../Element";
import ElementHandler from "../ElementHandler";
import ElementPath from "../ElementPath";

export default class DispatchHandler implements ElementHandler {
  private atRoot: boolean = true;
  private path: string = "/";
  private pathStack: string[] = [];
  private handlerStack: ElementHandler[] = [];
  private handlers: Map<string, ElementHandler> = new Map();
  private defaultHandler?: ElementHandler;

  constructor() {}

  addHandler(handlerPath: string, handler: ElementHandler): void {
    this.handlers.set(handlerPath, handler);
  }

  removeHandler(handlerPath: string): ElementHandler | undefined {
    return this.handlers.delete(handlerPath) ? this.handlers.get(handlerPath) : undefined;
  }

  containsHandler(handlerPath: string): boolean {
    return this.handlers.has(handlerPath);
  }

  getHandler(handlerPath: string): ElementHandler | undefined {
    return this.handlers.get(handlerPath);
  }

  getActiveHandlerCount(): number {
    return this.handlerStack.length;
  }

  setDefaultHandler(handler: ElementHandler): void {
    this.defaultHandler = handler;
  }

  resetHandlers(): void {
    this.atRoot = true;
    this.path = "/";
    this.pathStack = [];
    this.handlerStack = [];
    this.handlers.clear();
    this.defaultHandler = undefined;
  }

  getPath(): string {
    return this.path;
  }

  onStart(elementPath: ElementPath): void {
    const element: Element = elementPath.getCurrent();
    this.pathStack.push(this.path);
    this.path = this.atRoot ? this.path + element.getName() : this.path + "/" + element.getName();
    this.atRoot = false;

    if (this.handlers.has(this.path)) {
      const handler: ElementHandler = this.handlers.get(this.path)!;
      this.handlerStack.push(handler);
      handler.onStart(elementPath);
    } else if (this.handlerStack.length === 0 && this.defaultHandler) {
      this.defaultHandler.onStart(elementPath);
    }
  }

  onEnd(elementPath: ElementPath): void {
    if (this.handlers.has(this.path)) {
      const handler: ElementHandler = this.handlers.get(this.path)!;
      this.handlerStack.pop();
      handler.onEnd(elementPath);
    } else if (this.handlerStack.length === 0 && this.defaultHandler) {
      this.defaultHandler.onEnd(elementPath);
    }

    this.path = this.pathStack.pop()!;
    if (this.pathStack.length === 0) {
      this.atRoot = true;
    }
  }
}