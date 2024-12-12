export default class STAXEventWriter {
  private consumer: XMLEventConsumer;
  private factory: XMLEventFactory = XMLEventFactory.newInstance();
  private outputFactory: XMLOutputFactory = XMLOutputFactory.newInstance();

  public constructor();
  public constructor(file: File);
  public constructor(writer: Writer);
  public constructor(stream: NodeJS.ReadableStream);
  public constructor(consumer: XMLEventConsumer);
  public constructor(arg?: any) {
    if (arg instanceof File) {
      this.consumer = this.outputFactory.createXMLEventWriter(new FileWriter(arg));
    } else if (arg instanceof Writer) {
      this.consumer = this.outputFactory.createXMLEventWriter(arg);
    } else if (arg instanceof NodeJS.ReadableStream) {
      this.consumer = this.outputFactory.createXMLEventWriter(arg);
    } else {
      this.consumer = arg;
    }
  }

  public getConsumer(): XMLEventConsumer {
    return this.consumer;
  }

  public setConsumer(consumer: XMLEventConsumer): void {
    this.consumer = consumer;
  }

  public getEventFactory(): XMLEventFactory {
    return this.factory;
  }

  public setEventFactory(eventFactory: XMLEventFactory): void {
    this.factory = eventFactory;
  }

  public writeNode(n: Node): void {
    switch (n.getNodeType()) {
      case 1:
        this.writeElement(n as Element);
        break;
      case 2:
        this.writeAttribute(n as Attribute);
        break;
      case 3:
        this.writeText(n as Text);
        break;
      case 4:
        this.writeCDATA(n as CDATA);
        break;
      case 5:
        this.writeEntity(n as Entity);
        break;
      case 6:
      case 11:
      case 12:
        throw new XMLStreamException("Unsupported DOM4J Node: " + n);
      case 7:
        this.writeProcessingInstruction(n as ProcessingInstruction);
        break;
      case 8:
        this.writeComment(n as Comment);
        break;
      case 9:
        this.writeDocument(n as Document);
        break;
      case 10:
        this.writeDocumentType(n as DocumentType);
        break;
      case 13:
        this.writeNamespace(n as Namespace);
        break;
    }
  }

  public writeChildNodes(branch: Branch): void {
    for (let i = 0; i < branch.nodeCount(); i++) {
      const n = branch.node(i);
      this.writeNode(n);
    }
  }

  public writeElement(elem: Element): void {
    this.consumer.add(this.createStartElement(elem));
    this.writeChildNodes(elem);
    this.consumer.add(this.createEndElement(elem));
  }

  public createStartElement(elem: Element): StartElement {
    const tagName = this.createQName(elem.getQName());
    const attrIter = new this.AttributeIterator(elem.attributeIterator());
    const nsIter = new this.NamespaceIterator(elem.declaredNamespaces().iterator());
    return this.factory.createStartElement(tagName, attrIter, nsIter);
  }

  public createEndElement(elem: Element): EndElement {
    const tagName = this.createQName(elem.getQName());
    const nsIter = new this.NamespaceIterator(elem.declaredNamespaces().iterator());
    return this.factory.createEndElement(tagName, nsIter);
  }

  public writeAttribute(attr: Attribute): void {
    this.consumer.add(this.createAttribute(attr));
  }

  public createAttribute(attr: Attribute): javax.xml.stream.events.Attribute {
    const attrName = this.createQName(attr.getQName());
    const value = attr.getValue();
    return this.factory.createAttribute(attrName, value);
  }

  public writeNamespace(ns: Namespace): void {
    this.consumer.add(this.createNamespace(ns));
  }

  public createNamespace(ns: Namespace): javax.xml.stream.events.Namespace {
    const prefix = ns.getPrefix();
    const uri = ns.getURI();
    return this.factory.createNamespace(prefix, uri);
  }

  public writeText(text: Text): void {
    this.consumer.add(this.createCharacters(text));
  }

  public createCharacters(text: Text): Characters {
    return this.factory.createCharacters(text.getText());
  }

  public writeCDATA(cdata: CDATA): void {
    this.consumer.add(this.createCharacters(cdata));
  }

  public createCharacters(cdata: CDATA): Characters {
    return this.factory.createCData(cdata.getText());
  }

  public writeComment(comment: Comment): void {
    this.consumer.add(this.createComment(comment));
  }

  public createComment(comment: Comment): javax.xml.stream.events.Comment {
    return this.factory.createComment(comment.getText());
  }

  public writeProcessingInstruction(pi: ProcessingInstruction): void {
    this.consumer.add(this.createProcessingInstruction(pi));
  }

  public createProcessingInstruction(pi: ProcessingInstruction): javax.xml.stream.events.ProcessingInstruction {
    const target = pi.getTarget();
    const data = pi.getText();
    return this.factory.createProcessingInstruction(target, data);
  }

  public writeEntity(entity: Entity): void {
    this.consumer.add(this.createEntityReference(entity));
  }

  private createEntityReference(entity: Entity): EntityReference {
    return this.factory.createEntityReference(entity.getName(), null);
  }

  public writeDocumentType(docType: DocumentType): void {
    this.consumer.add(this.createDTD(docType));
  }

  public createDTD(docType: DocumentType): DTD {
    const decl = new StringWriter();
    try {
      docType.write(decl);
    } catch (e) {
      throw new RuntimeException("Error writing DTD", e);
    }
    return this.factory.createDTD(decl.toString());
  }

  public writeDocument(doc: Document): void {
    this.consumer.add(this.createStartDocument(doc));
    this.writeChildNodes(doc);
    this.consumer.add(this.createEndDocument(doc));
  }

  public createStartDocument(doc: Document): StartDocument {
    const encoding = doc.getXMLEncoding();
    return encoding != null ? this.factory.createStartDocument(encoding) : this.factory.createStartDocument();
  }

  public createEndDocument(doc: Document): EndDocument {
    return this.factory.createEndDocument();
  }

  public createQName(qname: org.dom4j.QName): QName {
    return new QName(qname.getNamespaceURI(), qname.getName(), qname.getNamespacePrefix());
  }

  private class NamespaceIterator implements Iterator<javax.xml.stream.events.Namespace> {
  private iter: Iterator<Namespace>;

  public constructor(iter: Iterator<Namespace>) {
    this.iter = iter;
  }

  public hasNext(): boolean {
    return this.iter.hasNext();
  }

  public next(): javax.xml.stream.events.Namespace {
    const ns = this.iter.next();
    const prefix = ns.getPrefix();
    const nsURI = ns.getURI();
    return STAXEventWriter.this.factory.createNamespace(prefix, nsURI);
  }

  public remove(): void {
    throw new UnsupportedOperationException();
  }
}

private class AttributeIterator implements Iterator<javax.xml.stream.events.Attribute> {
  private iter: Iterator<Attribute>;

  public constructor(iter: Iterator<Attribute>) {
    this.iter = iter;
  }

  public hasNext(): boolean {
    return this.iter.hasNext();
  }

  public next(): javax.xml.stream.events.Attribute {
    const attr = this.iter.next();
    const attrName = STAXEventWriter.this.createQName(attr.getQName());
    const value = attr.getValue();
    return STAXEventWriter.this.factory.createAttribute(attrName, value);
  }

  public remove(): void {
    throw new UnsupportedOperationException();
  }
}
}