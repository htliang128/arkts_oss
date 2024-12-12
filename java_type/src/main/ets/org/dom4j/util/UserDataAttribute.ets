export default  class UserDataAttribute extends DefaultAttribute {
  private data: any;

  constructor(qname: QName, text?: string) {
    super(qname, text);
  }

  getData(): any {
    return this.data;
  }

  setData(data: any): void {
    this.data = data;
  }
}