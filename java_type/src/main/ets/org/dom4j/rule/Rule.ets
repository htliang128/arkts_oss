export default class Rule implements Comparable<Rule> {
  private mode: string;
  private importPrecedence: number;
  private priority: number;
  private appearenceCount: number;
  private pattern: Pattern;
  private action: Action;

  constructor();
  constructor(pattern: Pattern);
  constructor(pattern: Pattern, action: Action);
  constructor(that: Rule, pattern: Pattern);
  constructor(arg1?: Pattern | Rule, arg2?: Action | Pattern) {
    if (arg1 instanceof Rule) {
      const that = arg1;
      this.mode = that.mode;
      this.importPrecedence = that.importPrecedence;
      this.priority = that.priority;
      this.appearenceCount = that.appearenceCount;
      this.action = that.action;
      this.pattern = arg2 as Pattern;
    } else if (arg1) {
      this.pattern = arg1;
      this.priority = arg1.getPriority();
    } else {
      this.priority = 0.5;
    }
  }

  public equals(that: any): boolean {
    if (that instanceof Rule) {
      return this.compareTo(that) === 0;
    }
    return false;
  }

  public hashCode(): number {
    return this.importPrecedence + this.appearenceCount;
  }

  public compareTo(that: Rule): number {
    let answer = Rule.compareInt(this.importPrecedence, that.importPrecedence);
    if (answer === 0) {
      answer = this.priority === that.priority ? 0 : (this.priority < that.priority ? -1 : 1);
      if (answer === 0) {
        answer = Rule.compareInt(this.appearenceCount, that.appearenceCount);
      }
    }
    return answer;
  }

  public toString(): string {
    return super.toString() + `[ pattern: ${this.getPattern()} action: ${this.getAction()} ]`;
  }

  public matches(node: Node): boolean {
    return this.pattern.matches(node);
  }

  public getUnionRules(): Rule[] | null {
    const patterns = this.pattern.getUnionPatterns();
    if (patterns == null) {
      return null;
    }
    const size = patterns.length;
    const answer: Rule[] = new Array(size);
    for (let i = 0; i < size; i++) {
      answer[i] = new Rule(this, patterns[i]);
    }
    return answer;
  }

  public getMatchType(): number {
    return this.pattern.getMatchType();
  }

  public getMatchesNodeName(): string | null {
    return this.pattern.getMatchesNodeName();
  }

  public getMode(): string {
    return this.mode;
  }

  public setMode(mode: string): void {
    this.mode = mode;
  }

  public getImportPrecedence(): number {
    return this.importPrecedence;
  }

  public setImportPrecedence(importPrecedence: number): void {
    this.importPrecedence = importPrecedence;
  }

  public getPriority(): number {
    return this.priority;
  }

  public setPriority(priority: number): void {
    this.priority = priority;
  }

  public getAppearenceCount(): number {
    return this.appearenceCount;
  }

  public setAppearenceCount(appearenceCount: number): void {
    this.appearenceCount = appearenceCount;
  }

  public getPattern(): Pattern {
    return this.pattern;
  }

  public setPattern(pattern: Pattern): void {
    this.pattern = pattern;
  }

  public getAction(): Action {
    return this.action;
  }

  public setAction(action: Action): void {
    this.action = action;
  }

  private static compareInt(value1: number, value2: number): number {
    return value1 < value2 ? -1 : (value1 === value2 ? 0 : 1);
  }
}