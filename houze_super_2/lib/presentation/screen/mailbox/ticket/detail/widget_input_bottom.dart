import 'dart:async';
import 'dart:io';
// ignore: import_of_legacy_library_into_null_safe
import 'package:christian_picker_image/christian_picker_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_svg/svg.dart';
import 'package:houze_super/middle/api/oauth_api.dart';
import 'package:houze_super/middle/api/profile_api.dart';
import 'package:houze_super/middle/local/storage.dart';
import 'package:houze_super/middle/model/image_model.dart';
import 'package:houze_super/presentation/common_widgets/app_dialog.dart';
import 'package:houze_super/presentation/common_widgets/widget_dialog_custom.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/worker/ticket_worker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:worker_manager/worker_manager.dart';

typedef void Callback(CommentImageModel? val);

class WidgetInputBottom extends StatefulWidget {
  final fcomment;
  final CallBackHandlerVoid? callback;
  final Callback? imgCallback;

  WidgetInputBottom({required this.fcomment, this.callback, this.imgCallback});

  @override
  _WidgetInputBottomState createState() => _WidgetInputBottomState();
}

class _WidgetInputBottomState extends State<WidgetInputBottom> {
  File? _imgFile;
  bool isUploading = false;
  final profileAPI = ProfileAPI();
  @override
  Widget build(BuildContext context) {
    return _buildInputBottom(context);
  }

  Widget _pickImage(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        //unfocus textfield when picking image
        if (this._imgFile != null) return;
        FocusScope.of(context).unfocus();
        new TextEditingController().clear();
        //pick and upload image
        try {
          final image = await ChristianPickerImage.pickImages(maxImages: 1);
          await Future.delayed(Duration(microseconds: 500));
          if (image.length > 0) {
            setState(() {
              this._imgFile = image.first;
              this.isUploading = true;
            });
            var dir = await getTemporaryDirectory();
            var targetPath =
                dir.absolute.path + "/" + basename(image.first.path);

            await FlutterImageCompress.compressAndGetFile(
                    image.first.absolute.path, targetPath,
                    minHeight: 960, minWidth: 960, quality: 60, keepExif: false)
                .then((value) async {
              await profileAPI.getProfile(); //refresh token
              Future.wait([runTaskUpload(value!, context)])
                  .then((List responses) async {
                print('Upload image successful');
                value.deleteSync();

                this.setState(() {
                  isUploading = false;
                });
              });
            });
          }
        } catch (e) {
          print(e.toString());
          this.setState(() {
            isUploading = false;
          });
        }
      },
      child: this._imgFile == null
          ? Padding(
              padding: const EdgeInsets.only(left: 12.0, bottom: 12.0),
              child: SvgPicture.asset(AppVectors.icAttachImageIssue),
            )
          : Padding(
              padding: const EdgeInsets.only(bottom: 12.0, left: 12.0),
              child: SvgPicture.asset(
                AppVectors.icDisableAttachImage,
                color: Colors.black26,
              ),
            ),
    );
  }

  //Task processing
  Future<dynamic> runTaskUpload(File f, BuildContext context) async {
    var completer = Completer();
    final building = Sqflite.currentBuilding;

    try {
      final result = await Executor().execute(
          arg1: ArgUpload(
              oauthUrl: APIConstant.postCommentImage,
              url: APIConstant.postCommentImage,
              token: OauthAPI.token,
              file: f,
              storageShared: Storage.prefs,
              isMicro: (building != null && (building.isMicro ?? false))),
          fun1: uploadCommentImageWorker);

      if (result != null && result.id != "") {
        print("==========> image id: " + result.id.toString());
        if (widget.imgCallback != null)
          widget.imgCallback!(CommentImageModel(
              image: result.image, imageThumb: result.imageThumb));
      }
      completer.complete(result);
    } catch (error) {
      completer.completeError(error);
      DialogCustom.showErrorDialog(
        context: context,
        title: 'fail_to_upload_image',
        errMsg: 'there_is_an_issue_please_try_again_later_0',
      );
      setState(() {
        this._imgFile = null;
        this.isUploading = false;
      });
    }

    return completer.future;
  }

  Widget _imageView(BuildContext context) {
    return !isUploading
        ? Container(
            margin: EdgeInsets.only(left: 20.0, right: 0.0, top: 10.0),
            child: Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(
                    top: 5.0,
                  ),
                  margin: EdgeInsets.only(right: 5.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5.0),
                    child: Image.file(
                      File(this._imgFile!.path),
                      width: MediaQuery.of(context).size.width * 0.14,
                      height: MediaQuery.of(context).size.height * 0.1,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  right: 2.0,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        this._imgFile = null;
                        widget.imgCallback!(null);
                      });
                    },
                    child: Align(
                      alignment: Alignment.topRight,
                      child: CircleAvatar(
                        radius: 13.0,
                        backgroundColor: Colors.black,
                        child: Icon(Icons.close, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        : Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width * 0.14,
            height: MediaQuery.of(context).size.height * 0.1,
            child: SizedBox(
              child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(AppColor.purple_5b00e4),
              ),
              height: 20.0,
              width: 20.0,
            ),
          );
  }

  Widget _buildInputBottom(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        this._imgFile != null ? _imageView(context) : SizedBox.shrink(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              _pickImage(context),
              SizedBox(
                width: 15.0,
              ),
              Expanded(
                child: TextField(
                  style: AppFonts.regular14.copyWith(letterSpacing: 0.3),
                  textCapitalization: TextCapitalization.sentences,
                  cursorColor: Colors.black,
                  controller: widget.fcomment.controller,
                  keyboardType: TextInputType.multiline,
                  maxLines: 1,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: LocalizationsUtil.of(context)
                        .translate("write_your_reply"),
                    hintStyle: TextStyle(
                      color: Color(0xff808080),
                      fontFamily: AppFont.font_family_display,
                      fontSize: 14,
                    ), //Text color
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 12.0),
                child: ButtonTheme(
                  minWidth: 60.0,
                  height: 30.0,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white, // background
                      onPrimary: Color(0xff7a1dff), // foreground
                      padding: const EdgeInsets.all(8.0),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Color(0xff7a1dff)),
                        borderRadius: BorderRadius.circular(2.0),
                      ),
                    ),
                    onPressed: () {
                      if (this._imgFile != null &&
                          widget.fcomment.controller.text.trim().length == 0) {
                        if (widget.callback != null) {
                          widget.callback!();
                          setState(() {
                            this._imgFile = null;
                          });
                        }
                      } else if (this._imgFile != null &&
                          widget.fcomment.controller.text.trim().length < 5) {
                        return AppDialog.showAlertDialog(
                            context,
                            null,
                            LocalizationsUtil.of(context).translate(
                                    "please_write_your_message_longer") +
                                " 5 " +
                                LocalizationsUtil.of(context)
                                    .translate("characters_with_lower_case"));
                      } else if (this._imgFile == null &&
                          widget.fcomment.controller.text.trim().length < 5) {
                        return AppDialog.showAlertDialog(
                            context,
                            null,
                            LocalizationsUtil.of(context).translate(
                                    "please_write_your_message_longer") +
                                " 5 " +
                                LocalizationsUtil.of(context)
                                    .translate("characters_with_lower_case"));
                      } else {
                        if (widget.callback != null) {
                          widget.callback!();
                          setState(() {
                            this._imgFile = null;
                          });
                        }
                      }
                    },
                    child: Text(
                      LocalizationsUtil.of(context).translate("send"),
                      style: AppFont.MEDIUM_PURPLE_7a1dff_12,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
