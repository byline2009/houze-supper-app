import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:houze_super/middle/api/image_api.dart';
import 'package:houze_super/middle/model/image_meta_model.dart';
import 'package:houze_super/presentation/common_widgets/stateless/widget_cached_image.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:christian_picker_image/christian_picker_image.dart';
import 'package:dotted_border/dotted_border.dart';

const String parkingRegisterKey = 'parkingRegisterKey';

typedef void OnChangeImageHandler(List<ImageMetaModel> images);

class ParkingImagePicker extends StatefulWidget {
  final List<ImageMetaModel> images;
  final OnChangeImageHandler onChangeImages;

  ParkingImagePicker({@required this.images, this.onChangeImages});

  @override
  _ParkingImagePickerState createState() => _ParkingImagePickerState();
}

class _ParkingImagePickerState extends State<ParkingImagePicker> {
  bool isUploading = false;

  Future<void> loadAssets() async {
    try {
      List<File> imageSelected =
          await ChristianPickerImage.pickImages(maxImages: 1);

      if (imageSelected == null || imageSelected.length == 0) {
        return;
      }
      if (mounted)
        this.setState(() {
          isUploading = true;
        });

      String filePath = imageSelected[0].path;

      var dir = await getTemporaryDirectory();
      var targetPath = dir.absolute.path + "/" + basename(filePath);
      var imageCompressed = await FlutterImageCompress.compressAndGetFile(
        filePath,
        targetPath,
        minHeight: 1280,
        minWidth: 1280,
        quality: 60,
        keepExif: false,
      );
      final imageAPI = ImageAPI();

      final imageUploaded = await imageAPI.uploadImage(imageCompressed);

      imageCompressed.deleteSync();

      widget.images.add(imageUploaded);
      widget.onChangeImages(widget.images);
      if (mounted)
        this.setState(() {
          isUploading = false;
        });
    } on Exception catch (e) {
      print(e);
      if (mounted)
        this.setState(() {
          isUploading = false;
        });
    }
  }

  void removeImage(int imageIndex) {
    setState(() => widget.images.removeAt(imageIndex));
    widget.onChangeImages(widget.images);
  }

  Widget makePickerImage() {
    if (widget.images.length == 5) return const SizedBox.shrink();

    return isUploading
        ? Container(
            alignment: Alignment.center,
            width: 60.0,
            height: 80.0,
            child: SizedBox(
              child: CircularProgressIndicator(),
              height: 20.0,
              width: 20.0,
            ),
          )
        : DottedBorder(
            child: SizedBox(
              width: 60.0,
              height: 80.0,
              child: IconButton(
                icon: Icon(Icons.add_a_photo),
                onPressed: () => loadAssets(),
              ),
            ),
          );
  }

  Widget makeImageList() {
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: widget.images.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10, right: 10),
              child: Stack(
                children: <Widget>[
                  CachedImageWidget(
                    cacheKey: parkingRegisterKey,
                    imgUrl: widget.images[index].url,
                    width: 60.0,
                    height: 80.0,
                  ),
                  Positioned(
                    right: 0.0,
                    top: 0.0,
                    child: GestureDetector(
                      onTap: () => removeImage(index),
                      child: SizedBox(
                        height: 22.0,
                        width: 22.0,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.close,
                            size: 18.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      alignment: Alignment.topLeft,
      child: Row(
        children: <Widget>[
          makePickerImage(),
          makeImageList(),
        ],
      ),
    );
  }
}
