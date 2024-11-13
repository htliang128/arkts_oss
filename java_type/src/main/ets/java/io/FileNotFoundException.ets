import IOException from "./IOException";

export default class FileNotFoundException extends IOException {
  constructor(message?: string) {
    super(message);
    this.name = 'FileNotFoundException';
  }
}