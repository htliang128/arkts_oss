export default  interface SingletonStrategy<T> {
  instance(): T;

  reset(): void;
}