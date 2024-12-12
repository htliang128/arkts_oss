export default class SAXModifyElementHandler implements ElementHandler {
  private elemModifier: ElementModifier;
  private modifiedElement: Element | null;

  constructor(elemModifier: ElementModifier) {
    this.elemModifier = elemModifier;
    this.modifiedElement = null;
  }

  public onStart(elementPath: ElementPath): void {
    this.modifiedElement = elementPath.getCurrent();
  }

  public onEnd(elementPath: ElementPath): void {
    try {
      const origElement = elementPath.getCurrent();
      const currentParent = origElement.getParent();
      let clonedElem: Element;

      if (currentParent !== null) {
        clonedElem = origElement.clone() as Element;
        this.modifiedElement = this.elemModifier.modifyElement(clonedElem);
        if (this.modifiedElement !== null) {
          this.modifiedElement.setParent(origElement.getParent());
          this.modifiedElement.setDocument(origElement.getDocument());
          const contentIndex = currentParent.indexOf(origElement);
          currentParent.content().set(contentIndex, this.modifiedElement);
        }
        origElement.detach();
      } else if (origElement.isRootElement()) {
        clonedElem = origElement.clone() as Element;
        this.modifiedElement = this.elemModifier.modifyElement(clonedElem);
        if (this.modifiedElement !== null) {
          this.modifiedElement.setDocument(origElement.getDocument());
          const doc = origElement.getDocument();
          doc.setRootElement(this.modifiedElement);
        }
        origElement.detach();
      }

      if (elementPath instanceof ElementStack) {
        const elementStack = elementPath as ElementStack;
        elementStack.popElement();
        elementStack.pushElement(this.modifiedElement);
      }

    } catch (var6) {
      throw new SAXModifyException(var6);
    }
  }

  protected getModifiedElement(): Element | null {
    return this.modifiedElement;
  }
}