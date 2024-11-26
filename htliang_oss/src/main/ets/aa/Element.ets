export default class Element {
  name: string;
  children: Element[] = [];
  text: string = '';

  constructor(name: string) {
    this.name = name;
  }

  getChildText(name: string): string | undefined {
    for (const child of this.children) {
      if (child.name === name) {
        return child.text;
      }
    }
    return undefined;
  }

  getChildren(name?: string): Element[] {
    if (name) {
      return this.children.filter(child => child.name === name);
    }
    return this.children;
  }
}