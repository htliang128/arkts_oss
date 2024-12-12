export default class DocumentTreeModel extends DefaultTreeModel {
  protected document: Document;

  constructor(document: Document) {
    super(new BranchTreeNode(document));
    this.document = document;
  }

  public getDocument(): Document {
    return this.document;
  }

  public setDocument(document: Document): void {
    this.document = document;
    this.setRoot(new BranchTreeNode(document));
  }
}