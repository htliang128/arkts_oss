export default  class SingleIterator<T> implements Iterator<T> {
  private first: boolean = true;
  private object: T | null;

  constructor(object: T) {
    this.object = object;
  }

  public hasNext(): boolean {
    return this.first;
  }

  public next(): IteratorResult<T> {
    if (this.first) {
      const answer = this.object;
      this.object = null;
      this.first = false;
      return { done: false, value: answer as T };
    } else {
      return { done: true, value: undefined as any };
    }
  }

  public remove(): never {
    throw new Error("remove() is not supported by this iterator");
  }

  [Symbol.iterator](): IterableIterator<T> {
    return this;
  }
}