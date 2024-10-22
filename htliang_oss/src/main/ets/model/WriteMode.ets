import { HttpMethod } from '../common/comm/HttpMethod';

enum WriteMode {
  APPEND = 'APPEND',
  OVERWRITE = 'OVERWRITE'
}

namespace WriteMode {
  export function toString(mode: WriteMode): string {
    return mode;
  }

  export function getMappingMethod(mode: WriteMode): HttpMethod {
    switch (mode) {
      case WriteMode.APPEND:
        return HttpMethod.POST;
      case WriteMode.OVERWRITE:
        return HttpMethod.PUT;
      default:
        throw new Error("Unsupported write mode: " + mode);
    }
  }
}

export default WriteMode;
