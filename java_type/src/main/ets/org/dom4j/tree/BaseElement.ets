export default  class ContentListFacade<T extends Node> extends Array<T> {
  private branchContent: Array<T>;
  private branch: AbstractBranch;

  constructor(branch: AbstractBranch, branchContent: Array<T>) {
    super();
    this.branch = branch;
    this.branchContent = branchContent;
  }

  public add(node: T): boolean {
    this.branch.childAdded(node);
    return this.branchContent.push(node) > 0;
  }

  public addAt(index: number, node: T): void {
    this.branch.childAdded(node);
    this.branchContent.splice(index, 0, node);
  }

  public set(index: number, node: T): T {
    this.branch.childAdded(node);
    return this.branchContent.splice(index, 1, node)[0];
  }

  public remove(object: any): boolean {
    this.branch.childRemoved(this.asNode(object));
    const index = this.branchContent.indexOf(object);
    if (index > -1) {
      this.branchContent.splice(index, 1);
      return true;
    }
    return false;
  }

  public removeAt(index: number): T {
    const node = this.branchContent.splice(index, 1)[0];
    if (node) {
      this.branch.childRemoved(node);
    }
    return node;
  }

  public addAll(collection: Iterable<T>): boolean {
    let count = this.branchContent.length;
    for (const node of collection) {
      this.add(node);
    }
    return count !== this.branchContent.length;
  }

  public addAllAt(index: number, collection: Iterable<T>): boolean {
    let count = this.branchContent.length;
    for (const node of collection) {
      this.addAt(index++, node);
    }
    return count !== this.branchContent.length;
  }

  public clear(): void {
    for (const node of this.branchContent) {
      this.branch.childRemoved(node);
    }
    this.branchContent.length = 0;
  }

  public removeAll(c: Iterable<any>): boolean {
    for (const object of c) {
      this.branch.childRemoved(this.asNode(object));
    }
    return this.branchContent.filter(item => !c.includes(item)).length > 0;
  }

  public size(): number {
    return this.branchContent.length;
  }

  public isEmpty(): boolean {
    return this.branchContent.length === 0;
  }

  public contains(o: any): boolean {
    return this.branchContent.includes(o);
  }

  public toArray(): Array<T> {
    return [...this.branchContent];
  }

  public toArrayTyped(a: Array<T>): Array<T> {
    return this.branchContent.slice();
  }

  public containsAll(c: Iterable<any>): boolean {
    for (const item of c) {
      if (!this.branchContent.includes(item)) {
        return false;
      }
    }
    return true;
  }

  public get(index: number): T {
    return this.branchContent[index];
  }

  public indexOf(o: any): number {
    return this.branchContent.indexOf(o);
  }

  public lastIndexOf(o: any): number {
    return this.branchContent.lastIndexOf(o);
  }

  protected asNode(object: any): Node {
    if (object instanceof Node) {
      return object;
    } else {
      throw new IllegalAddException(`This list must contain instances of Node. Invalid type: ${object}`);
    }
  }

  protected getBackingList(): Array<T> {
    return this.branchContent;
  }
}