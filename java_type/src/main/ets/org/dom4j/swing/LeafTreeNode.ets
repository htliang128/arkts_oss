export default  class LeafTreeNode implements TreeNode {
  protected static EMPTY_ENUMERATION: Enumeration<TreeNode> = {
    hasMoreElements: () => false,
    nextElement: () => null,
  };

  private parent: TreeNode | null = null;
  protected xmlNode: Node | null = null;

  public constructor();
  public constructor(xmlNode: Node);
  public constructor(parent: TreeNode, xmlNode: Node);
  public constructor(arg1?: Node | TreeNode, arg2?: Node) {
    if (arg1 instanceof Node) {
      this.xmlNode = arg1;
    } else if (arg1 && arg2) {
      this.parent = arg1;
      this.xmlNode = arg2;
    }
  }

  public children(): Enumeration<TreeNode> {
    return LeafTreeNode.EMPTY_ENUMERATION;
  }

  public getAllowsChildren(): boolean {
    return false;
  }

  public getChildAt(childIndex: number): TreeNode | null {
    return null;
  }

  public getChildCount(): number {
    return 0;
  }

  public getIndex(node: TreeNode): number {
    return -1;
  }

  public getParent(): TreeNode | null {
    return this.parent;
  }

  public isLeaf(): boolean {
    return true;
  }

  public toString(): string {
    const text = this.xmlNode?.getText();
    return text ? text.trim() : "";
  }

  public setParent(parent: LeafTreeNode): void {
    this.parent = parent;
  }

  public getXmlNode(): Node | null {
    return this.xmlNode;
  }
}