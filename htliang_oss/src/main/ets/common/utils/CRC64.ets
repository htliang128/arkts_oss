import Checksum from "@htliang/java_type/src/main/ets/java/util/zip/Checksum";

const BIG_1 = BigInt(1);
const BIG_8 = BigInt(8);
const BIG_16 = BigInt(16);
const BIG_24 = BigInt(24);
const BIG_32 = BigInt(32);
const BIG_40 = BigInt(40);
const BIG_48 = BigInt(48);
const BIG_56 = BigInt(56);
const BIG_FF = BigInt(0xFF);

export default class CRC64 implements Checksum {
  private static POLY = BigInt('0xC96C5795D7870F42');
  private static table: bigint[][] = CRC64.createTable();
  private crc: bigint = BigInt(0);

  constructor() {
    this.reset();
  }

  private static createTable(): bigint[][] {
    const table: bigint[][] = new Array(8).fill(0).map(() => new Array(256).fill(0));
    for (let i = 0; i < 256; i++) {
      let crc = BigInt(i);
      for (let j = 0; j < 8; j++) {
        if (crc & BIG_1) {
          crc = (crc >> BIG_1) ^ CRC64.POLY;
        } else {
          crc >>= BIG_1;
        }
      }
      table[0][i] = crc;
    }

    /* generate nested CRC table for future slice-by-8 lookup */
    for (let n = 0; n < 256; n++) {
      let crc = table[0][n];
      for (let k = 1; k < 8; k++) {
        crc = table[0][(Number)(crc & BIG_FF)] ^ (crc >> BIG_8);
        table[k][n] = crc;
      }
    }

    return table;
  }

  public update(byte: number): void {
    this.updateBytes(new Uint8Array([byte]), 0, 1);
  }

  public updateBytes(bytes: Uint8Array, offset: number, length: number): void {
    let end = offset + length;
    let i = offset;

    // Process 8 bytes at a time
    for (; i <= end - 8; i += 8) {
      this.crc ^= BigInt(bytes[i]) | (BigInt(bytes[i + 1]) << BIG_8) |
        (BigInt(bytes[i + 2]) << BIG_16) | (BigInt(bytes[i + 3]) << BIG_24) |
        (BigInt(bytes[i + 4]) << BIG_32) | (BigInt(bytes[i + 5]) << BIG_40) |
        (BigInt(bytes[i + 6]) << BIG_48) | (BigInt(bytes[i + 7]) << BIG_56);

      this.crc = CRC64.table[7][Number(this.crc & BIG_FF)] ^
      CRC64.table[6][Number((this.crc >> BIG_8) & BIG_FF)] ^
      CRC64.table[5][Number((this.crc >> BIG_16) & BIG_FF)] ^
      CRC64.table[4][Number((this.crc >> BIG_24) & BIG_FF)] ^
      CRC64.table[3][Number((this.crc >> BIG_32) & BIG_FF)] ^
      CRC64.table[2][Number((this.crc >> BIG_40) & BIG_FF)] ^
      CRC64.table[1][Number((this.crc >> BIG_48) & BIG_FF)] ^
      CRC64.table[0][Number((this.crc >> BIG_56) & BIG_FF)];
    }

    // Process remaining bytes
    for (; i < end; i++) {
      this.crc = CRC64.table[0][Number((this.crc ^ BigInt(bytes[i])) & BIG_FF)] ^ (this.crc >> BIG_8);
    }
  }

  public getValue(): number {
    return Number(this.crc ^ BigInt('0xFFFFFFFFFFFFFFFF'));
  }

  public reset(): void {
    this.crc = BigInt('0xFFFFFFFFFFFFFFFF');
  }
}