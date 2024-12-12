export default  class Stylesheet {
  private ruleManager: RuleManager = new RuleManager();
  private modeName: string | undefined;

  constructor() {}

  public addRule(rule: Rule): void {
    this.ruleManager.addRule(rule);
  }

  public removeRule(rule: Rule): void {
    this.ruleManager.removeRule(rule);
  }

  public async run(list: Node[]): Promise<void> {
    await this.run(list, this.modeName);
  }

  public async run(list: Node[], mode: string): Promise<void> {
    for (const node of list) {
      await this.run(node, mode);
    }
  }

  public async run(node: Node): Promise<void> {
    await this.run(node, this.modeName);
  }

  public async run(node: Node, mode: string): Promise<void> {
    const mod: Mode = this.ruleManager.getMode(mode);
    await mod.fireRule(node);
  }

  public async applyTemplates(input: any, xpath: XPath): Promise<void> {
    await this.applyTemplates(input, xpath, this.modeName);
  }

  public async applyTemplates(input: any, xpath: XPath, mode: string): Promise<void> {
    const mod: Mode = this.ruleManager.getMode(mode);
    const list: Node[] = xpath.selectNodes(input);
    for (const current of list) {
      await mod.fireRule(current);
    }
  }

  public async applyTemplates(node: Node): Promise<void> {
    await this.applyTemplates(node, this.modeName);
  }

  public async applyTemplates(element: Element): Promise<void> {
    await this.applyTemplates(element, this.modeName);
  }

  public async applyTemplates(document: Document): Promise<void> {
    await this.applyTemplates(document, this.modeName);
  }

  public async applyTemplates(list: Node[]): Promise<void> {
    await this.applyTemplates(list, this.modeName);
  }

  public async applyTemplates(node: Node, mode: string): Promise<void> {
    if (node instanceof Element) {
      await this.applyTemplates(node, mode);
    } else if (node instanceof Document) {
      await this.applyTemplates(node, mode);
    }
  }

  public async applyTemplates(element: Element, mode: string): Promise<void> {
    const mod: Mode = this.ruleManager.getMode(mode);
    for (let i = 0; i < element.nodeCount(); i++) {
      const node: Node = element.node(i);
      await mod.fireRule(node);
    }
  }

  public async applyTemplates(document: Document, mode: string): Promise<void> {
    const mod: Mode = this.ruleManager.getMode(mode);
    for (let i = 0; i < document.nodeCount(); i++) {
      const node: Node = document.node(i);
      await mod.fireRule(node);
    }
  }

  public async applyTemplates(list: Node[], mode: string): Promise<void> {
    for (const node of list) {
      if (node instanceof Element) {
        await this.applyTemplates(node, mode);
      } else if (node instanceof Document) {
        await this.applyTemplates(node, mode);
      }
    }
  }

  public clear(): void {
    this.ruleManager.clear();
  }

  public getModeName(): string | undefined {
    return this.modeName;
  }

  public setModeName(modeName: string): void {
    this.modeName = modeName;
  }

  public getValueOfAction(): Action {
    return this.ruleManager.getValueOfAction();
  }

  public setValueOfAction(valueOfAction: Action): void {
    this.ruleManager.setValueOfAction(valueOfAction);
  }
}