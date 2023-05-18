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
import 'package:houze_super/utils/permission_handler.dart';
import 'package:houze_super/worker/ticket_worker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:worker_manager/worker_manager.dart';

typedef void Callback(ImageModel? val);

class WidgetInputCommentBottom extends StatefulWidget {
  final fcomment;
  final CallBackHandlerVoid callback;
  final Callback? commentImageCallback;
  final String postImageUrl;
  final String hintText;
  final bool didTap;
  WidgetInputCommentBottom({
    required this.fcomment,
    required this.callback,
    this.commentImageCallback,
    required this.postImageUrl,
    required this.hintText,
    required this.didTap,
  });

  @override
  _WidgetInputCommentBottomState createState() =>
      _WidgetInputCommentBottomState();
}

class _WidgetInputCommentBottomState extends State<WidgetInputCommentBottom> {
  File? _imgFile;
  bool isUploading = false;
  final profileAPI = ProfileAPI();
  @override
  Widget build(BuildContext context) {
    return _buildInputBottom(context);
  }

  Widget _pickImage(BuildContext context) {
    return GestureDetector(
      onTap: () {
        PermissionHandler.checkAndRequestStoragePermission(
            context: context,
            func: () async {
              //unfocus textfield when picking image
              if (this._imgFile != null) return;
              FocusScope.of(context).unfocus();
              new TextEditingController().clear();
              //pick and upload image
              try {
                final image =
                    await ChristianPickerImage.pickImages(maxImages: 1);
                await Future.delayed(Duration(microseconds: 600));
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
                          minHeight: 960,
                          minWidth: 960,
                          quality: 60,
                          keepExif: false)
                      .then((value) async {
                    await profileAPI.getProfile(); //refresh token

                    Future.wait([
                      runTaskUpload(value!, context, widget.postImageUrl)
                    ]).whenComplete(() {
                      value.deleteSync();
                    });
                  });
                }
              } catch (e) {
                print(e.toString());
                this.setState(() {
                  isUploading = false;
                });
              }
            });
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
  Future<dynamic> runTaskUpload(
      File f, BuildContext context, String postImageUrl) async {
    var completer = Completer();
    final building = Sqflite.currentBuilding;
    try {
      final result = await Executor().execute(
          arg1: ArgUpload(
              oauthUrl: postImageUrl,
              url: postImageUrl,
              token: OauthAPI.token,
              file: f,
              storageShared: Storage.prefs,
              isMicro: ((building?.isMicro ?? false))),
          fun1: uploadSocialCommentImageWorker);

      if (result != null && result.id != "") {
        print("==========> image id: " + result.id.toString());
        if (widget.commentImageCallback != null) {
          widget.commentImageCallback!(ImageModel(id: result.id));
        }
      }
    } catch (err) {
      print(err);
      setState(() {
        this._imgFile = null;
        this.isUploading = false;
      });
      completer.completeError(err);

      DialogCustom.showErrorDialog(
          context: context,
          title: 'fail_to_upload_image',
          errMsg: 'there_is_an_issue_please_try_again_later_0',
          callback: () {
            Navigator.pop(context);
          });
    } finally {
      setState(() {
        this.isUploading = false;
      });
    }

    return completer.future;
  }

  Widget _imageView(BuildContext context) {
    return !isUploading
        ? Container(
            margin: const EdgeInsets.only(left: 20.0, right: 0.0, top: 10.0),
            child: Stack(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(
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
                        widget.commentImageCallback!(null);
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
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xff5b00e4)),
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
        this._imgFile != null ? _imageView(context) : const SizedBox.shrink(),
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
                  //style: AppFonts.regular14.copyWith(letterSpacing: 0.3),
                  style: AppFonts.regular14.copyWith(letterSpacing: 0.3),
                  textCapitalization: TextCapitalization.sentences,
                  cursorColor: Colors.black,
                  controller: widget.fcomment.controller,
                  keyboardType: TextInputType.multiline,
                  maxLines: 1,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: LocalizationsUtil.of(context)
                        .translate(widget.hintText),
                    hintStyle: TextStyle(
                      color: Color(0xff808080),
                      // fontFamily: AppFonts.font_family_display,
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
                  child: TextButton(
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsets>(
                          EdgeInsets.all(8.0)),
                      overlayColor: MaterialStateColor.resolveWith(
                          (states) => Colors.transparent),
                      backgroundColor: MaterialStateProperty.resolveWith(
                          (states) => Colors.white),
                      textStyle: MaterialStateProperty.resolveWith(
                        (states) => TextStyle(color: Color(0xff7a1dff)),
                      ),
                      shape: MaterialStateProperty.resolveWith(
                        (states) => RoundedRectangleBorder(
                          side: BorderSide(color: Color(0xff7a1dff)),
                          borderRadius: BorderRadius.circular(2.0),
                        ),
                      ),
                    ),
                    onPressed: !widget.didTap
                        ? () {
                            if (this._imgFile != null &&
                                widget.fcomment.controller.text.trim().length ==
                                    0) {
                              widget.callback();
                              setState(() {
                                this._imgFile = null;
                              });
                            } else if (this._imgFile != null &&
                                widget.fcomment.controller.text.trim().length <
                                    5) {
                              return AppDialog.showAlertDialog(
                                  context,
                                  null,
                                  LocalizationsUtil.of(context).translate(
                                          "please_write_your_message_longer") +
                                      " 5 " +
                                      LocalizationsUtil.of(context).translate(
                                          "characters_with_lower_case"));
                            } else if (this._imgFile == null &&
                                widget.fcomment.controller.text.trim().length <
                                    5) {
                              return AppDialog.showAlertDialog(
                                  context,
                                  null,
                                  LocalizationsUtil.of(context).translate(
                                          "please_write_your_message_longer") +
                                      " 5 " +
                                      LocalizationsUtil.of(context).translate(
                                          "characters_with_lower_case"));
                            } else {
                              widget.callback();
                              widget.fcomment.controller.clear();
                              setState(() {
                                this._imgFile = null;
                              });
                            }
                          }
                        : () {},
                    child: Text(
                      LocalizationsUtil.of(context).translate("send"),
                      // style:
                      //     AppFonts.medium12.copyWith(color: Color(0xff7A1DFF)),
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
