import Checksum from "@htliang/java_type/src/main/ets/java/util/zip/Checksum";

export default class CRC64 implements Checksum {
  private static table: bigint[] = CRC64.createTable();
  private crc: bigint = BigInt(0);

  constructor() {
    this.reset();
  }

  private static createTable(): bigint[] {
    const poly = BigInt('0xC96C5795D7870F42');
    const table: bigint[] = new Array(256).fill(BigInt(0));

    for (let i = 0; i < 256; i++) {
      let crc = BigInt(i);
      for (let j = 0; j < 8; j++) {
        if (crc & BigInt(1)) {
          crc = (crc >> BigInt(1)) ^ poly;
        } else {
          crc >>= BigInt(1);
        }
      }
      table[i] = crc;
    }
    return table;
  }

  public update(byte: number): void {
    this.updateBytes(new Uint8Array([byte]), 0, 1);
  }

  public updateBytes(bytes: Uint8Array, offset: number, length: number): void {
    for (let i = offset; i < offset + length; i++) {
      const tableIndex = Number((this.crc ^ BigInt(bytes[i])) & BigInt(0xFF));
      this.crc = CRC64.table[tableIndex] ^ (this.crc >> BigInt(8));
    }
  }

  public getValue(): number {
    return Number(this.crc ^ BigInt('0xFFFFFFFFFFFFFFFF'));
  }

  public reset(): void {
    this.crc = BigInt('0xFFFFFFFFFFFFFFFF');
  }
}