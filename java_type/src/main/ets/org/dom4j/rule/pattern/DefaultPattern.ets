export default  class DefaultPattern implements Pattern {
  private filter: NodeFilter;

  constructor(filter: NodeFilter) {
    this.filter = filter;
  }

  public matches(node: Node): boolean {
    return this.filter.matches(node);
  }

  public getPriority(): number {
    return 0.5;
  }

  public getUnionPatterns(): Pattern[] | null {
    return null;
  }

  public getMatchType(): number {
    return 0;
  }

  public getMatchesNodeName(): string | null {
    return null;
  }
}