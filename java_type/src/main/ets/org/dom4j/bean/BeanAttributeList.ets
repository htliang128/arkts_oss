import Attribute from "../Attribute";
import BeanAttribute from "./BeanAttribute";
import BeanElement from "./BeanElement";
import BeanMetaData from "./BeanMetaData";

export default class BeanAttributeList extends Array<Attribute> {
  private parent: BeanElement;
  private beanMetaData: BeanMetaData;
  private attributes: BeanAttribute[];

  constructor(parent: BeanElement, beanMetaData: BeanMetaData) {
    super();
    this.parent = parent;
    this.beanMetaData = beanMetaData;
    this.attributes = new Array<BeanAttribute>(this.beanMetaData.attributeCount());
  }

  attribute(name: string): BeanAttribute | null {
    let index = this.beanMetaData.getIndex(name);

    return this.attributeByIndex(index);
  }

  attributeByQName(qname: QName): BeanAttribute | null {
    let index = this.beanMetaData.getIndexByQName(qname);

    return this.attributeByIndex(index);
  }

  attributeByIndex(index: number): BeanAttribute | null {
    if (index >= 0 && index < this.attributes.length) {
      let attribute = this.attributes[index];

      if (!attribute) {
        attribute = this.createAttribute(this.parent, index);
        this.attributes[index] = attribute;
      }

      return attribute;
    }

    return null;
  }

  getParent(): BeanElement {
    return this.parent;
  }

  getQName(index: number): QName {
    return this.beanMetaData.getQName(index);
  }

  getData(index: number): any {
    return this.beanMetaData.getData(index, this.parent.getData());
  }

  setData(index: number, data: any): void {
    this.beanMetaData.setData(index, this.parent.getData(), data);
  }

  size(): number {
    return this.attributes.length;
  }

  add(object: BeanAttribute): boolean {
    throw new Error("add(Object) unsupported");
  }

  addAtIndex(index: number, object: BeanAttribute): void {
    throw new Error("add(int,Object) unsupported");
  }

  set(index: number, object: BeanAttribute): BeanAttribute {
    throw new Error("set(int,Object) unsupported");
  }

  remove(object: BeanAttribute): boolean {
    return false;
  }

  removeAtIndex(index: number): BeanAttribute | null {
    let attribute = this.get(index);
    if (attribute) {
      attribute.setValue(null);
    }

    return attribute;
  }

  clear(): void {
    for (let attribute of this.attributes) {
      if (attribute) {
        attribute.setValue(null);
      }
    }
  }

  createAttribute(element: BeanElement, index: number): BeanAttribute {
    return new BeanAttribute(this, index);
  }
}