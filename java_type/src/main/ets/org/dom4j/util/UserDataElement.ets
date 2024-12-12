export default  class UserDataElement extends DefaultElement {
  private data: any;

  constructor(name: string);
  constructor(qname: QName);
  constructor(nameOrQName: string | QName) {
    super(nameOrQName);
  }

  public getData(): any {
    return this.data;
  }

  public setData(data: any): void {
    this.data = data;
  }

  public toString(): string {
    return super.toString() + " userData: " + this.data;
  }

  public clone(): UserDataElement {
    const answer = super.clone() as UserDataElement;
    if (answer !== this) {
      answer.data = this.getCopyOfUserData();
    }

    return answer;
  }

  protected getCopyOfUserData(): any {
    return this.data;
  }

  protected createElement(name: string): Element;
  protected createElement(qName: QName): Element;
  protected createElement(nameOrQName: string | QName): Element {
    const answer = this.getDocumentFactory().createElement(nameOrQName);
    answer.setData(this.getCopyOfUserData());
    return answer;
  }
}