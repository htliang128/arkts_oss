export default  class XPathPattern implements Pattern {
  private text: string;
  private pattern: Pattern;
  private context: Context;

  constructor(pattern: Pattern);
  constructor(text: string);
  constructor(patternOrText: Pattern | string) {
    if (typeof patternOrText === 'string') {
      this.text = patternOrText;
      this.context = new Context(this.getContextSupport());
      try {
        this.pattern = PatternParser.parse(patternOrText);
      } catch (e) {
        if (e instanceof SAXPathException) {
          throw new InvalidXPathException(patternOrText, e.message);
        } else {
          throw new InvalidXPathException(patternOrText);
        }
      }
    } else {
      this.pattern = patternOrText;
      this.text = patternOrText.getText();
      this.context = new Context(this.getContextSupport());
    }
  }

  matches(node: Node): boolean {
    try {
      this.context.setNodeSet([node]);
      return this.pattern.matches(node, this.context);
    } catch (e) {
      if (e instanceof JaxenException) {
        this.handleJaxenException(e);
      }
      return false;
    }
  }

  getText(): string {
    return this.text;
  }

  getPriority(): number {
    return this.pattern.getPriority();
  }

  getUnionPatterns(): Pattern[] {
    const patterns = this.pattern.getUnionPatterns();
    if (!patterns) {
      return null;
    }
    return patterns.map(pattern => new XPathPattern(pattern));
  }

  getMatchType(): number {
    return this.pattern.getMatchType();
  }

  getMatchesNodeName(): string {
    return this.pattern.getMatchesNodeName();
  }

  setVariableContext(variableContext: VariableContext): void {
    this.context.getContextSupport().setVariableContext(variableContext);
  }

  toString(): string {
    return `[XPathPattern: text: ${this.text} Pattern: ${this.pattern}]`;
  }

  protected getContextSupport(): ContextSupport {
    return new ContextSupport(
      new SimpleNamespaceContext(),
      XPathFunctionContext.getInstance(),
      new SimpleVariableContext(),
      DocumentNavigator.getInstance()
    );
  }

  protected handleJaxenException(exception: JaxenException): void {
    throw new XPathException(this.text, exception);
  }
}