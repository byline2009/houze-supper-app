import 'package:flutter/material.dart';
import 'package:houze_super/presentation/common_widgets/stateful/picker_image.dart';

typedef FileBaseVoidFunc = void Function(FilePick, FilePick);
typedef FileVoidFunc = void Function(FilePick);

class WidgetImagesBox extends StatefulWidget {
  final FileBaseVoidFunc callbackUploadResult;
  final FileVoidFunc callbackRemoveResult;
  WidgetImagesBoxState child;
  int maxImage = 5;

  WidgetImagesBox(
      {this.callbackUploadResult, this.callbackRemoveResult, this.maxImage});

  @override
  WidgetImagesBoxState createState() => child = WidgetImagesBoxState();
}

class WidgetImagesBoxState extends State<WidgetImagesBox> {
  PickerImage imagePicker;

  @override
  void initState() {
    imagePicker = PickerImage(
        width: 100,
        height: 100,
        type: PickerImageType.list,
        maxImage: widget.maxImage,
        imagesInit: []);

    imagePicker.callbackUpload = (FilePick f, FilePick fCompress) {
      widget.callbackUploadResult(f, fCompress);
    };

    imagePicker.callbackRemove = (FilePick f) {
      widget.callbackRemoveResult(f);
    };

    super.initState();
  }

  void refresh() {
    imagePicker.clear();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: 110, child: imagePicker);
  }
}
