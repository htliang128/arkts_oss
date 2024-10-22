enum StorageClass {
  Standard = "Standard",
  IA = "IA",
  Archive = "Archive",
  ColdArchive = "ColdArchive",
  DeepColdArchive = "DeepColdArchive",
  Unknown = "Unknown"
}

namespace StorageClass {
  export function parse(storageClassString: string): StorageClass {
    switch (storageClassString) {
      case StorageClass.Standard:
        return StorageClass.Standard;
      case StorageClass.IA:
        return StorageClass.IA;
      case StorageClass.Archive:
        return StorageClass.Archive;
      case StorageClass.ColdArchive:
        return StorageClass.ColdArchive;
      case StorageClass.DeepColdArchive:
        return StorageClass.DeepColdArchive;
      default:
        return StorageClass.Unknown;
    }
  }
}

export default StorageClass;
