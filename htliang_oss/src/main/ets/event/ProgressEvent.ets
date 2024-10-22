import { ProgressEventType } from './ProgressEventType'; // 假设存在 ProgressEventType 枚举类型

export default  class ProgressEvent {
  private bytes: number;
  private eventType: ProgressEventType;

  constructor(eventType: ProgressEventType, bytes: number = 0) {
    if (eventType === null) {
      throw new Error("eventType must not be null.");
    }
    if (bytes < 0) {
      throw new Error("bytes transferred must be non-negative");
    }
    this.eventType = eventType;
    this.bytes = bytes;
  }

  public getBytes(): number {
    return this.bytes;
  }

  public getEventType(): ProgressEventType {
    return this.eventType;
  }

  public toString(): string {
    return `${this.eventType}, bytes: ${this.bytes}`;
  }
}