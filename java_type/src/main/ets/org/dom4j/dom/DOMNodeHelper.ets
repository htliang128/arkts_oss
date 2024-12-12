import Branch from "../Branch";
import CharacterData from "../CharacterData";
import Document from "../Document";
import Node from "../Node";

export default class DOMNodeHelper {
  public static readonly EMPTY_NODE_LIST = new EmptyNodeList();

  protected constructor() {
  }

  public static supports(node: Node, feature: string, version: string): boolean {
    return false;
  }

  public static getNamespaceURI(node: Node): string | null {
    return null;
  }

  public static getPrefix(node: Node): string | null {
    return null;
  }

  public static getLocalName(node: Node): string | null {
    return null;
  }

  public static setPrefix(node: Node, prefix: string): void {
    this.notSupported();
  }

  public static getNodeValue(node: Node): string {
    return node.getText();
  }

  public static setNodeValue(node: Node, nodeValue: string): void {
    node.setText(nodeValue);
  }

  public static getParentNode(node: Node): org.w3c.dom.Node | null {
    return this.asDOMNode(node.getParent());
  }

  public static getChildNodes(node: Node): NodeList {
    return this.EMPTY_NODE_LIST;
  }

  public static getFirstChild(node: Node): org.w3c.dom.Node | null {
    return null;
  }

  public static getLastChild(node: Node): org.w3c.dom.Node | null {
    return null;
  }

  public static getPreviousSibling(node: Node): org.w3c.dom.Node | null {
    const parent = node.getParent();
    if (parent) {
      const index = parent.indexOf(node);
      if (index > 0) {
        const previous = parent.node(index - 1);
        return this.asDOMNode(previous);
      }
    }
    return null;
  }

  public static getNextSibling(node: Node): org.w3c.dom.Node | null {
    const parent = node.getParent();
    if (parent) {
      let index = parent.indexOf(node);
      if (index >= 0) {
        index++;
        if (index < parent.nodeCount()) {
          const next = parent.node(index);
          return this.asDOMNode(next);
        }
      }
    }
    return null;
  }

  public static getAttributes(node: Node): NamedNodeMap | null {
    return null;
  }

  public static getOwnerDocument(node: Node): Document | null {
    return this.asDOMDocument(node.getDocument());
  }

  public static insertBefore(node: Node, newChild: org.w3c.dom.Node, refChild: org.w3c.dom.Node): org.w3c.dom.Node {
    if (node instanceof Branch) {
      const branch = node as Branch;
      const list = branch.content();
      const index = list.indexOf(refChild);
      if (index < 0) {
        branch.add(newChild as Node);
      } else {
        list.add(index, newChild as Node);
      }
      return newChild;
    } else {
      throw
      new DOMException((short)
      3, "Children not allowed for this node: " + node
      )
      ;
    }
  }

  public static replaceChild(node: Node, newChild: org.w3c.dom.Node, oldChild: org.w3c.dom.Node): org.w3c.dom.Node {
    if (node instanceof Branch) {
      const branch = node as Branch;
      const list = branch.content();
      const index = list.indexOf(oldChild);
      if (index < 0) {
        throw
        new DOMException((short)
        8, "Tried to replace a non existing child for node: " + node
        )
        ;
      } else {
        list.set(index, newChild as Node);
        return oldChild;
      }
    } else {
      throw
      new DOMException((short)
      3, "Children not allowed for this node: " + node
      )
      ;
    }
  }

  public static removeChild(node: Node, oldChild: org.w3c.dom.Node): org.w3c.dom.Node {
    if (node instanceof Branch) {
      const branch = node as Branch;
      branch.remove(oldChild as Node);
      return oldChild;
    } else {
      throw
      new DOMException((short)
      3, "Children not allowed for this node: " + node
      )
      ;
    }
  }

  public static appendChild(node: Node, newChild: org.w3c.dom.Node): org.w3c.dom.Node {
    if (node instanceof Branch) {
      const branch = node as Branch;
      const previousParent = newChild.getParentNode();
      if (previousParent) {
        previousParent.removeChild(newChild);
      }
      branch.add(newChild as Node);
      return newChild;
    } else {
      throw
      new DOMException((short)
      3, "Children not allowed for this node: " + node
      )
      ;
    }
  }

