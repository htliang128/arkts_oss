export default  class PerThreadSingleton<T> {
  private singletonClassName: string | null = null;
  private perThreadCache: Map<number, WeakReference<T>> = new Map();

  constructor() {}

  reset(): void {
    this.perThreadCache = new Map();
  }

  instance(): T | null {
    let singletonInstancePerThread: T | null = null;
    let ref: WeakReference<T> | undefined = this.perThreadCache.get(Thread.currentThread().id);
    if (ref && ref.get()) {
      singletonInstancePerThread = ref.get();
    } else {
      try {
        let clazz: any = require(this.singletonClassName!);
        singletonInstancePerThread = new clazz();
      } catch (error) {
        console.error(error);
      }

      if (singletonInstancePerThread) {
        this.perThreadCache.set(Thread.currentThread().id, new WeakReference(singletonInstancePerThread));
      }
    }

    return singletonInstancePerThread;
  }

  setSingletonClassName(singletonClassName: string): void {
    this.singletonClassName = singletonClassName;
  }
}