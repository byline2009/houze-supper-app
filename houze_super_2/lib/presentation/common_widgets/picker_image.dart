import 'dart:async';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:christian_picker_image/christian_picker_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_svg/svg.dart';
import 'package:houze_super/presentation/common_widgets/widget_cached_image.dart';
import 'package:houze_super/utils/constant/index.dart';
import 'package:houze_super/utils/localizations_util.dart';

import 'package:houze_super/presentation/common_widgets/widget_dialog_custom.dart';

typedef void CallBackUploadHandler(FilePick file, FilePick fileCompress);
typedef void CallBackRemoveHandler(FilePick file);

enum PickerImageType { grid, list }

const String pickerImageKey = 'pickerImageKey';

class FilePick {
  String? id;
  String? url;
  String? urlThumb;
  File file;

  FilePick({this.id, required this.file, this.url, this.urlThumb});
}

class PickerImage extends StatefulWidget {
  late CallBackUploadHandler callbackUpload;
  late CallBackRemoveHandler callbackRemove;

  int maxImage;
  double? width, height;
  PickerImageType type;
  PickerImageState state = PickerImageState();
  List<FilePick>? imagesInit = <FilePick>[];

  PickerImage(
      {Key? key,
      this.maxImage = 1,
      this.width,
      this.height,
      this.imagesInit,
      this.type = PickerImageType.grid})
      : super(key: key) {
    if (this.imagesInit == null) {
      this.imagesInit = <FilePick>[];
    }
  }

  void clear() {
    state.clear();
    state.filesPick = <FilePick>[];
    state.validationFilesPick = <FilePick>[];
    state.uploadParrallel = <Future<dynamic>>[];
  }

  @override
  PickerImageState createState() => state;
}

class PickerImageState extends State<PickerImage> {
  List<FilePick> filesPick = <FilePick>[];
  var filesCompressedPickMapWithBaseFile = <File, File>{};
  //Final pick
  List<FilePick> validationFilesPick = <FilePick>[];
  File? _fileSelected;
  List<Future<dynamic>> uploadParrallel = <Future<dynamic>>[];
  var canPickImage = true;

  @override
  void initState() {
    super.initState();
    this.fillWithInitImages();
  }

  void clear() {
    this.filesPick = <FilePick>[];
    this._fileSelected = null;
    setState(() {});
  }

  void fillWithInitImages() {
    this.filesPick = this.filesPick + widget.imagesInit!;
    this.validationFilesPick = this.validationFilesPick + widget.imagesInit!;
  }

  Future<void> uploadImage(FilePick file, FilePick compressFile) async {
    widget.callbackUpload(file, compressFile);
  }

  Future<void> uploadProcessing(BuildContext context) async {
    List<File> images = <File>[];
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
        // TODO: Multi image picker
        images = await ChristianPickerImage.pickImages(
            maxImages: widget.maxImage - this.filesPick.length);
      }
    } catch (e) {
      print(e.toString());
    } finally {
      // Navigator.of(context).pop();

      if (images.length > 0) {
        _fileSelected = images[0];
      }

      await Future.forEach(images, (File image) async {
        FilePick basePick = FilePick(file: image);
        this.filesPick.insert(0, basePick);

        var dir = await getTemporaryDirectory();
        var targetPath = dir.absolute.path + "/" + basename(image.path);

        var compressImage = await FlutterImageCompress.compressAndGetFile(
            image.absolute.path, targetPath,
            minHeight: 1280, minWidth: 1280, quality: 60, keepExif: false);

        filesCompressedPickMapWithBaseFile[basePick.file] = compressImage!;

        if (Platform.isIOS) {
          image.deleteSync();
        }

        uploadParrallel
            .add(uploadImage(basePick, FilePick(file: compressImage)));
      });

      setState(() {});
    }
  }

  Future pickImage(BuildContext context) async {
    if (!canPickImage) {
      return;
    }
    canPickImage = false;
    uploadProcessing(context);
    canPickImage = true;
  }

  Widget photoImage(FilePick f) {
    File? compressFile = filesCompressedPickMapWithBaseFile[f.file];

    return Container(
      child: Stack(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(top: 10, right: 10),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(4.0),
                child: Stack(
                  clipBehavior: Clip.hardEdge,
                  children: <Widget>[
                    compressFile != null
                        ? Image.file(
                            compressFile,
                            fit: BoxFit.cover,
                            width: widget.width,
                            height: widget.height,
                          )
                        : CachedImageWidget(
                            cacheKey: pickerImageKey,
                            imgUrl: f.url ?? '',
                            width: widget.width,
                            height: widget.height,
                          )
                  ],
                )),
          ),
          Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                icon: SvgPicture.asset(
                  'assets/svg/icon/ic-close-bgred.svg',
                  width: 25.0,
                  height: 25.0,
                ),
                iconSize: 35,
                color: Colors.red[700],
                onPressed: () {
                  setState(() {
                    this.filesPick.remove(f);
                    this.validationFilesPick.remove(f);
                    // Clear main picture
                    if (this.filesPick.length == 0) {
                      this._fileSelected = null;
                    }
                    widget.callbackRemove(f);
                  });
                },
              ))
        ],
      ),
    );
  }

  Widget listImage(BuildContext context) {
    var listImages = [];

    if (this.filesPick.length >= widget.maxImage) {
      listImages = this.filesPick.map((f) => this.photoImage(f)).toList();
    } else {
      listImages = [
            Container(
              padding: const EdgeInsets.only(top: 10, right: 10),
              child: Stack(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      this.pickImage(context);
                    },
                    child: DottedBorder(
                      borderType: BorderType.RRect,
                      dashPattern: [1, 0],
                      color: AppColor.gray_b5b5b5,
                      radius: Radius.circular(8),
                      child: Container(
                        width: widget.width ?? double.infinity,
                        height: widget.height ?? double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SvgPicture.asset(
                              "assets/svg/icon/ic-upload-img.svg",
                              width: 24,
                              height: 21.3,
                            ),
                            SizedBox(height: 6),
                            Text(
                              LocalizationsUtil.of(context)
                                  .translate('upload_image'),
                              textAlign: TextAlign.center,
                              style: AppFonts.semibold13.copyWith(
                                color: Color(
                                  0xff838383,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ] +
          List<Container>.from(this.filesPick.length > 0
              ? this.filesPick.map((f) => this.photoImage(f)).toList()
              : []);
    }

    if (widget.type == PickerImageType.grid) {
      return Container(
        child: GridView.builder(
          itemCount: listImages.length,
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: listImages[index],
            );
          },
        ),
      );
    }

    return SizedBox(
      child: ListView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.only(
              right:
                  10), //Because padding of photo item is 10, default padding-right: 20
          scrollDirection: Axis.horizontal,
          itemCount: listImages.length,
          itemBuilder: (c, index) {
            return listImages[index];
          }),
      height: widget.height,
    );
  }

  List<Future<dynamic>> getUploadParrallel() {
    return this.uploadParrallel;
  }

  @override
  Widget build(BuildContext context) {
    return listImage(context);
  }

  @override
  void dispose() {
    super.dispose();
  }
}