  public static hasChildNodes(node: Node): boolean {
    return false;
  }

  public static cloneNode(node: Node, deep: boolean): org.w3c.dom.Node {
    return this.asDOMNode(node.clone());
  }

  public static normalize(node: Node): void {
    this.notSupported();
  }

  public static isSupported(node: Node, feature: string, version: string): boolean {
    return false;
  }

  public static hasAttributes(node: Node): boolean {
    return node instanceof Element ? (node as Element).attributeCount() > 0 : false;
  }

  public static getData(charData: CharacterData): string {
    return charData.getText();
  }

  public static setData(charData: CharacterData, data: string): void {
    charData.setText(data);
  }

  public static getLength(charData: CharacterData): number {
    const text = charData.getText();
    return text ? text.length : 0;
  }

  public static substringData(charData: CharacterData, offset: number, count: number): string {
    if (count < 0) {
      throw
      new DOMException((short)
      1, "Illegal value for count: " + count
      )
      ;
    } else {
      const text = charData.getText();
      const length = text ? text.length : 0;
      if (offset >= 0 && offset < length) {
        return offset + count > length ? text.substring(offset) : text.substring(offset, offset + count);
      } else {
        throw
        new DOMException((short)
        1, "No text at offset: " + offset
        )
        ;
      }
    }
  }

  public static appendData(charData: CharacterData, arg: string): void {
    if (charData.isReadOnly()) {
      throw
      new DOMException((short)
      7, "CharacterData node is read only: " + charData
      )
      ;
    } else {
      const text = charData.getText();
      charData.setText(text ? text + arg : arg);
    }
  }

  public static insertData(data: CharacterData, offset: number, arg: string): void {
    if (data.isReadOnly()) {
      throw
      new DOMException((short)
      7, "CharacterData node is read only: " + data
      )
      ;
    } else {
      const text = data.getText();
      if (text) {
        const length = text.length;
        if (offset < 0 || offset > length) {
          throw
          new DOMException((short)
          1, "No text at offset: " + offset
          )
          ;
        }
        const buffer = new StringBuilder(text);
        buffer.insert(offset, arg);
        data.setText(buffer.toString());
      } else {
        data.setText(arg);
      }
    }
  }

  public static deleteData(charData: CharacterData, offset: number, count: number): void {
    if (charData.isReadOnly()) {
      throw
      new DOMException((short)
      7, "CharacterData node is read only: " + charData
      )
      ;
    } else if (count < 0) {
      throw
      new DOMException((short)
      1, "Illegal value for count: " + count
      )
      ;
    } else {
      const text = charData.getText();
      if (text) {
        const length = text.length;
        if (offset < 0 || offset >= length) {
          throw
          new DOMException((short)
          1, "No text at offset: " + offset
          )
          ;
        }
        const buffer = new StringBuilder(text);
        buffer.delete(offset, offset + count);
        charData.setText(buffer.toString());
      }
    }
  }

  public static replaceData(charData: CharacterData, offset: number, count: number, arg: string): void {
    if (charData.isReadOnly()) {
      throw
      new DOMException((short)
      7, "CharacterData node is read only: " + charData
      )
      ;
    } else if (count < 0) {
      throw
      new DOMException((short)
      1, "Illegal value for count: " + count
      )
      ;
    } else {
      const text = charData.getText();
      if (text) {
        const length = text.length;
        if (offset < 0 || offset >= length) {
          throw
          new DOMException((short)
          1, "No text at offset: " + offset
          )
          ;
        }
        const buffer = new StringBuilder(text);
        buffer.replace(offset, offset + count, arg);
        charData.setText(buffer.toString());
      }
    }
  }

  public static appendElementsByTagName(list: Array<Element>, parent: Branch, name: string): void {
    const isStar = "*" === name;
    for (let i = 0, size = parent.nodeCount(); i < size; i++) {
      const node = parent.node(i);
      if (node instanceof Element) {
        const element = node as Element;
        if (isStar || name === element.getName()) {
          list.push(element);
        }
        this.appendElementsByTagName(list, element, name);
      }
    }
  }

