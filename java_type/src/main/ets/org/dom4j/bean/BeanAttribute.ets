import Element from "../Element";
import QName from "../QName";
import AbstractAttribute from "../tree/AbstractAttribute";
import BeanAttributeList from "./BeanAttributeList";

export default class BeanAttribute extends AbstractAttribute {
  private beanList: BeanAttributeList;
  private index: number;

  constructor(beanList: BeanAttributeList, index: number) {
    super();
    this.beanList = beanList;
    this.index = index;
  }

  getQName(): QName {
    return this.beanList.getQName(this.index);
  }

  getParent(): Element {
    return this.beanList.getParent();
  }

  getValue(): string | null {
    let data:ESObject = this.getData();

    return data !== null ? data.toString() : null;
  }

  setValue(data: string): void {
    this.beanList.setData(this.index, data);
  }

  getData(): ESObject {
    return this.beanList.getData(this.index);
  }

  setData(data: ESObject): void {
    this.beanList.setData(this.index, data);
  }
}