import AbstractNode from "./AbstractNode";

export default  abstract class AbstractCharacterData extends AbstractNode implements CharacterData {
  constructor() {
    super();
  }

  public getPath(context: Element): string {
    const parent = this.getParent();
    return parent && parent !== context ? parent.getPath(context) + "/text()" : "text()";
  }

  public getUniquePath(context: Element): string {
    const parent = this.getParent();
    return parent && parent !== context ? parent.getUniquePath(context) + "/text()" : "text()";
  }

  public appendText(text: string): void {
    this.setText(this.getText() + text);
  }
}