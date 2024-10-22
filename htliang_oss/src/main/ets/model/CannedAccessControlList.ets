enum CannedAccessControlList {
  /**
   * This is only for object, means the permission inherits the bucket's
   * permission.
   */
  Default = "default",

  /**
   * The owner has full control, other users do not have access.
   */
  Private = "private",

  /**
   * The owner has full control, other users have read-only access.
   */
  PublicRead = "public-read",

  /**
   * Both the owner and other users have full control. It's not safe and thus not recommended.
   */
  PublicReadWrite = "public-read-write",

  /**
   * The owner has full control, other users have authenticated-read access.
   */
  AuthenticatedRead = "authenticated-read",

  /**
   * Unknown
   */
  Unknown = "Unknown"
}

namespace CannedAccessControlList {
  export function parse(acl: string): CannedAccessControlList {
    switch (acl) {
      case CannedAccessControlList.Default:
        return CannedAccessControlList.Default;
      case CannedAccessControlList.Private:
        return CannedAccessControlList.Private;
      case CannedAccessControlList.PublicRead:
        return CannedAccessControlList.PublicRead;
      case CannedAccessControlList.PublicReadWrite:
        return CannedAccessControlList.PublicReadWrite;
      case CannedAccessControlList.AuthenticatedRead:
        return CannedAccessControlList.AuthenticatedRead;
      default:
        return CannedAccessControlList.Unknown;
    }
  }
}

export default CannedAccessControlList;
