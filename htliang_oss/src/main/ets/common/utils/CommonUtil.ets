export default class CommonUtil {
  public static new2DArray(row: number, column: number): number[][] {
    let array: number[][] = [];
    for (let i = 0; i < row; i++) {
      array[i] = [];
      for (let j = 0; j < column; j++) {
        array[i][j] = 0; // 初始化值
      }
    }
    return array;
  }
}