  public static appendElementsByTagNameNS(list: Array<Element>, parent: Branch, namespace: string,
    localName: string): void {
    const isStarNS = "*" === namespace;
    const isStar = "*" === localName;
    for (let i = 0, size = parent.nodeCount(); i < size; i++) {
      const node = parent.node(i);
      if (node instanceof Element) {
        const element = node as Element;
        if ((isStarNS || (namespace == null || namespace.length === 0) &&
          (element.getNamespaceURI() == null || element.getNamespaceURI().length === 0) ||
          namespace != null && namespace === element.getNamespaceURI()) &&
          (isStar || localName === element.getName())) {
          list.push(element);
        }
        this.appendElementsByTagNameNS(list, element, namespace, localName);
      }
    }
  }

  public static createNodeList(list: Array<Node>): NodeList {
    return {
      item: (index: number): org.w3c.dom.Node | null => {
        return index >= this.getLength() ? null : this.asDOMNode(list[index]);
      },
      getLength: (): number => {
        return list.length;
      }
    };
  }

  public static asDOMNode(node: Node | null): org.w3c.dom.Node | null {
    if (node == null) {
      return null;
    } else if (node instanceof org.w3c.dom.Node) {
      return node;
    } else {
      console.log("Cannot convert: " + node + " into a W3C DOM Node");
      this.notSupported();
      return null;
    }
  }

  public static asDOMDocument(document: org.dom4j.Document | null): Document | null {
    if (document == null) {
      return null;
    } else if (document instanceof Document) {
      return document;
    } else {
      this.notSupported();
      return null;
    }
  }

  public static asDOMDocumentType(dt: org.dom4j.DocumentType | null): DocumentType | null {
    if (dt == null) {
      return null;
    } else if (dt instanceof DocumentType) {
      return dt;
    } else {
      this.notSupported();
      return null;
    }
  }

  public static asDOMText(text: CharacterData | null): Text | null {
    if (text == null) {
      return null;
    } else if (text instanceof Text) {
      return text;
    } else {
      this.notSupported();
      return null;
    }
  }

  public static asDOMElement(element: Node | null): org.w3c.dom.Element | null {
    if (element == null) {
      return null;
    } else if (element instanceof org.w3c.dom.Element) {
      return element;
    } else {
      this.notSupported();
      return null;
    }
  }

  public static asDOMAttr(attribute: Node | null): Attr | null {
    if (attribute == null) {
      return null;
    } else if (attribute instanceof Attr) {
      return attribute;
    } else {
      this.notSupported();
      return null;
    }
  }

  public static notSupported(): void {
    throw
    new DOMException((short)
    9, "Not supported yet"
    )
    ;
  }

  public static isStringEquals(string1: string | null, string2: string | null): boolean {
    if (string1 == null && string2 == null) {
      return true;
    } else {
      return string1 != null && string2 != null ? string1 === string2 : false;
    }
  }

  public static isNodeEquals(node1: org.w3c.dom.Node | null, node2: org.w3c.dom.Node | null): boolean {
    if (node1 == null && node2 == null) {
      return true;
    } else if (node1 != null && node2 != null) {
      if (node1.getNodeType() !== node2.getNodeType()) {
        return false;
      } else if (!this.isStringEquals(node1.getNodeName(), node2.getNodeName())) {
        return false;
      } else if (!this.isStringEquals(node1.getLocalName(), node2.getLocalName())) {
        return false;
      } else if (!this.isStringEquals(node1.getNamespaceURI(), node2.getNamespaceURI())) {
        return false;
      } else if (!this.isStringEquals(node1.getPrefix(), node2.getPrefix())) {
        return false;
      } else {
        return this.isStringEquals(node1.getNodeValue(), node2.getNodeValue());
      }
    } else {
      return false;
    }
  }

  public static isNodeSame(node1: org.w3c.dom.Node | null, node2: org.w3c.dom.Node | null): boolean {
    return node1 === node2;
  }
}

  export  class EmptyNodeList implements NodeList {
  public item(index: number): Node | null {
    return null;
  }

  public getLength(): number {
    return 0;
  }
}