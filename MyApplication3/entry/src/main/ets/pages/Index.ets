import IOUtils from '@htliang/oss/src/main/ets/common/utils/IOUtils'
import ExUtils from '@htliang/oss/src/main/ets/ex/exUtils'
import fs from '@ohos.file.fs';
import { buffer } from '@kit.ArkTS';
import { BusinessError } from '@kit.BasicServicesKit';

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';

  xx() {

    console.log("xxxvasgdssgs " + IOUtils.checkFilePath(getContext(this).resourceDir + '/new.txt'))

    let path: string = getContext(this).resourceDir + '/new.txt';
    let stream = fs.createStreamSync(path, "r")
    fs.stat(path).then((stac) => {
      let small = stac.size;
      let arrayBuffer = new ArrayBuffer(4096);
      let uint88 = new Uint8Array(small);
      stream.read(arrayBuffer).then(async (readLen: number) => {
        console.info("read data succeed");
        let buf = buffer.from(arrayBuffer, 0, readLen);
        buf.copy(uint88, uint88.byteOffset);
        console.log(`The content of file: ${buf.toString()}`);
        console.log("xxxxxx " + JSON.stringify(buf))
        console.log("xxxxxx " + JSON.stringify(uint88))
        console.log("xxxxxx " + buf.length)
        console.log("xxxxxx " + uint88.length)

        await ExUtils.putObject(uint88);


        stream.close();
      }).catch((err: BusinessError) => {
        console.error("read data failed with error message: " + err.message + ", error code: " + err.code);
      });


    })
    let arrayBuffer = new ArrayBuffer(4096);

    let o = 0;


  }

  build() {
    RelativeContainer() {
      Column() {
        Button("ZGDds")
          .onClick(() => {
            this.xx()
          })
      }
      .alignItems(HorizontalAlign.Center)
      .justifyContent(FlexAlign.Center)
      .height('100%')
      .width('100%')
    }
    .height('100%')
    .width('100%')
  }
}