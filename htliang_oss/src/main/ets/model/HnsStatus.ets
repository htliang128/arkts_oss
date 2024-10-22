enum HnsStatus {
  /**
   * Enabled
   */
  Enabled = "Enabled"
}

namespace HnsStatus {
  export function parse(hnsString: string): HnsStatus {
    if (hnsString === HnsStatus.Enabled) {
      return HnsStatus.Enabled;
    }
    throw new Error(`Unable to parse ${hnsString}`);
  }
}

export default HnsStatus;
