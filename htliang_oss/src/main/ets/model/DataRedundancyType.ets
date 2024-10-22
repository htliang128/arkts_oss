enum DataRedundancyType {
  /**
   * LRS
   */
  LRS = "LRS",

  /**
   * ZRS
   */
  ZRS = "ZRS",

  /**
   * Unknown
   */
  Unknown = "Unknown"
}

namespace DataRedundancyType {
  export function parse(dataRedundancyTypeString: string): DataRedundancyType {
    switch (dataRedundancyTypeString) {
      case DataRedundancyType.LRS:
        return DataRedundancyType.LRS;
      case DataRedundancyType.ZRS:
        return DataRedundancyType.ZRS;
      default:
        return DataRedundancyType.Unknown;
    }
  }
}

export default DataRedundancyType;
