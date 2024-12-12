export default  class Mode {
  private ruleSets: RuleSet[] = new Array(14);
  private elementNameRuleSets: Map<string, RuleSet> | undefined;
  private attributeNameRuleSets: Map<string, RuleSet> | undefined;

  constructor() {}

  public fireRule(node: Node): void {
    if (node) {
      const rule = this.getMatchingRule(node);
      if (rule) {
        const action = rule.getAction();
        if (action) {
          action.run(node);
        }
      }
    }
  }

  public applyTemplates(element: Element): void {
    for (let i = 0, size = element.attributeCount(); i < size; ++i) {
      const attribute = element.attribute(i);
      this.fireRule(attribute);
    }

    for (let i = 0, size = element.nodeCount(); i < size; ++i) {
      const node = element.node(i);
      this.fireRule(node);
    }
  }

  public applyTemplates(document: Document): void {
    for (let i = 0, size = document.nodeCount(); i < size; ++i) {
      const node = document.node(i);
      this.fireRule(node);
    }
  }

  public addRule(rule: Rule): void {
    let matchType = rule.getMatchType();
    const name = rule.getMatchesNodeName();
    if (name) {
      if (matchType === 1) {
        this.elementNameRuleSets = this.addToNameMap(this.elementNameRuleSets, name, rule);
      } else if (matchType === 2) {
        this.attributeNameRuleSets = this.addToNameMap(this.attributeNameRuleSets, name, rule);
      }
    }

    if (matchType >= 14) {
      matchType = 0;
    }

    if (matchType === 0) {
      for (let i = 1, size = this.ruleSets.length; i < size; ++i) {
        const ruleSet = this.ruleSets[i];
        if (ruleSet) {
          ruleSet.addRule(rule);
        }
      }
    }

    this.getRuleSet(matchType).addRule(rule);
  }

  public removeRule(rule: Rule): void {
    let matchType = rule.getMatchType();
    const name = rule.getMatchesNodeName();
    if (name) {
      if (matchType === 1) {
        this.removeFromNameMap(this.elementNameRuleSets, name, rule);
      } else if (matchType === 2) {
        this.removeFromNameMap(this.attributeNameRuleSets, name, rule);
      }
    }

    if (matchType >= 14) {
      matchType = 0;
    }

    this.getRuleSet(matchType).removeRule(rule);
    if (matchType !== 0) {
      this.getRuleSet(0).removeRule(rule);
    }
  }

  public getMatchingRule(node: Node): Rule | null {
    let matchType = node.getNodeType();
    let name: string;
    let ruleSet: RuleSet | undefined;
    let answer: Rule | null = null;

    if (matchType === 1 && this.elementNameRuleSets) {
      name = node.getName();
      ruleSet = this.elementNameRuleSets.get(name);
      if (ruleSet) {
        answer = ruleSet.getMatchingRule(node);
        if (answer) {
          return answer;
        }
      }
    } else if (matchType === 2 && this.attributeNameRuleSets) {
      name = node.getName();
      ruleSet = this.attributeNameRuleSets.get(name);
      if (ruleSet) {
        answer = ruleSet.getMatchingRule(node);
        if (answer) {
          return answer;
        }
      }
    }

    if (matchType < 0 || matchType >= this.ruleSets.length) {
      matchType = 0;
    }

    ruleSet = this.ruleSets[matchType];
    if (ruleSet) {
      answer = ruleSet.getMatchingRule(node);
    }

    if (!answer && matchType !== 0) {
      ruleSet = this.ruleSets[0];
      if (ruleSet) {
        answer = ruleSet.getMatchingRule(node);
      }
    }

    return answer;
  }

  protected getRuleSet(matchType: number): RuleSet {
    let ruleSet = this.ruleSets[matchType];
    if (!ruleSet) {
      ruleSet = new RuleSet();
      this.ruleSets[matchType] = ruleSet;
      if (matchType !== 0) {
        const allRules = this.ruleSets[0];
        if (allRules) {
          ruleSet.addAll(allRules);
        }
      }
    }
    return ruleSet;
  }

  protected addToNameMap(map: Map<string, RuleSet> | undefined, name: string, rule: Rule): Map<string, RuleSet> {
    if (!map) {
      map = new Map<string, RuleSet>();
    }

    let ruleSet = map.get(name);
    if (!ruleSet) {
      ruleSet = new RuleSet();
      map.set(name, ruleSet);
    }

    ruleSet.addRule(rule);
    return map;
  }

  protected removeFromNameMap(map: Map<string, RuleSet> | undefined, name: string, rule: Rule): void {
    if (map) {
      const ruleSet = map.get(name);
      if (ruleSet) {
        ruleSet.removeRule(rule);
      }
    }
  }
}