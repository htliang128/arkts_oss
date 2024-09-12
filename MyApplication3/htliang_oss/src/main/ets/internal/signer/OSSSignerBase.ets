import Credentials from '../../common/auth/Credentials';
import { RequestPresigner } from '../../common/auth/RequestPresigner';
import { RequestSigner } from '../../common/auth/RequestSigner';
import RequestMessage from '../../common/comm/RequestMessage';
import { SignVersion } from '../../common/comm/SignVersion';
import DateUtil from '../../common/utils/DateUtil';
import OSSHeaders from '../OSSHeaders';
import OSSSignerParams from './OSSSignerParams';
import OSSV4Signer from './OSSV4Signer';


export default abstract class OSSSignerBase implements RequestSigner, RequestPresigner {
  protected signerParams: OSSSignerParams;

  protected constructor(signerParams: OSSSignerParams) {
    this.signerParams = signerParams;
  }

  protected addDateHeaderIfNeeded(request: RequestMessage): void {
    let now: Date = new Date();
    if (this.signerParams.tickOffset != 0) {
      now.setTime(now.getTime() + this.signerParams.tickOffset);
    }
    request.headers.set(OSSHeaders.DATE, DateUtil.formatRfc822Date(now));
  }

  protected addSecurityTokenHeaderIfNeeded(request: RequestMessage): void {
    let cred: Credentials = this.signerParams.credentials;
    if (cred.useSecurityToken() && !request.useUrlSignature) {
      request.addHeader(OSSHeaders.OSS_SECURITY_TOKEN, cred.getSecurityToken());
    }
  }

  protected isAnonymous(): boolean {
    let cred: Credentials = this.signerParams.credentials;
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

  public static createRequestSigner(version: SignVersion, signerParams: OSSSignerParams): RequestSigner {
    if (SignVersion.V4 == version) {
      return new OSSV4Signer(signerParams);
    }

    throw new Error("only support SignVersion.V4")
  }


  presign(request: RequestMessage): void {
    throw new Error('Method not implemented.');
  }
}