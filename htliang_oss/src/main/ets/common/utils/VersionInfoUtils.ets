import process from '@ohos.process';

export default class VersionInfoUtils {
  private static USER_AGENT_PREFIX: string = "aliyun-sdk-java";
  private static version: string | null = null;
  private static defaultUserAgent: string | null = null;

  public static getVersion(): string {
    if (VersionInfoUtils.version === null) {
      VersionInfoUtils.initializeVersion();
    }
    return VersionInfoUtils.version!;
  }

  public static getDefaultUserAgent(): string {
    if (VersionInfoUtils.defaultUserAgent === null) {
      VersionInfoUtils.defaultUserAgent =
        `${VersionInfoUtils.USER_AGENT_PREFIX}/${VersionInfoUtils.getVersion()}(OpenHarmonyOS/5.0.0(12)/arm64-v8a/;21)`;
    }
    return VersionInfoUtils.defaultUserAgent!;
  }


  private static initializeVersion(): void {
    try {
      VersionInfoUtils.version = "3.18.1";
    } catch (e) {
      console.error("Unable to load version information for the running SDK: ", e);
      VersionInfoUtils.version = "unknown-version";
    }
  }
}
