import Self from '@htliang/oss/src/main/ets/ex/Self';
import { picker } from '@kit.CoreFileKit';
import { BusinessError } from '@kit.BasicServicesKit';

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';

  async selectAndUpload() {
    try {
      let documentSelectOptions = new picker.DocumentSelectOptions();
      documentSelectOptions.maxSelectNumber = 1;
      let documentPicker = new picker.DocumentViewPicker(getContext(this));
      documentPicker.select(documentSelectOptions).then((documentSelectResult: Array<string>) => {
        let uri = documentSelectResult[0];
        Self.putObject(uri);
      }).catch((err: BusinessError) => {
        console.error('DocumentViewPicker.select failed with err: ' + JSON.stringify(err));
      });
    } catch (error) {
      let err: BusinessError = error as BusinessError;
      console.error('DocumentViewPicker failed with err: ' + JSON.stringify(err));
    }
  }

  build() {
    RelativeContainer() {
      Column() {
        Button("选择文件以上传")
          .onClick(() => {
            this.selectAndUpload()
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