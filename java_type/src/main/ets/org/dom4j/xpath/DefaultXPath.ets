export default class DefaultXPath {
  private text: string;
  private xpath: any;
  private namespaceContext: any;

  constructor(text: string) {
    this.text = text;
    this.xpath = this.parse(text);
  }

  toString() {
    return `[XPath: ${this.xpath}]`;
  }

  getText() {
    return this.text;
  }

  getFunctionContext() {
    return this.xpath.getFunctionContext();
  }

  setFunctionContext(functionContext: any) {
    this.xpath.setFunctionContext(functionContext);
  }

  getNamespaceContext() {
    return this.namespaceContext;
  }

  setNamespaceURIs(map: Map<string, string>) {
    this.setNamespaceContext(new SimpleNamespaceContext(map));
  }

  setNamespaceContext(namespaceContext: any) {
    this.namespaceContext = namespaceContext;
    this.xpath.setNamespaceContext(namespaceContext);
  }

  getVariableContext() {
    return this.xpath.getVariableContext();
  }

  setVariableContext(variableContext: any) {
    this.xpath.setVariableContext(variableContext);
  }

  evaluate(context: any): any {
    try {
      this.setNSContext(context);
      let answer = this.xpath.selectNodes(context);
      return answer != null && answer.length === 1 ? answer[0] : answer;
    } catch (e) {
      this.handleJaxenException(e);
      return null;
    }
  }

  selectObject(context: any): any {
    return this.evaluate(context);
  }

  selectNodes(context: any): any[] {
    try {
      this.setNSContext(context);
      return this.xpath.selectNodes(context);
    } catch (e) {
      this.handleJaxenException(e);
      return [];
    }
  }

  selectSingleNode(context: any): any {
    try {
      this.setNSContext(context);
      let answer = this.xpath.selectSingleNode(context);
      if (answer instanceof Node) {
        return answer;
      } else if (answer == null) {
        return null;
      } else {
        throw new XPathException(`The result of the XPath expression is not a Node. It was: ${answer} of type: ${typeof answer}`);
      }
    } catch (e) {
      this.handleJaxenException(e);
      return null;
    }
  }

  valueOf(context: any): string {
    try {
      this.setNSContext(context);
      return this.xpath.stringValueOf(context);
    } catch (e) {
      this.handleJaxenException(e);
      return "";
    }
  }

  numberValueOf(context: any): number | null {
    try {
      this.setNSContext(context);
      return this.xpath.numberValueOf(context);
    } catch (e) {
      this.handleJaxenException(e);
      return null;
    }
  }

  booleanValueOf(context: any): boolean {
    try {
      this.setNSContext(context);
      return this.xpath.booleanValueOf(context);
    } catch (e) {
      this.handleJaxenException(e);
      return false;
    }
  }

  matches(node: any): boolean {
    try {
      this.setNSContext(node);
      let answer = this.xpath.selectNodes(node);
      if (answer != null && answer.length > 0) {
        let item = answer[0];
        return item instanceof Boolean ? item : answer.includes(node);
      } else {
        return false;
      }
    } catch (e) {
      this.handleJaxenException(e);
      return false;
    }
  }

  protected parse(text: string) {
    try {
      return new Dom4jXPath(text);
    } catch (e) {
      throw new InvalidXPathException(text, e.message);
    } catch (e) {
      throw new InvalidXPathException(text);
    }
  }

  protected setNSContext(context: any) {
    if (this.namespaceContext == null) {
      this.xpath.setNamespaceContext(DefaultNamespaceContext.create(context));
    }
  }

  protected handleJaxenException(exception: any) {
    throw new XPathException(this.text, exception);
  }
}