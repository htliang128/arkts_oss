import Comment from "../Comment";
import Element from "../Element";
import Node from "../Node";
import AbstractComment from "./AbstractComment";
import DefaultComment from "./DefaultDocument";

export default  class FlyweightComment extends AbstractComment implements Comment {
  protected text: string;

  constructor(text: string) {
    super();
    this.text = text;
  }

  public getText(): string {
    return this.text;
  }

  protected createXPathResult(parent: Element): Node {
    return new DefaultComment(parent, this.getText());
  }
}