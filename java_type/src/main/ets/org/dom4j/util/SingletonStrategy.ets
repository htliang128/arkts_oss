export default  interface SingletonStrategy<T> {
  instance(): T;

  reset(): void;

  setSingletonClassName(var1: string): void;
}