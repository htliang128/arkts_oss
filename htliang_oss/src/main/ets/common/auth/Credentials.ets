export default  interface Credentials {
  accessKeyId: string;
  accessKeySecret: string;
  securityToken: string;

  getAccessKeyId(): string;

  getSecretAccessKey(): string;

  getSecurityToken(): string;

  useSecurityToken(): boolean;
}