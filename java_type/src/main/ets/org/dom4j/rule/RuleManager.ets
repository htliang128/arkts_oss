export default  class RuleManager {
  private modes: Map<string, Mode> = new Map();
  private appearenceCount: number = 0;
  private valueOfAction: Action | null = null;

  public constructor() {}

  public getMode(modeName: string): Mode {
    let mode = this.modes.get(modeName);
    if (!mode) {
      mode = this.createMode();
      this.modes.set(modeName, mode);
    }
    return mode;
  }

  public addRule(rule: Rule): void {
    rule.setAppearenceCount(++this.appearenceCount);
    const mode = this.getMode(rule.getMode());
    const childRules = rule.getUnionRules();
    if (childRules) {
      for (const childRule of childRules) {
        mode.addRule(childRule);
      }
    } else {
      mode.addRule(rule);
    }
  }

  public removeRule(rule: Rule): void {
    const mode = this.getMode(rule.getMode());
    const childRules = rule.getUnionRules();
    if (childRules) {
      for (const childRule of childRules) {
        mode.removeRule(childRule);
      }
    } else {
      mode.removeRule(rule);
    }
  }

  public getMatchingRule(modeName: string, node: Node): Rule | null {
    const mode = this.modes.get(modeName);
    if (mode) {
      return mode.getMatchingRule(node);
    } else {
      console.warn(`Warning: No Mode for mode: ${modeName}`);
      return null;
    }
  }

  public clear(): void {
    this.modes.clear();
    this.appearenceCount = 0;
  }

  public getValueOfAction(): Action | null {
    return this.valueOfAction;
  }

  public setValueOfAction(valueOfAction: Action): void {
    this.valueOfAction = valueOfAction;
  }

  protected createMode(): Mode {
    const mode = new Mode();
    this.addDefaultRules(mode);
    return mode;
  }

  protected addDefaultRules(mode: Mode): void {
    const applyTemplates: Action = {
      run: (node: Node) => {
        if (node instanceof Element) {
          mode.applyTemplates(node);
        } else if (node instanceof Document) {
          mode.applyTemplates(node);
        }
      }
    };
    const valueOf = this.getValueOfAction();
    this.addDefaultRule(mode, NodeTypePattern.ANY_DOCUMENT, applyTemplates);
    this.addDefaultRule(mode, NodeTypePattern.ANY_ELEMENT, applyTemplates);
    if (valueOf) {
      this.addDefaultRule(mode, NodeTypePattern.ANY_ATTRIBUTE, valueOf);
      this.addDefaultRule(mode, NodeTypePattern.ANY_TEXT, valueOf);
    }
  }

  protected addDefaultRule(mode: Mode, pattern: Pattern, action: Action): void {
    const rule = this.createDefaultRule(pattern, action);
    mode.addRule(rule);
  }

  protected createDefaultRule(pattern: Pattern, action: Action): Rule {
    const rule = new Rule(pattern, action);
    rule.setImportPrecedence(-1);
    return rule;
  }
}