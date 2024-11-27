import CommonConstant from '../CommonConstant';
import ServiceException from './ServiceException';

export default class OSSException extends ServiceException {
  resourceType?: string;
  header?: string;
  method?: string;

  constructor();

  constructor(errorMessage: string | undefined);

  constructor(errorMessage: string | undefined, cause: Error);

  constructor(errorMessage: string | undefined, errorCode: string | undefined, requestId: string | undefined,
    hostId: string | undefined, header: string | undefined,
    resourceType: string | undefined, method: string | undefined);

  constructor(errorMessage: string | undefined, errorCode: string | undefined, requestId: string | undefined,
    hostId: string | undefined, header: string | undefined,
    resourceType: string | undefined, method: string | undefined, cause: Error);

  constructor(errorMessage: string | undefined, errorCode: string | undefined, requestId: string | undefined,
    hostId: string | undefined, header: string | undefined,
    resourceType: string | undefined, method: string | undefined, rawResponseError: string | undefined);

  constructor(errorMessage: string | undefined, errorCode: string | undefined, requestId: string | undefined,
    hostId: string | undefined, header: string | undefined,
    resourceType: string | undefined, method: string | undefined, rawResponseError: string | undefined, cause: Error);

  constructor(errorMessage: string | undefined, errorCode: string | undefined, requestId: string | undefined,
    hostId: string | undefined, header: string | undefined,
    resourceType: string | undefined, method: string | undefined, rawResponseError: string | undefined,
    cause: Error | undefined,
    ec: string | undefined);

  constructor(arg1?: string | undefined, arg2?: string | Error, arg3?: string | undefined, arg4?: string | undefined,
    arg5?: string | undefined, arg6?: string | undefined,
    arg7?: string | undefined, arg8?: string | Error, arg9?: Error, arg10?: string) {
    if (!arg1) {
      super();
    } else if (!arg2) {
      super(arg1);
    } else if (!arg3) {
      super(arg1, arg2 as Error);
    } else {
      let errorMessage: string = arg1;
      let errorCode: string = arg2 as string;
      let requestId: string = arg3;
      let hostId: string = arg4 ?? CommonConstant.BLANK;
      let header: string = arg5 ?? CommonConstant.BLANK;
      let resourceType: string = arg6 ?? CommonConstant.BLANK;
      let method: string = arg7 ?? CommonConstant.BLANK;
      let rawResponseError: string | undefined;
      let cause: Error | undefined;
      let ec: string | undefined;

      if (arg8 && !arg9) {
        if (typeof arg8 === 'string') {
          rawResponseError = arg8;
        } else {
          cause = arg8;
        }
      } else if (arg8 && arg9) {
        rawResponseError = arg8 as string;
        cause = arg9;
        ec = arg10;
      }
      super(errorMessage, errorCode, requestId, hostId, rawResponseError, cause, ec);
      this.resourceType = resourceType;
      this.header = header;
      this.method = method;
    }

    this.message += this.resourceType ? CommonConstant.BLANK : "\n[ResourceType]: " + this.resourceType;
    this.message += this.header == CommonConstant.BLANK ? CommonConstant.BLANK : "\n[Header]: " + this.header;
    this.message += this.method == CommonConstant.BLANK ? CommonConstant.BLANK : "\n[Method]: " + this.method;
  }
}