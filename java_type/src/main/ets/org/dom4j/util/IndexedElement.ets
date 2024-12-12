export default  class IndexedElement extends DefaultElement {
  private elementIndex: Map<any, any> | null = null;
  private attributeIndex: Map<any, Attribute> | null = null;

  constructor(name: string);
  constructor(qname: QName);
  constructor(qname: QName, attributeCount: number);
  constructor(nameOrQname: string | QName, attributeCount?: number) {
    super(nameOrQname, attributeCount);
  }

  attribute(name: string): Attribute;
  attribute(qName: QName): Attribute;
  attribute(nameOrQName: string | QName): Attribute {
    return this.attributeIndex().get(nameOrQName);
  }

  element(name: string): Element;
  element(qName: QName): Element;
  element(nameOrQName: string | QName): Element {
    return this.asElement(this.elementIndex().get(nameOrQName));
  }

  elements(name: string): Array<Element>;
  elements(qName: QName): Array<Element>;
  elements(nameOrQName: string | QName): Array<Element> {
    return this.asElementList(this.elementIndex().get(nameOrQName));
  }

  protected asElement(object: any): Element | null {
    if (object instanceof Element) {
      return object;
    } else if (object != null) {
      let list = object as Array<Element>;
      if (list.length >= 1) {
        return list[0];
      }
    }
    return null;
  }

  protected asElementList(object: any): Array<Element> {
    if (object instanceof Element) {
      return [object];
    } else if (object == null) {
      return [];
    } else {
      let list = object as Array<Element>;
      let answer = new BackedList<Element>();
      for (let aList of list) {
        answer.addLocal(aList);
      }
      return answer;
    }
  }

  protected addNode(node: Node) {
    super.addNode(node);
    if (this.elementIndex != null && node instanceof Element) {
      this.addToElementIndex(node);
    } else if (this.attributeIndex != null && node instanceof Attribute) {
      this.addToAttributeIndex(node);
    }
  }

  protected removeNode(node: Node): boolean {
    if (!super.removeNode(node)) {
      return false;
    } else {
      if (this.elementIndex != null && node instanceof Element) {
        this.removeFromElementIndex(node);
      } else if (this.attributeIndex != null && node instanceof Attribute) {
        this.removeFromAttributeIndex(node);
      }
      return true;
    }
  }

  protected attributeIndex(): Map<any, Attribute> {
    if (this.attributeIndex == null) {
      this.attributeIndex = new Map();
      for (let attr of this.attributeIterator()) {
        this.addToAttributeIndex(attr);
      }
    }
    return this.attributeIndex;
  }

  protected elementIndex(): Map<any, any> {
    if (this.elementIndex == null) {
      this.elementIndex = new Map();
      for (let elem of this.elementIterator()) {
        this.addToElementIndex(elem);
      }
    }
    return this.elementIndex;
  }

  protected addToElementIndex(element: Element) {
    let qName = element.getQName();
    let name = qName.getName();
    this.addToElementIndexToMap(qName, element);
    this.addToElementIndexToMap(name, element);
  }

  protected addToElementIndexToMap(key: any, value: Element) {
    let oldValue = this.elementIndex!.get(key);
    if (oldValue == null) {
      this.elementIndex!.set(key, value);
    } else {
      let list: Array<Element>;
      if (Array.isArray(oldValue)) {
        list = oldValue;
        list.push(value);
      } else {
        list = [oldValue as Element, value];
        this.elementIndex!.set(key, list);
      }
    }
  }

  protected removeFromElementIndex(element: Element) {
    let qName = element.getQName();
    let name = qName.getName();
    this.removeFromElementIndexFromMap(qName, element);
    this.removeFromElementIndexFromMap(name, element);
  }

  protected removeFromElementIndexFromMap(key: any, value: Element) {
    let oldValue = this.elementIndex!.get(key);
    if (Array.isArray(oldValue)) {
      let list = oldValue;
      let index = list.indexOf(value);
      if (index > -1) {
        list.splice(index, 1);
      }
    } else {
      this.elementIndex!.delete(key);
    }
  }

  protected addToAttributeIndex(attribute: Attribute) {
    let qName = attribute.getQName();
    let name = qName.getName();
    this.addToAttributeIndexToMap(qName, attribute);
    this.addToAttributeIndexToMap(name, attribute);
  }

  protected addToAttributeIndexToMap(key: any, value: Attribute) {
    let oldValue = this.attributeIndex!.get(key);
    if (oldValue != null) {
      this.attributeIndex!.set(key, value);
    }
  }

  protected removeFromAttributeIndex(attribute: Attribute) {
    let qName = attribute.getQName();
    let name = qName.getName();
    this.removeFromAttributeIndexFromMap(qName, attribute);
    this.removeFromAttributeIndexFromMap(name, attribute);
  }

  protected removeFromAttributeIndexFromMap(key: any, value: Attribute) {
    let oldValue = this.attributeIndex!.get(key);
    if (oldValue != null && oldValue.equals(value)) {
      this.attributeIndex!.delete(key);
    }
  }
}