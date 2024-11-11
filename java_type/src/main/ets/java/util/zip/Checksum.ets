export default interface Checksum {
  update(byte: number):void;

  updateBytes(bytes: Uint8Array, offset:number, length:number):void;

  getValue():number;

  reset():void;
}