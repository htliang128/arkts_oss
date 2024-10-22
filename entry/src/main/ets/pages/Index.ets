import IOUtils from '@htliang/oss/src/main/ets/common/utils/IOUtils'
import fs from '@ohos.file.fs';
import { buffer } from '@kit.ArkTS';
import { BusinessError } from '@kit.BasicServicesKit';
import BinaryUtil from '@htliang/oss/src/main/ets/common/utils/BinaryUtil';

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';

  xx() {
    let xxxxx = 'qwertyuiop[]~-!@#$%^&*()_+ASDFGHJKL:ZXCVBNM<>?1234567890QWERTYUIOP{}asdfghjkl;zxcvbnm,./';
    let encr = BinaryUtil.sm4Encrypt(xxxxx, '1234');
    console.log('xxxxxxxxxxxxxxxxxxxxxxxxx:', encr);


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