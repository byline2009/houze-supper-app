import 'dart:io';
import 'package:christian_picker_image/christian_picker_image.dart';
//import 'package:multi_image_picker2/multi_image_picker2.dart';
//import 'package:houze_super/utils/multiple_image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:houze_super/presentation/common_widgets/widget_dialog_custom.dart';

enum AppState {
  free,
  picked,
  cropped,
}

typedef Future<dynamic> CallBackHandler(File file);
typedef Widget CallBackWidgetHandler(dynamic params, String state);

class PickCropImage extends StatefulWidget {
  String? text;
  bool? isDisable;
  bool? showIcon;
  CallBackHandler callback;
  CallBackWidgetHandler? buildElement;

  PickCropImage(
      {this.text,
      this.buildElement,
      this.isDisable,
      required this.callback,
      this.showIcon});

  PickCropImageState createState() => PickCropImageState();
}

class PickCropImageState extends State<PickCropImage> {
  late AppState state;
  List<File> imageFile = [];
  //late List<Asset> images = <Asset>[];
  dynamic params;
  late String url;

  @override
  void initState() {
    super.initState();
    this.state = AppState.free;
  }

  Future<Null> _pickImage() async {
    try {
      var status = await Permission.storage.status;

      if (status.isPermanentlyDenied) {
        DialogCustom.showAlertDialog(
          context: context,
          title: 'Photos Permission',
          content: 'This app needs access to the photo gallery',
          buttonText: 'Settings',
          buttonCancel: 'Deny',
          onPressed: () {
            openAppSettings();
            Navigator.pop(context);
          },
        );
      } else {
        // images = await MultipleImagePicker.getAssetsImage(
        //     images: images, maxImages: 1);

        // if (images.length > 0) {
        //   for (var i in images) {
        //     var image = await MultipleImagePicker.getImageFileFromAssets(i);
        //     imageFile.add(image);
        //   }

        //   setState(() {
        //     this.state = AppState.picked;
        //     _cropImage();
        //   });
        // }

        this.imageFile = await ChristianPickerImage.pickImages(maxImages: 1);
        if (imageFile.isNotEmpty || imageFile.length > 0) {
          setState(() {
            this.state = AppState.picked;
            _cropImage();
          });
        }
      }
      print(status.isPermanentlyDenied);
    } catch (e) {
      print(e);
    }
  }

  // void _clearImage() {
  //   imageFile = null;
  //   setState(() {
  //     this.state = AppState.free;
  //   });
  // }

  Future<Null> _cropImage() async {
    File? croppedFile = await ImageCropper.cropImage(
        sourcePath: imageFile[0].path,
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
          this.imageFile.clear();
          //this.images.clear();
        });
      }
    } else {
      _pickImage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          _pickImage();
        },
        child: SizedBox(
            height: 80,
            width: 80,
            child: Stack(
              children: <Widget>[
                widget.buildElement!(this.params, this.state.toString()),
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
                    : Center()
              ],
            )));
  }
}
