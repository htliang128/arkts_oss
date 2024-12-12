export default class NodeTypePattern implements Pattern {
  public static readonly ANY_ATTRIBUTE = new NodeTypePattern(2);
  public static readonly ANY_COMMENT = new NodeTypePattern(8);
  public static readonly ANY_DOCUMENT = new NodeTypePattern(9);
  public static readonly ANY_ELEMENT = new NodeTypePattern(1);
  public static readonly ANY_PROCESSING_INSTRUCTION = new NodeTypePattern(7);
  public static readonly ANY_TEXT = new NodeTypePattern(3);

  private nodeType: number;

  constructor(nodeType: number) {
    this.nodeType = nodeType;
  }

  public matches(node: Node): boolean {
    return node.getNodeType() === this.nodeType;
  }

  public getPriority(): number {
    return 0.5;
  }

  public getUnionPatterns(): Pattern[] | null {
    return null;
  }

  public getMatchType(): number {
    return this.nodeType;
  }

  public getMatchesNodeName(): string | null {
    return null;
  }
}