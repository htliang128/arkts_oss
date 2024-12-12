export default  class ProxyXmlStartTag implements XmlStartTag {
  private element: Element | null;
  private factory: DocumentFactory = DocumentFactory.getInstance();

  constructor(element?: Element) {
    this.element = element || null;
  }

  resetStartTag(): void {
    this.element = null;
  }

  getAttributeCount(): number {
    return this.element ? this.element.attributeCount() : 0;
  }

  getAttributeNamespaceUri(index: number): string | null {
    return this.element ? this.element.attribute(index)?.getNamespaceURI() : null;
  }

  getAttributeLocalName(index: number): string | null {
    return this.element ? this.element.attribute(index)?.getName() : null;
  }

  getAttributePrefix(index: number): string | null {
    return this.element ? this.element.attribute(index)?.getNamespacePrefix() : null;
  }

  getAttributeRawName(index: number): string | null {
    return this.element ? this.element.attribute(index)?.getQualifiedName() : null;
  }

  getAttributeValue(index: number): string | null {
    return this.element ? this.element.attribute(index)?.getValue() : null;
  }

  getAttributeValueFromRawName(rawName: string): string | null {
    if (this.element) {
      for (let attribute of this.element.attributeIterator()) {
        if (rawName === attribute.getQualifiedName()) {
          return attribute.getValue();
        }
      }
    }

    return null;
  }

  getAttributeValueFromName(namespaceURI: string, localName: string): string | null {
    if (this.element) {
      for (let attribute of this.element.attributeIterator()) {
        if (namespaceURI === attribute.getNamespaceURI() && localName === attribute.getName()) {
          return attribute.getValue();
        }
      }
    }

    return null;
  }

  isAttributeNamespaceDeclaration(index: number): boolean {
    return this.element ? "xmlns" === this.element.attribute(index)?.getNamespacePrefix() : false;
  }

  addAttribute(namespaceURI: string, localName: string, rawName: string, value: string, isNamespaceDeclaration = false): void {
    if (isNamespaceDeclaration) {
      let prefix = "";
      let idx = rawName.indexOf(":");
      if (idx > 0) {
        prefix = rawName.substring(0, idx);
      }

      this.element?.addNamespace(prefix, namespaceURI);
    } else {
      let qname = QName.get(rawName, namespaceURI);
      this.element?.addAttribute(qname, value);
    }
  }

  ensureAttributesCapacity(minCapacity: number): void {
    if (this.element instanceof AbstractElement) {
      this.element.ensureAttributesCapacity(minCapacity);
    }
  }

  removeAttributeByName(s: string, s1: string): boolean {
    throw new Error("Method not implemented.");
  }

  removeAttributeByRawName(s: string): boolean {
    throw new Error("Method not implemented.");
  }

  removeAttributes(): void {
    if (this.element) {
      this.element.setAttributes(new Array());
    }
  }

  getLocalName(): string {
    return this.element?.getName() || '';
  }

  getNamespaceUri(): string {
    return this.element?.getNamespaceURI() || '';
  }

  getPrefix(): string {
    return this.element?.getNamespacePrefix() || '';
  }

  getRawName(): string {
    return this.element?.getQualifiedName() || '';
  }

  modifyTag(namespaceURI: string, lName: string, rawName: string): void {
    this.element = this.factory.createElement(rawName, namespaceURI);
  }

  resetTag(): void {
    this.element = null;
  }

  getDocumentFactory(): DocumentFactory {
    return this.factory;
  }

  setDocumentFactory(documentFactory: DocumentFactory): void {
    this.factory = documentFactory;
  }

  getElement(): Element | null {
    return this.element;
  }
}