export default  class SimpleSingleton<T> implements SingletonStrategy<T> {
  private singletonClassName: string | null = null;
  private singletonInstance: T | null = null;

  constructor() {}

  instance(): T | null {
    return this.singletonInstance;
  }

  reset(): void {
    if (this.singletonClassName !== null) {
      try {
        const clazz = require(this.singletonClassName);
        this.singletonInstance = new clazz();
      } catch (error) {
        try {
          const clazz = require(this.singletonClassName);
          this.singletonInstance = new clazz();
        } catch (error) {}
      }
    }
  }

  setSingletonClassName(singletonClassName: string): void {
    this.singletonClassName = singletonClassName;
    this.reset();
  }
}