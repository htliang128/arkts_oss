import Credentials from '../../common/auth/Credentials';
import { RequestPresigner } from '../../common/auth/RequestPresigner';
import { RequestSigner } from '../../common/auth/RequestSigner';
import RequestMessage from '../../common/comm/RequestMessage';
import DateUtil from '../../common/utils/DateUtil';
import OSSHeaders from '../OSSHeaders';
import OSSSignerParams from './OSSSignerParams';


export default abstract class OSSSignerBase implements RequestSigner, RequestPresigner {
  protected signerParams: OSSSignerParams;

  protected constructor(signerParams: OSSSignerParams) {
    this.signerParams = signerParams;
  }

  protected addDateHeaderIfNeeded(request: RequestMessage): void {
    let now: Date = new Date();
    if (this.signerParams.getTickOffset() != 0) {
      now.setTime(now.getTime() + this.signerParams.getTickOffset());
    }
    request.getHeaders().set(OSSHeaders.DATE, DateUtil.formatRfc822Date(now));
  }

  protected addSecurityTokenHeaderIfNeeded(request: RequestMessage): void {
    let cred: Credentials = this.signerParams.getCredentials();
    if (cred.useSecurityToken() && !request.getUseUrlSignature()) {
      request.addHeader(OSSHeaders.OSS_SECURITY_TOKEN, cred.getSecurityToken());
    }
  }

  protected isAnonymous(): boolean {
    let cred: Credentials = this.signerParams.getCredentials();
    return cred.getAccessKeyId().length < 1 || cred.getSecretAccessKey().length < 1;
  }

  protected addAuthorizationHeader(request: RequestMessage): void {
  }

  public sign(request: RequestMessage): void {
    this.addDateHeaderIfNeeded(request);
    if (this.isAnonymous()) {
      return;
    }
    this.addSecurityTokenHeaderIfNeeded(request);
    this.addAuthorizationHeader(request);
  }

  // public static createRequestSigner(version: SignVersion, signerParams: OSSSignerParams): RequestSigner {
  //   if (SignVersion.V4 == version) {
  //     return new OSSV4Signer(signerParams);
  //   }
  //
  //   throw new Error("only support SignVersion.V4")
  // }


  presign(request: RequestMessage): void {
    throw new Error('Method not implemented.');
  }
}