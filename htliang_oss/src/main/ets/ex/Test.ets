import DefaultCredentialProvider from '../common/auth/DefaultCredentialProvider';
import OSSClientBuilder from '../OSSClientBuilder';
import PutObjectRequest from '../model/PutObjectRequest';
import ClientBuilderConfiguration from '../ClientBuilderConfiguration';
import { SignVersion } from '../common/comm/SignVersion';
import ByteArrayInputStream from '@htliang/java_type/src/main/ets/java/io/ByteArrayInputStream';
import DomainConstants from '../common/DomainConstants';
import Throwable from '@htliang/java_type/src/main/ets/java/lang/Throwable';
import fs from '@ohos.file.fs';
import InputStream from '@htliang/java_type/src/main/ets/java/io/InputStream';
import FileInputStream from '@htliang/java_type/src/main/ets/java/io/FileInputStream';
import LogUtils from '../common/utils/LogUtils';

export default class Self {
  static async putObject(data: Uint8Array | fs.File | string): Promise<void> {
    let region = DomainConstants.REGION_CN_GUANGZHOU;
    let endpoint = DomainConstants.PUBLIC_ENDPOINT_CN_GUANGZHOU;
    let bucketName = "xxx";
    let objectName: string = Self.prepareObjectKey(data) ?? `new${Date.now()}.txt`;
    let credentialProvider = DefaultCredentialProvider.build("xxx", "xxx", "xxx");

    let ossClient = OSSClientBuilder.create()
      .withEndpoint(`https://${endpoint}`)
      .withCredentialsProvider(credentialProvider)
      .withClientConfiguration(new ClientBuilderConfiguration().withSignatureVersion(SignVersion.V4))// 当前仅支持V4版本
      .withRegion(region)
      .build();

    let putObjectRequest = new PutObjectRequest(bucketName, objectName, Self.prepareInputStream(data));
    putObjectRequest.setSendProgressCallBack((info) => {
      LogUtils.info(`totalSize: ${info.totalSize}, sendSize: ${info.sendSize}`);
    });

    ossClient.putObject(putObjectRequest).then((putObjectResult) => {
      console.log('putObject success, putObjectResult=', JSON.stringify(putObjectResult));
    }).catch((e: Throwable) => {
      console.error("putObject fail for ", JSON.stringify(e))
    });

    // 当然可以用await
    // try {
    //   let result = await ossClient.putObject(putObjectRequest);
    // } catch (e) {
    //   console.error("putObject fail for ", JSON.stringify(e));
    // }
  }

  static prepareObjectKey(data: Uint8Array | fs.File | string): string | undefined {
    if (data instanceof Uint8Array) {
      return undefined;
    }
    if (typeof data === 'string') {
      let file = fs.openSync(data);
      let name = file.name;
      fs.closeSync(file.fd);
      return name;
    }
    return data.name;
  }

  static prepareInputStream(data: Uint8Array | fs.File | string): InputStream {
    if (data instanceof Uint8Array) {
      return new ByteArrayInputStream(data);
    }
    if (typeof data === 'string') {
      return new FileInputStream(data);
    }
    return new FileInputStream(data);
  }
}