import Test from '@htliang/oss/src/main/ets/ex/Test';
import BinaryUtil from '@htliang/oss/src/main/ets/common/utils/BinaryUtil';

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';

  async xx() {
    let txtContent= "现在时间是"+ new Date().toString();
    await Test.putObject(BinaryUtil.getUtf8Array(txtContent));
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