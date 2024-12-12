import DocumentFactory from "../DocumentFactory";
import QName from "../QName";
import BeanAttributeList from "./BeanAttributeList";
import BeanElement from "./BeanElement";

export default class BeanMetaData {
  private static singletonCache: Map<any, BeanMetaData> = new Map<any, BeanMetaData>();

  private static DOCUMENT_FACTORY: DocumentFactory = BeanDocumentFactory.getInstance();

  private beanClass: any;

  private propertyDescriptors: PropertyDescriptor[];

  private qNames: QName[];

  private readMethods: Function[];

  private writeMethods: Function[];

  private nameMap: Map<any, number> = new Map<any, number>();

  constructor(beanClass: any) {
    this.beanClass = beanClass;

    if (beanClass !== null) {
      try {
        this.propertyDescriptors = Object.getOwnPropertyDescriptors(beanClass);
      } catch (e) {
        this.handleException(e);
      }
    }

    if (this.propertyDescriptors === undefined) {
      this.propertyDescriptors = [];
    }

    let size: number = this.propertyDescriptors.length;
    this.qNames = new Array<QName>(size);
    this.readMethods = new Array<Function>(size);
    this.writeMethods = new Array<Function>(size);

    for (let i = 0; i < size; i++) {
      let propertyDescriptor = this.propertyDescriptors[i];
      let name = propertyDescriptor.name;
      let qName = BeanMetaData.DOCUMENT_FACTORY.createQName(name);
      this.qNames[i] = qName;
      this.readMethods[i] = propertyDescriptor.get;
      this.writeMethods[i] = propertyDescriptor.set;

      this.nameMap.set(name, i);
      this.nameMap.set(qName, i);
    }
  }

  public static get(beanClass: any): BeanMetaData {
    let answer: BeanMetaData = BeanMetaData.singletonCache.get(beanClass);

    if (answer === undefined) {
      answer = new BeanMetaData(beanClass);
      BeanMetaData.singletonCache.set(beanClass, answer);
    }

    return answer;
  }

  public attributeCount(): number {
    return this.propertyDescriptors.length;
  }

  public createAttributeList(parent: BeanElement): BeanAttributeList {
    return new BeanAttributeList(parent, this);
  }

  public getQName(index: number): QName {
    return this.qNames[index];
  }

  public getIndex(name: string): number {
    let index = this.nameMap.get(name);

    return (index !== undefined) ? index : (-1);
  }

  public getIndexByQName(qName: QName): number {
    let index = this.nameMap.get(qName);

    return (index !== undefined) ? index : (-1);
  }

  public getData(index: number, bean: any): any {
    try {
      let method: Function = this.readMethods[index];

      return method.call(bean);
    } catch (e) {
      this.handleException(e);

      return null;
    }
  }

  public setData(index: number, bean: any, data: any): void {
    try {
      let method: Function = this.writeMethods[index];
      method.call(bean, data);
    } catch (e) {
      this.handleException(e);
    }
  }

  // Implementation methods
  // -------------------------------------------------------------------------
  protected handleException(e: any): void {
    // ignore introspection exceptions
  }
}