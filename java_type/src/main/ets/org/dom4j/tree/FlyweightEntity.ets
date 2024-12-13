import Element from "../Element";
import Node from "../Node";
import AbstractEntity from "./AbstractEntity";
import DefaultEntity from "./DefaultEntity";

export default  class FlyweightEntity extends AbstractEntity {
  protected name?: string;
  protected text?: string;

  public constructor();
  public constructor(name: string);
  public constructor(name: string, text: string | undefined);
  public constructor(name?: string, text?: string) {
    super();
    if (name) {
      this.name = name;
    }
    if (text) {
      this.text = text;
    }
  }

  public getName(): string | undefined {
    return this.name;
  }

  public getText(): string | undefined {
    return this.text;
  }

  public setText(text: string): void {
    if (this.text !== null) {
      this.text = text;
    } else {
      throw new Error("This Entity is read-only. It cannot be modified");
    }
  }

  protected createXPathResult(parent: Element): Node {
    return new DefaultEntity(parent, this.getName(), this.getText());
  }
}