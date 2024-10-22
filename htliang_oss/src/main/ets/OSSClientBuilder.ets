import ClientBuilderConfiguration from './ClientBuilderConfiguration';
import CredentialsProvider from './common/auth/CredentialsProvider';
import OSS from './OSS';
import OSSBuilder, { OSSBuilderParam } from './OSSBuilder';

export default class OSSClientBuilder implements  OSSBuilder {
  build(param: OSSBuilderParam): OSS{



		return
	}







  // build(endpoint: string, accessKeyId: string, secretAccessKey: string, securityToken: string): OSS;
  //
  // build(endpoint: string, accessKeyId: string, secretAccessKey: string, config: ClientBuilderConfiguration): OSS;
  //
  // build(endpoint: string, accessKeyId: string, secretAccessKey: string, securityToken: string,
  //   config: ClientBuilderConfiguration): OSS;
  //
  // build(endpoint: string, credentialsProvider: CredentialsProvider): OSS;
  //
  // build(endpoint: string, credentialsProvider: CredentialsProvider, config: ClientBuilderConfiguration): OSS;
  //
  // build(endpoint: string, accessKeyId: string, secretAccessKey?: string, securityToken?: string,
  //   config?: ClientBuilderConfiguration): import("./OSS").default {
  //   throw new Error('Method not implemented.');
  // }

}