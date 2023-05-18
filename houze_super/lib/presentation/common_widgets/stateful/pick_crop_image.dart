import 'dart:io';
import 'package:christian_picker_image/christian_picker_image.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:houze_super/middle/local/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:houze_super/utils/permission_handler.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

enum AppState {
  free,
  picked,
  cropped,
}
typedef Future<dynamic> CallBackHandlerPickImage(File file);
typedef Widget CallBackWidgetHandler(dynamic params, String state);

class PickCropImage extends StatefulWidget {
  String text;
  bool isDisable;
  bool showIcon;
  CallBackHandlerPickImage callback;
  CallBackWidgetHandler buildElement;

  PickCropImage(
      {this.text,
      this.buildElement,
      this.isDisable,
      @required this.callback,
      this.showIcon});

  PickCropImageState createState() => PickCropImageState();
}

class PickCropImageState extends State<PickCropImage> {
  AppState state;
  List<File> imageFile;
  dynamic params;
  String url;
  int numberOfRejections;
  final prefs = Storage.prefs;

  @override
  void initState() {
    this.state = AppState.free;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<Null> _pickImage() async {
    try {
      imageFile = await ChristianPickerImage.pickImages(maxImages: 1);
      if (imageFile != null && imageFile.length > 0) {
        setState(() {
          this.state = AppState.picked;
        });
        var dir = await getTemporaryDirectory();
        var targetPath =
            dir.absolute.path + "/" + p.basename(imageFile.first.path);

        await FlutterImageCompress.compressAndGetFile(
                imageFile.first.absolute.path, targetPath,
                minHeight: 960, minWidth: 960, quality: 60, keepExif: false)
            .then((value) async {
          _cropImage(value);
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<Null> _cropImage(File file) async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: file.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ]
            : [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio5x3,
                CropAspectRatioPreset.ratio5x4,
                CropAspectRatioPreset.ratio7x5,
                CropAspectRatioPreset.ratio16x9
              ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings());
    if (croppedFile != null) {
      imageFile[0] = croppedFile;
      setState(() {
        this.state = AppState.cropped;
      });
      dynamic rs = await widget.callback(croppedFile);

      if (rs != null) {
        this.params = rs;
        setState(() {
          this.state = AppState.free;
        });
      }
    } else {
      //_pickImage();
      PermissionHandler.checkAndRequestStoragePermission(
          context: context, func: _pickImage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          //_pickImage();
          PermissionHandler.checkAndRequestStoragePermission(
              context: context, func: _pickImage);
        },
        child: SizedBox(
            height: 80,
            width: 80,
            child: Stack(
              children: <Widget>[
                widget.buildElement(this.params, this.state.toString()),
                widget.showIcon == true
                    ? Positioned(
                        child: Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: <Color>[
                                  Color(0xFF725ef6),
                                  Color(0xFF6001d1),
                                ],
                              ),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 12,
                              ),
                            )),
                        right: 0,
                        bottom: 0)
                    : const SizedBox.shrink()
              ],
            )));
  }
}
