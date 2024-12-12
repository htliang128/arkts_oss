export default  class BranchTreeNode extends LeafTreeNode {
  protected children: TreeNode[] | null = null;

  constructor();
  constructor(xmlNode: Branch);
  constructor(parent: TreeNode, xmlNode: Branch);
  constructor(arg1?: TreeNode | Branch, arg2?: Branch) {
    if (arg1 instanceof Branch) {
      super(arg1);
    } else if (arg1 && arg2) {
      super(arg1, arg2);
    } else {
      super();
    }
  }

  public children(): Iterable<TreeNode> {
    return {
      [Symbol.iterator]: () => {
        let index = -1;
        return {
          next: () => {
            index++;
            if (index < this.getChildCount()) {
              return { value: this.getChildAt(index), done: false };
            } else {
              return { done: true };
            }
          }
        };
      }
    };
  }

  public getAllowsChildren(): boolean {
    return true;
  }

  public getChildAt(childIndex: number): TreeNode {
    return this.getChildList()[childIndex];
  }

  public getChildCount(): number {
    return this.getChildList().length;
  }

  public getIndex(node: TreeNode): number {
    return this.getChildList().indexOf(node);
  }

  public isLeaf(): boolean {
    return this.getXmlBranch().nodeCount() <= 0;
  }

  public toString(): string {
    return this.xmlNode.getName();
  }

  protected getChildList(): TreeNode[] {
    if (this.children === null) {
      this.children = this.createChildList();
    }
    return this.children;
  }

  protected createChildList(): TreeNode[] {
    const branch = this.getXmlBranch();
    const size = branch.nodeCount();
    const childList: TreeNode[] = [];

    for (let i = 0; i < size; i++) {
      const node = branch.node(i);
      if (node instanceof CharacterData) {
        let text = node.getText();
        if (text == null) continue;

        text = text.trim();
        if (text.length <= 0) continue;
      }

      childList.push(this.createChildTreeNode(node));
    }

    return childList;
  }

  protected createChildTreeNode(xmlNode: Node): TreeNode {
    return xmlNode instanceof Branch
      ? new BranchTreeNode(this, xmlNode)
      : new LeafTreeNode(this, xmlNode);
  }

  protected getXmlBranch(): Branch {
    return this.xmlNode as Branch;
  }
}