export default  class RuleSet {
  private rules: Rule[] = [];
  private ruleArray: Rule[] | null = null;

  constructor() {}

  public toString(): string {
    return super.toString() + ` [RuleSet: ${this.rules} ]`;
  }

  public getMatchingRule(node: Node): Rule | null {
    const matches = this.getRuleArray();

    for (let i = matches.length - 1; i >= 0; --i) {
      const rule = matches[i];
      if (rule.matches(node)) {
        return rule;
      }
    }

    return null;
  }

  public addRule(rule: Rule): void {
    this.rules.push(rule);
    this.ruleArray = null;
  }

  public removeRule(rule: Rule): void {
    const index = this.rules.indexOf(rule);
    if (index !== -1) {
      this.rules.splice(index, 1);
      this.ruleArray = null;
    }
  }

  public addAll(that: RuleSet): void {
    this.rules.push(...that.rules);
    this.ruleArray = null;
  }

  protected getRuleArray(): Rule[] {
    if (!this.ruleArray) {
      this.rules.sort();
      this.ruleArray = [...this.rules];
    }

    return this.ruleArray;
  }
}