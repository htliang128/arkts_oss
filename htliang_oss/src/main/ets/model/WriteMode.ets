import { http } from '@kit.NetworkKit';

enum WriteMode {
  APPEND = 'APPEND',
  OVERWRITE = 'OVERWRITE'
}

namespace WriteMode {
  export function toString(mode: WriteMode): string {
    return mode;
  }

  export function getMappingMethod(mode: WriteMode): http.RequestMethod {
    switch (mode) {
      case WriteMode.APPEND:
        return http.RequestMethod.POST;
      case WriteMode.OVERWRITE:
        return http.RequestMethod.PUT;
      default:
        throw new Error("Unsupported write mode: " + mode);
    }
  }
}

export default WriteMode;
