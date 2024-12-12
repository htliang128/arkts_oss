export default class SAXEventRecorder extends DefaultHandler implements LexicalHandler, DeclHandler, DTDHandler, Externalizable {
  public static serialVersionUID: number = 1;
  private static readonly STRING: byte = 0;
  private static readonly OBJECT: byte = 1;
  private static readonly NULL: byte = 2;
  private events: SAXEvent[] = [];
  private prefixMappings: Map<QName, string[]> = new Map();
  private static readonly XMLNS: string = "xmlns";
  private static readonly EMPTY_STRING: string = "";

  constructor() {}

  public replay(handler: ContentHandler): void {
    for (const saxEvent of this.events) {
      switch (saxEvent.event) {
        case 1:
          handler.processingInstruction(saxEvent.getParm(0) as string, saxEvent.getParm(1) as string);
          break;
        case 2:
          handler.startPrefixMapping(saxEvent.getParm(0) as string, saxEvent.getParm(1) as string);
          break;
        case 3:
          handler.endPrefixMapping(saxEvent.getParm(0) as string);
          break;
        case 4:
          handler.startDocument();
          break;
        case 5:
          handler.endDocument();
          break;
        case 6:
          const attributes = new AttributesImpl();
          const attParmList = saxEvent.getParm(3) as string[][];
          if (attParmList) {
            for (const attParms of attParmList) {
              attributes.addAttribute(attParms[0], attParms[1], attParms[2], attParms[3], attParms[4]);
            }
          }
          handler.startElement(saxEvent.getParm(0) as string, saxEvent.getParm(1) as string, saxEvent.getParm(2) as string, attributes);
          break;
        case 7:
          handler.endElement(saxEvent.getParm(0) as string, saxEvent.getParm(1) as string, saxEvent.getParm(2) as string);
          break;
        case 8:
          const chars = saxEvent.getParm(0) as char[];
          const start = saxEvent.getParm(1) as number;
          const end = saxEvent.getParm(2) as number;
          handler.characters(chars, start, end);
          break;
        case 9:
          (handler as LexicalHandler).startDTD(saxEvent.getParm(0) as string, saxEvent.getParm(1) as string, saxEvent.getParm(2) as string);
          break;
        case 10:
          (handler as LexicalHandler).endDTD();
          break;
        case 11:
          (handler as LexicalHandler).startEntity(saxEvent.getParm(0) as string);
          break;
        case 12:
          (handler as LexicalHandler).endEntity(saxEvent.getParm(0) as string);
          break;
        case 13:
          (handler as LexicalHandler).startCDATA();
          break;
        case 14:
          (handler as LexicalHandler).endCDATA();
          break;
        case 15:
          const cchars = saxEvent.getParm(0) as char[];
          const cstart = saxEvent.getParm(1) as number;
          const cend = saxEvent.getParm(2) as number;
          (handler as LexicalHandler).comment(cchars, cstart, cend);
          break;
        case 16:
          (handler as DeclHandler).elementDecl(saxEvent.getParm(0) as string, saxEvent.getParm(1) as string);
          break;
        case 17:
          (handler as DeclHandler).attributeDecl(saxEvent.getParm(0) as string, saxEvent.getParm(1) as string, saxEvent.getParm(2) as string, saxEvent.getParm(3) as string, saxEvent.getParm(4) as string);
          break;
        case 18:
          (handler as DeclHandler).internalEntityDecl(saxEvent.getParm(0) as string, saxEvent.getParm(1) as string);
          break;
        case 19:
          (handler as DeclHandler).externalEntityDecl(saxEvent.getParm(0) as string, saxEvent.getParm(1) as string, saxEvent.getParm(2) as string);
          break;
        default:
          throw new SAXException("Unrecognized event: " + saxEvent.event);
      }
    }
  }

  public processingInstruction(target: string, data: string): void {
    const saxEvent = new SAXEvent(1);
    saxEvent.addParm(target);
    saxEvent.addParm(data);
    this.events.push(saxEvent);
  }

  public startPrefixMapping(prefix: string, uri: string): void {
    const saxEvent = new SAXEvent(2);
    saxEvent.addParm(prefix);
    saxEvent.addParm(uri);
    this.events.push(saxEvent);
  }

  public endPrefixMapping(prefix: string): void {
    const saxEvent = new SAXEvent(3);
    saxEvent.addParm(prefix);
    this.events.push(saxEvent);
  }

  public startDocument(): void {
    const saxEvent = new SAXEvent(4);
    this.events.push(saxEvent);
  }

  public endDocument(): void {
    const saxEvent = new SAXEvent(5);
    this.events.push(saxEvent);
  }

  public startElement(namespaceURI: string, localName: string, qualifiedName: string, attributes: Attributes): void {
    const saxEvent = new SAXEvent(6);
    saxEvent.addParm(namespaceURI);
    saxEvent.addParm(localName);
    saxEvent.addParm(qualifiedName);
    let qName: QName;
    if (namespaceURI) {
      qName = new QName(localName, Namespace.get(namespaceURI));
    } else {
      qName = new QName(localName);
    }

    if (attributes && attributes.getLength() > 0) {
      const attParmList: string[][] = [];
      for (let i = 0; i < attributes.getLength(); i++) {
        const attLocalName = attributes.getLocalName(i);
        if (attLocalName.startsWith("xmlns")) {
          const prefix = attLocalName.length > 5 ? attLocalName.substring(6) : "";
          const prefixEvent = new SAXEvent(2);
          prefixEvent.addParm(prefix);
          prefixEvent.addParm(attributes.getValue(i));
          this.events.push(prefixEvent);
          let prefixes = this.prefixMappings.get(qName);
          if (!prefixes) {
            prefixes = [];
            this.prefixMappings.set(qName, prefixes);
          }
          prefixes.push(prefix);
        } else {
          const attParms = [
            attributes.getURI(i),
            attLocalName,
            attributes.getQName(i),
            attributes.getType(i),
            attributes.getValue(i)
          ];
          attParmList.push(attParms);
        }
      }
      saxEvent.addParm(attParmList);
    }
    this.events.push(saxEvent);
  }

  public endElement(namespaceURI: string, localName: string, qName: string): void {
    const saxEvent = new SAXEvent(7);
    saxEvent.addParm(namespaceURI);
    saxEvent.addParm(localName);
    saxEvent.addParm(qName);
    this.events.push(saxEvent);
    let elementName: QName;
    if (namespaceURI) {
      elementName = new QName(localName, Namespace.get(namespaceURI));
    } else {
      elementName = new QName(localName);
    }
    const prefixes = this.prefixMappings.get(elementName);
    if (prefixes) {
      for (const prefixe of prefixes) {
        const prefixEvent = new SAXEvent(3);
        prefixEvent.addParm(prefixe);
        this.events.push(prefixEvent);
      }
    }
  }

  public characters(ch: char[], start: number, end: number): void {
    const saxEvent = new SAXEvent(8);
    saxEvent.addParm(ch);
    saxEvent.addParm(start);
    saxEvent.addParm(end);
    this.events.push(saxEvent);
  }

  public startDTD(name: string, publicId: string, systemId: string): void {
    const saxEvent = new SAXEvent(9);
    saxEvent.addParm(name);
    saxEvent.addParm(publicId);
    saxEvent.addParm(systemId);
    this.events.push(saxEvent);
  }

  public endDTD(): void {
    const saxEvent = new SAXEvent(10);
    this.events.push(saxEvent);
  }

  public startEntity(name: string): void {
    const saxEvent = new SAXEvent(11);
    saxEvent.addParm(name);
    this.events.push(saxEvent);
  }

  public endEntity(name: string): void {
    const saxEvent = new SAXEvent(12);
    saxEvent.addParm(name);
    this.events.push(saxEvent);
  }

  public startCDATA(): void {
    const saxEvent = new SAXEvent(13);
    this.events.push(saxEvent);
  }

  public endCDATA(): void {
    const saxEvent = new SAXEvent(14);
    this.events.push(saxEvent);
  }

  public comment(ch: char[], start: number, end: number): void {
    const saxEvent = new SAXEvent(15);
    saxEvent.addParm(ch);
    saxEvent.addParm(start);
    saxEvent.addParm(end);
    this.events.push(saxEvent);
  }

  public elementDecl(name: string, model: string): void {
    const saxEvent = new SAXEvent(16);
    saxEvent.addParm(name);
    saxEvent.addParm(model);
    this.events.push(saxEvent);
  }

  public attributeDecl(eName: string, aName: string, type: string, valueDefault: string, value: string): void {
    const saxEvent = new SAXEvent(17);
    saxEvent.addParm(eName);
    saxEvent.addParm(aName);
    saxEvent.addParm(type);
    saxEvent.addParm(valueDefault);
    saxEvent.addParm(value);
    this.events.push(saxEvent);
  }

  public internalEntityDecl(name: string, value: string): void {
    const saxEvent = new SAXEvent(18);
    saxEvent.addParm(name);
    saxEvent.addParm(value);
    this.events.push(saxEvent);
  }

  public externalEntityDecl(name: string, publicId: string, sysId: string): void {
    const saxEvent = new SAXEvent(19);
    saxEvent.addParm(name);
    saxEvent.addParm(publicId);
    saxEvent.addParm(sysId);
    this.events.push(saxEvent);
  }

  public writeExternal(out: ObjectOutput): void {
    if (!this.events) {
      out.writeByte(2);
    } else {
      out.writeByte(1);
      out.writeObject(this.events);
    }
  }

  public readExternal(in: ObjectInput): void {
    if (in.readByte() !== 2) {
      this.events = in.readObject() as SAXEvent[];
    }
  }
}

