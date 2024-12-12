export default  class NonLazyElement extends BaseElement {
  constructor(name: string);
  constructor(qname: QName);
  constructor(name: string, namespace: Namespace);
  constructor(qname: QName, attributeCount: number);
  constructor(arg1: string | QName, arg2?: Namespace | number) {
    if (typeof arg1 === 'string' && arg2 instanceof Namespace) {
      super(arg1, arg2);
    } else if (arg1 instanceof QName && typeof arg2 === 'number') {
      super(arg1);
    } else if (arg1 instanceof QName) {
      super(arg1);
    } else {
      super(arg1 as string);
    }
    this.attributes = this.createAttributeList();
    this.content = this.createContentList();
  }
}