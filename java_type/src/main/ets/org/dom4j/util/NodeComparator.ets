export default export class NodeComparator {
  constructor() {}

  public compare(n1: Node, n2: Node): number {
    const nodeType1 = n1.getNodeType();
    const nodeType2 = n2.getNodeType();
    let answer = nodeType1 - nodeType2;
    if (answer !== 0) {
      return answer;
    } else {
      switch (nodeType1) {
        case 1:
          return this.compareElements(n1 as Element, n2 as Element);
        case 2:
          return this.compareAttributes(n1 as Attribute, n2 as Attribute);
        case 3:
          return this.compareCharacterData(n1 as Text, n2 as Text);
        case 4:
          return this.compareCharacterData(n1 as CDATA, n2 as CDATA);
        case 5:
          return this.compareEntities(n1 as Entity, n2 as Entity);
        case 7:
          return this.compareProcessingInstructions(n1 as ProcessingInstruction, n2 as ProcessingInstruction);
        case 8:
          return this.compareCharacterData(n1 as Comment, n2 as Comment);
        case 9:
          return this.compareDocuments(n1 as Document, n2 as Document);
        case 10:
          return this.compareDocumentTypes(n1 as DocumentType, n2 as DocumentType);
        case 13:
          return this.compareNamespaces(n1 as Namespace, n2 as Namespace);
        default:
          throw new Error("Invalid node types. node1: " + n1 + " and node2: " + n2);
      }
    }
  }

  public compareDocuments(n1: Document, n2: Document): number {
    let answer = this.compare(n1.getDocType(), n2.getDocType());
    if (answer == 0) {
      answer = this.compareContent(n1, n2);
    }

    return answer;
  }

  public compareElements(n1: Element, n2: Element): number {
    let answer = this.compare(n1.getQName(), n2.getQName());
    if (answer == 0) {
      let c1 = n1.attributeCount();
      let c2 = n2.attributeCount();
      answer = c1 - c2;
      if (answer == 0) {
        for(let i = 0; i < c1; ++i) {
          let a1 = n1.attribute(i);
          let a2 = n2.attribute(a1.getQName());
          answer = this.compare(a1, a2);
          if (answer != 0) {
            return answer;
          }
        }

        answer = this.compareContent(n1, n2);
      }
    }

    return answer;
  }

  public compareAttributes(n1: Attribute, n2: Attribute): number {
    let answer = this.compare(n1.getQName(), n2.getQName());
    if (answer == 0) {
      answer = this.compare(n1.getValue(), n2.getValue());
    }

    return answer;
  }

  public compareQNames(n1: QName, n2: QName): number {
    let answer = this.compare(n1.getNamespaceURI(), n2.getNamespaceURI());
    if (answer == 0) {
      answer = this.compare(n1.getQualifiedName(), n2.getQualifiedName());
    }

    return answer;
  }

  public compareNamespaces(n1: Namespace, n2: Namespace): number {
    let answer = this.compare(n1.getURI(), n2.getURI());
    if (answer == 0) {
      answer = this.compare(n1.getPrefix(), n2.getPrefix());
    }

    return answer;
  }

  public compareCharacterData(t1: CharacterData, t2: CharacterData): number {
    return this.compare(t1.getText(), t2.getText());
  }

  public compareDocumentTypes(o1: DocumentType, o2: DocumentType): number {
    if (o1 == o2) {
      return 0;
    } else if (o1 == null) {
      return -1;
    } else if (o2 == null) {
      return 1;
    } else {
      let answer = this.compare(o1.getPublicID(), o2.getPublicID());
      if (answer == 0) {
        answer = this.compare(o1.getSystemID(), o2.getSystemID());
        if (answer == 0) {
          answer = this.compare(o1.getName(), o2.getName());
        }
      }

      return answer;
    }
  }

  public compareEntities(n1: Entity, n2: Entity): number {
    let answer = this.compare(n1.getName(), n2.getName());
    if (answer == 0) {
      answer = this.compare(n1.getText(), n2.getText());
    }

    return answer;
  }

  public compareProcessingInstructions(n1: ProcessingInstruction, n2: ProcessingInstruction): number {
    let answer = this.compare(n1.getTarget(), n2.getTarget());
    if (answer == 0) {
      answer = this.compare(n1.getText(), n2.getText());
    }

    return answer;
  }

  public compareContent(b1: Branch, b2: Branch): number {
    let c1 = b1.nodeCount();
    let c2 = b2.nodeCount();
    let answer = c1 - c2;
    if (answer == 0) {
      for(let i = 0; i < c1; ++i) {
        let n1 = b1.node(i);
        let n2 = b2.node(i);
        answer = this.compare(n1, n2);
        if (answer != 0) {
          break;
        }
      }
    }

    return answer;
  }

  public compareStrings(o1: string, o2: string): number {
    if (o1 == o2) {
      return 0;
    } else if (o1 == null) {
      return -1;
    } else {
      return o2 == null ? 1 : o1.localeCompare(o2);
    }
  }
}