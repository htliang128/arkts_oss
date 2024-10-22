enum Payer {
  BucketOwner = "BucketOwner",
  Requester = "Requester"
}

namespace Payer {
  export function parse(payer: string): Payer {
    switch (payer.toLowerCase()) {
      case Payer.BucketOwner.toLowerCase():
        return Payer.BucketOwner;
      case Payer.Requester.toLowerCase():
        return Payer.Requester;
      default:
        throw new Error(`Unable to parse the payer text ${payer}`);
    }
  }
}

export default Payer;