class SAXEvent implements Externalizable {
  public static serialVersionUID: number = 1;
  static readonly PROCESSING_INSTRUCTION: byte = 1;
  static readonly START_PREFIX_MAPPING: byte = 2;
  static readonly END_PREFIX_MAPPING: byte = 3;
  static readonly START_DOCUMENT: byte = 4;
  static readonly END_DOCUMENT: byte = 5;
  static readonly START_ELEMENT: byte = 6;
  static readonly END_ELEMENT: byte = 7;
  static readonly CHARACTERS: byte = 8;
  static readonly START_DTD: byte = 9;
  static readonly END_DTD: byte = 10;
  static readonly START_ENTITY: byte = 11;
  static readonly END_ENTITY: byte = 12;
  static readonly START_CDATA: byte = 13;
  static readonly END_CDATA: byte = 14;
  static readonly COMMENT: byte = 15;
  static readonly ELEMENT_DECL: byte = 16;
  static readonly ATTRIBUTE_DECL: byte = 17;
  static readonly INTERNAL_ENTITY_DECL: byte = 18;
  static readonly EXTERNAL_ENTITY_DECL: byte = 19;

  protected event: byte;
  protected parms: (Object | null)[];

  constructor(event?: byte) {
    this.event = event || 0;
    this.parms = [];
  }

  public addParm(parm: Object): void {
    this.parms.push(parm);
  }

  public getParm(index: number): Object | null {
    return this.parms[index] || null;
  }

  public writeExternal(out: ObjectOutput): void {
    out.writeByte(this.event);
    if (!this.parms) {
      out.writeByte(2);
    } else {
      out.writeByte(1);
      out.writeObject(this.parms);
    }
  }

  public readExternal(in: ObjectInput): void {
    this.event = in.readByte();
    if (in.readByte() !== 2) {
      this.parms = in.readObject() as (Object | null)[];
    }
  }
}