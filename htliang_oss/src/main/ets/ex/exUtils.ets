// import RequestMessage from '../common/comm/RequestMessage'
// import { buffer, uri } from '@kit.ArkTS';
// import { HttpMethod } from '../common/comm/HttpMethod';
// import BinaryUtil from '../common/utils/BinaryUtil';
// import DateUtil from '../common/utils/DateUtil';
// import OSSSignerParams from '../internal/signer/OSSSignerParams';
// import BasicCredentials from '../common/auth/Credentials';
// import OSSV4Signer from '../internal/signer/OSSV4Signer';
// import axios, { AxiosHeaders, RawAxiosRequestHeaders } from '@ohos/axios';
// import { Request } from './AllIn';
// import DefaultCredentialProvider from '../common/auth/DefaultCredentialProvider';
// import OSSClientBuilder from '../OSSClientBuilder';
// import PutObjectRequest from '../model/PutObjectRequest';
// import DomainConstants from '../common/DomainConstants';
//
// export default class ExUtils {
//   static async putObject(data: Uint8Array) {
//     let credentialProvider = DefaultCredentialProvider.build("","","");
//     let bucketName = "";
//     let objectName = "";
//     let ossClient = new OSSClientBuilder().build({endpoint:DomainConstants.PublicEndpoint.CN_GUANGZHOU, credentialsProvider:credentialProvider})
//     let putObjectRequest = new PutObjectRequest(bucketName, objectName,undefined,undefined,undefined);
//
//     ossClient.putObject()
//
//
//
//     let reqMsg: RequestMessage = new RequestMessage();
//     reqMsg.bucket = 'lhongtao20240912';
//     reqMsg.resourcePath = '/lhongtao20240912/new.txt'
//     reqMsg.endpoint = new uri.URI('lhongtao20240912.oss-cn-guangzhou.aliyuncs.com');
//     reqMsg.key = 'new.txt';
//     reqMsg.method = HttpMethod.PUT;
//     reqMsg.addHeader('Cache-Control', 'no-cache');
//     reqMsg.addHeader('Content-Disposition', 'attachment; filename="new.txt"');
//     reqMsg.addHeader('Content-Encoding', 'identity');
//     reqMsg.addHeader('Content-MD5', buffer.from(BinaryUtil.calculateMd5(data).data).toString('base64'));
//     reqMsg.addHeader('Content-Length', data.length.toString());
//     reqMsg.addHeader('ETag', BinaryUtil.toHex(BinaryUtil.calculateMd5(data)).toUpperCase());
//     reqMsg.addHeader('Content-Type', 'application/octet-stream');
//     reqMsg.addHeader('Date', DateUtil.formatRfc822Date(new Date()));
//     reqMsg.addHeader('Host', 'lhongtao20240912.oss-cn-guangzhou.aliyuncs.com');
//     reqMsg.addHeader('x-oss-security-token',
//       'CAISvAJ1q6Ft5B2yfSjIr5aHD9Hs25lJ+fOmYF70kWsCdf9itvPG0zz2IHhMfHNgA+oXs/0xm25W6PcdlqF6UJNMXkDNdpOXR0iIB1nzDbDasumZsJYm6vT8a0XxZjf/2MjNGZabKPrWZvaqbX3diyZ32sGUXD6+XlujQ/br4NwdGbZxZASjaidcD9p7PxZrrNRgVUHcLvGwKBXn8AGyZQhKwlMl1jkms/zlk5DHtEaB1APAp7VL99irEP+NdNJxOZpzadCx0dFte7DJuCwqsEASrP0m1vYVpG6Z4Y/DXQgO+XqaPvHI9cZ0PIWh1W7KskwuRpHf4h4Y0oS7/+yfo53NKvte0HCUDXYslH5Yok99qhTd4Yy6WhKDm5nEXaLOmGg/Kkl4V0gxILFCMVQdZ1FSDF+TRMCpkMs1nRz8I8DtGoABm86Y3YffDURN7VKLPDO+av4kGzlViwmlfv7JwgzleXUVBIofzH9VKxk5VJj4eaRov3RK/JHoNSeL+zB+impHYPhHlnUXaFqJfDh2ruXNoRGZyq+4Ex2bT6SMb9VbPg0doZVIn2UUzlFxSojcgq1g/Ym1H3x3LMo3dHnVfspTFHMgAA==');
//
//     let credentials = new BasicCredentials(
//       'STS.NU2DkX6FhN1MbxEukWypNY6m1',
//       'FRvgmZiMpyFYafCXxmATPNecNDM98RuWZAFC6UmriYwG',
//       'CAISvAJ1q6Ft5B2yfSjIr5aHD9Hs25lJ+fOmYF70kWsCdf9itvPG0zz2IHhMfHNgA+oXs/0xm25W6PcdlqF6UJNMXkDNdpOXR0iIB1nzDbDasumZsJYm6vT8a0XxZjf/2MjNGZabKPrWZvaqbX3diyZ32sGUXD6+XlujQ/br4NwdGbZxZASjaidcD9p7PxZrrNRgVUHcLvGwKBXn8AGyZQhKwlMl1jkms/zlk5DHtEaB1APAp7VL99irEP+NdNJxOZpzadCx0dFte7DJuCwqsEASrP0m1vYVpG6Z4Y/DXQgO+XqaPvHI9cZ0PIWh1W7KskwuRpHf4h4Y0oS7/+yfo53NKvte0HCUDXYslH5Yok99qhTd4Yy6WhKDm5nEXaLOmGg/Kkl4V0gxILFCMVQdZ1FSDF+TRMCpkMs1nRz8I8DtGoABm86Y3YffDURN7VKLPDO+av4kGzlViwmlfv7JwgzleXUVBIofzH9VKxk5VJj4eaRov3RK/JHoNSeL+zB+impHYPhHlnUXaFqJfDh2ruXNoRGZyq+4Ex2bT6SMb9VbPg0doZVIn2UUzlFxSojcgq1g/Ym1H3x3LMo3dHnVfspTFHMgAA=='
//     );
//
//     let ossParams = new OSSSignerParams('/lhongtao20240912/new.txt', credentials);
//     ossParams.region = "cn-guangzhou";
//     ossParams.product = "oss"
//     let signer = new OSSV4Signer(ossParams);
//     signer.sign(reqMsg);
//
//     console.log("xxxxxx");
//
//     let headers = new AxiosHeaders();
//     reqMsg.headers.forEach((value, key) => {
//       headers.set(key, value);
//     })
//
//     let result = await Request({
//       method: 'PUT',
//       url: '/new.txt',
//       headers: headers,
//       data: data
//     })
//     console.log("xxxxxx " + result);
//
//
//   }
// }