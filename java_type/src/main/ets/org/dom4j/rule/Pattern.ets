export default  interface Pattern extends NodeFilter {
  ANY_NODE: number;
  NONE: number;
  NUMBER_OF_TYPES: number;
  DEFAULT_PRIORITY: number;

  matches(node: Node): boolean;

  getPriority(): number;

  getUnionPatterns(): Pattern[] | null;

  getMatchType(): number;

  getMatchesNodeName(): string | null;
}

export const ANY_NODE = 0;
export const NONE = 9999;
export const NUMBER_OF_TYPES = 14;
export const DEFAULT_PRIORITY = 0.5;