import ClientBuilderConfiguration from './ClientBuilderConfiguration';
import CredentialsProvider from './common/auth/CredentialsProvider';
import OSS from './OSS';

export interface OSSBuilderParam {
  endpoint?: string;
  accessKeyId?: string;
  secretAccessKey?: string;
  securityToken?: string;
  config?: ClientBuilderConfiguration;
  credentialsProvider?: CredentialsProvider;
}

interface OSSBuilder {
  build(param: OSSBuilderParam): OSS;
}

export default OSSBuilder;