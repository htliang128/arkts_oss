export default  class BackedList<T extends Node> extends Array<T> {
  private branchContent: Node[];
  private branch: AbstractBranch;

  public constructor(branch: AbstractBranch, branchContent: Node[]) {
    this(branch, branchContent, branchContent.length);
  }

  public constructor(branch: AbstractBranch, branchContent: Node[], capacity: number) {
    super(capacity);
    this.branch = branch;
    this.branchContent = branchContent;
  }

  public constructor(branch: AbstractBranch, branchContent: Node[], initialContent: T[]) {
    super(initialContent);
    this.branch = branch;
    this.branchContent = branchContent;
  }

  public add(node: T): boolean {
    this.branch.addNode(node);
    return super.push(node) > 0;
  }

  public addAt(index: number, node: T): void {
    const size = this.length;
    if (index < 0) {
      throw new IndexOutOfBoundsException(`Index value: ${index} is less than zero`);
    } else if (index > size) {
      throw new IndexOutOfBoundsException(`Index value: ${index} cannot be greater than the size: ${size}`);
    } else {
      let realIndex: number;
      if (size === 0) {
        realIndex = this.branchContent.length;
      } else if (index < size) {
        realIndex = this.branchContent.indexOf(this[index]);
      } else {
        realIndex = this.branchContent.indexOf(this[size - 1]) + 1;
      }

      this.branch.addNode(realIndex, node);
      super.splice(index, 0, node);
    }
  }

  public set(index: number, node: T): T {
    let realIndex = this.branchContent.indexOf(this[index]);
    if (realIndex < 0) {
      realIndex = index === 0 ? 0 : Number.MAX_VALUE;
    }

    if (realIndex < this.branchContent.length) {
      this.branch.removeNode(this[index]);
      this.branch.addNode(realIndex, node);
    } else {
      this.branch.removeNode(this[index]);
      this.branch.addNode(node);
    }

    this.branch.childAdded(node);
    return super.splice(index, 1, node)[0];
  }

  public remove(object: any): boolean {
    if (object instanceof Node) {
      this.branch.removeNode(object);
    }

    const index = this.indexOf(object);
    if (index > -1) {
      super.splice(index, 1);
      return true;
    }
    return false;
  }

  public removeAt(index: number): T {
    const node = super.splice(index, 1)[0];
    if (node != null) {
      this.branch.removeNode(node);
    }
    return node;
  }

  public addAll(collection: Collection<T>): boolean {
    this.ensureCapacity(this.length + collection.length);
    let count = this.length;

    for (const item of collection) {
      this.add(item);
      count--;
    }

    return count !== 0;
  }

  public addAllAt(index: number, collection: Collection<T>): boolean {
    this.ensureCapacity(this.length + collection.length);
    let count = this.length;

    for (const item of collection) {
      this.addAt(index++, item);
      count--;
    }

    return count !== 0;
  }

  public clear(): void {
    for (const node of this) {
      this.branchContent.remove(node);
      this.branch.childRemoved(node);
    }

    super.length = 0;
  }

  public addLocal(node: T): void {
    super.push(node);
  }
}