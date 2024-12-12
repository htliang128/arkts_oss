export default class STAXEventReader {
  private factory: DocumentFactory;
  private inputFactory: XMLInputFactory = XMLInputFactory.newInstance();

  constructor(factory?: DocumentFactory) {
    this.factory = factory ? factory : DocumentFactory.getInstance();
  }

  public setDocumentFactory(documentFactory: DocumentFactory): void {
    this.factory = documentFactory ? documentFactory : DocumentFactory.getInstance();
  }

  public readDocument(is: InputStream): Document {
    return this.readDocument(is, null);
  }

  public readDocument(reader: Reader): Document {
    return this.readDocument(reader, null);
  }

  public readDocument(is: InputStream, systemId: string | null): Document {
    const eventReader = this.inputFactory.createXMLEventReader(systemId, is);
    let doc: Document;

    try {
      doc = this.readDocument(eventReader);
    } finally {
      eventReader.close();
    }

    return doc;
  }

  public readDocument(reader: Reader, systemId: string | null): Document {
    const eventReader = this.inputFactory.createXMLEventReader(systemId, reader);
    let doc: Document;

    try {
      doc = this.readDocument(eventReader);
    } finally {
      eventReader.close();
    }

    return doc;
  }

  public readNode(reader: XMLEventReader): Node {
    const event = reader.peek();
    if (event.isStartElement()) {
      return this.readElement(reader);
    } else if (event.isCharacters()) {
      return this.readCharacters(reader);
    } else if (event.isStartDocument()) {
      return this.readDocument(reader);
    } else if (event.isProcessingInstruction()) {
      return this.readProcessingInstruction(reader);
    } else if (event.isEntityReference()) {
      return this.readEntityReference(reader);
    } else if (event.isAttribute()) {
      return this.readAttribute(reader);
    } else if (event.isNamespace()) {
      return this.readNamespace(reader);
    } else {
      throw new XMLStreamException(`Unsupported event: ${event}`);
    }
  }

  public readDocument(reader: XMLEventReader): Document {
    let doc: Document | null = null;

    while (reader.hasNext()) {
      const nextEvent = reader.peek();
      const type = nextEvent.getEventType();
      switch (type) {
        case 4:
        case 6:
        case 8:
          reader.nextEvent();
          break;
        case 5:
        default:
          if (doc === null) {
            doc = this.factory.createDocument();
          }
          const n = this.readNode(reader);
          doc.add(n);
          break;
        case 7:
          const event = reader.nextEvent() as StartDocument;
          if (doc !== null) {
            throw new XMLStreamException("Unexpected StartDocument event", event.getLocation());
          }
          doc = event.encodingSet() ? this.factory.createDocument(event.getCharacterEncodingScheme()) : this.factory.createDocument();
      }
    }

    return doc;
  }

  public readElement(eventReader: XMLEventReader): Element {
    const event = eventReader.peek();
    if (!event.isStartElement()) {
      throw new XMLStreamException(`Expected Element event, found: ${event}`);
    } else {
      const startTag = eventReader.nextEvent().asStartElement();
      const elem = this.createElement(startTag);

      while (eventReader.hasNext()) {
        const nextEvent = eventReader.peek();
        if (nextEvent.isEndElement()) {
          const endElem = eventReader.nextEvent().asEndElement();
          if (!endElem.getName().equals(startTag.getName())) {
            throw new XMLStreamException(`Expected ${startTag.getName()} end-tag, but found ${endElem.getName()}`);
          }
          return elem;
        }
        const child = this.readNode(eventReader);
        elem.add(child);
      }

      throw new XMLStreamException("Unexpected end of stream while reading element content");
    }
  }

  public readAttribute(reader: XMLEventReader): Attribute {
    const event = reader.peek();
    if (event.isAttribute()) {
      const attr = reader.nextEvent() as javax.xml.stream.events.Attribute;
      return this.createAttribute(null, attr);
    } else {
      throw new XMLStreamException(`Expected Attribute event, found: ${event}`);
    }
  }

  public readNamespace(reader: XMLEventReader): Namespace {
    const event = reader.peek();
    if (event.isNamespace()) {
      const ns = reader.nextEvent() as javax.xml.stream.events.Namespace;
      return this.createNamespace(ns);
    } else {
      throw new XMLStreamException(`Expected Namespace event, found: ${event}`);
    }
  }

  public readCharacters(reader: XMLEventReader): CharacterData {
    const event = reader.peek();
    if (event.isCharacters()) {
      const characters = reader.nextEvent().asCharacters();
      return this.createCharacterData(characters);
    } else {
      throw new XMLStreamException(`Expected Characters event, found: ${event}`);
    }
  }

  public readComment(reader: XMLEventReader): Comment {
    const event = reader.peek();
    if (event instanceof javax.xml.stream.events.Comment) {
      return this.createComment(reader.nextEvent() as javax.xml.stream.events.Comment);
    } else {
      throw new XMLStreamException(`Expected Comment event, found: ${event}`);
    }
  }

  public readEntityReference(reader: XMLEventReader): Entity {
    const event = reader.peek();
    if (event.isEntityReference()) {
      const entityRef = reader.nextEvent() as EntityReference;
      return this.createEntity(entityRef);
    } else {
      throw new XMLStreamException(`Expected EntityRef event, found: ${event}`);
    }
  }

  public readProcessingInstruction(reader: XMLEventReader): ProcessingInstruction {
    const event = reader.peek();
    if (event.isProcessingInstruction()) {
      const pi = reader.nextEvent() as javax.xml.stream.events.ProcessingInstruction;
      return this.createProcessingInstruction(pi);
    } else {
      throw new XMLStreamException(`Expected PI event, found: ${event}`);
    }
  }

  public createElement(startEvent: StartElement): Element {
    const qname = startEvent.getName();
    const elemName = this.createQName(qname);
    const elem = this.factory.createElement(elemName);
    const attributes = startEvent.getAttributes();

    while (attributes.hasNext()) {
      const attr = attributes.next() as javax.xml.stream.events.Attribute;
      elem.addAttribute(this.createQName(attr.getName()), attr.getValue());
    }

    const namespaces = startEvent.getNamespaces();
    while (namespaces.hasNext()) {
      const ns = namespaces.next() as javax.xml.stream.events.Namespace;
      elem.addNamespace(ns.getPrefix(), ns.getNamespaceURI());
    }

    return elem;
  }

  public createAttribute(elem: Element | null, attr: javax.xml.stream.events.Attribute): Attribute {
    return this.factory.createAttribute(elem, this.createQName(attr.getName()), attr.getValue());
  }

  public createNamespace(ns: javax.xml.stream.events.Namespace): Namespace {
    return this.factory.createNamespace(ns.getPrefix(), ns.getNamespaceURI());
  }

  public createCharacterData(characters: Characters): CharacterData {
    const data = characters.getData();
    return characters.isCData() ? this.factory.createCDATA(data) : this.factory.createText(data);
  }

  public createComment(comment: javax.xml.stream.events.Comment): Comment {
    return this.factory.createComment(comment.getText());
  }

  public createEntity(entityRef: EntityReference): Entity {
    return this.factory.createEntity(entityRef.getName(), entityRef.getDeclaration().getReplacementText());
  }

  public createProcessingInstruction(pi: javax.xml.stream.events.ProcessingInstruction): ProcessingInstruction {
    return this.factory.createProcessingInstruction(pi.getTarget(), pi.getData());
  }

  public createQName(qname: QName): org.dom4j.QName {
    return this.factory.createQName(qname.getLocalPart(), qname.getPrefix(), qname.getNamespaceURI());
  }
}