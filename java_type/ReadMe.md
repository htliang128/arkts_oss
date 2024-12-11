# Java Type
## 简介
在ArkTS中实现的Java基类类库，这是笔者在编写Aliyun_OSS_SDK过程中的副产物。暂时包括：
 - 流：InputStream，FileInputStream，ByteArrayInputStream，CheckedInputStream
 - 异常：各种Exception

## 安装
```bash
ohpm i @lhongtaohwlfgo/java_type
```

## 使用
```typescript
let path = '/new.txt'
let fis = new FileInputStream(path);

let buff = fis.readAllBytes();
console.log('text content: ', buff);
```