import SingletonStrategy from "./SingletonStrategy";

export default  class SimpleSingleton<T> implements SingletonStrategy<T> {
  private singletonInstance: T ;

  constructor(singletonInstance : T) {
    this.singletonInstance = singletonInstance;
  }

  instance(): T {
    return this.singletonInstance;
  }

  reset(): void {
  }
}