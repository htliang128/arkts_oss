import StringUtils from '../common/utils/StringUtils';

export default class Owner {
  private displayName?: string;
  private id?: string;

  constructor(id?: string, displayName?: string) {
    this.id = id;
    this.displayName = displayName;
  }

  toString(): string {
    return `Owner [name=${this.getDisplayName()},id=${this.getId()}]`;
  }

  getId(): string | undefined {
    return this.id;
  }

  setId(id: string): void {
    this.id = id;
  }

  getDisplayName(): string | undefined {
    return this.displayName;
  }

  setDisplayName(name: string): void {
    this.displayName = name;
  }

  equals(obj: ESObject): boolean {
    if (!(obj instanceof Owner)) {
      return false;
    }

    const otherOwner = obj as Owner;
    const otherOwnerId = otherOwner.getId() || "";
    const otherOwnerName = otherOwner.getDisplayName() || "";
    const thisOwnerId = this.getId() || "";
    const thisOwnerName = this.getDisplayName() || "";

    return otherOwnerId === thisOwnerId && otherOwnerName === thisOwnerName;
  }

  hashCode(): number {
    return this.id ? StringUtils.hashCode(this.id) : 0;
  }
}

