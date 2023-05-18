import 'dart:async';
import 'dart:io';

import 'package:christian_picker_image/christian_picker_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_svg/svg.dart';
import 'package:houze_super/middle/api/oauth_api.dart';
import 'package:houze_super/middle/local/storage.dart';
import 'package:houze_super/middle/model/image_model.dart';
import 'package:houze_super/presentation/common_widgets/app_dialog.dart';
import 'package:houze_super/presentation/common_widgets/stateless/textfield_widget.dart';
import 'package:houze_super/presentation/common_widgets/widget_dialog_custom.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/utils/constants/constants.dart';
import 'package:houze_super/utils/index.dart';
import 'package:houze_super/utils/permission_handler.dart';
import 'package:houze_super/worker/ticket_worker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:worker_manager/executor.dart';

typedef void Callback(CommentImageModel val);

class WidgetInputBottom extends StatefulWidget {
  final TextFieldWidgetController fcomment;
  final CallBackHandlerVoid callback;
  final Callback imgCallback;
  final String postImageUrl;
  final String hintText;

  WidgetInputBottom({
    @required this.fcomment,
    @required this.callback,
    this.imgCallback,
    this.postImageUrl,
    this.hintText,
  });

  @override
  _WidgetInputBottomState createState() => _WidgetInputBottomState();
}

class _WidgetInputBottomState extends State<WidgetInputBottom> {
  File _imgFile;
  bool isUploading;

  @override
  void initState() {
    super.initState();
    isUploading = false;
  }

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
                if (image != null && image.length > 0) {
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
                      .then((value) {
                    Future.wait([
                      runTaskUpload(value, context, widget.postImageUrl)
                    ]).then((List responses) async {
                      print('Upload image successful');
                      for (var i = 0; i < responses.length; ++i) {
                        print((((i + 1) * 90) / responses.length).toString());
                        await Future.delayed(Duration(milliseconds: 100));
                      }
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

    final task = Task(
        function: uploadCommentImageWorker,
        arg: ArgUpload(
            oauthUrl: postImageUrl,
            url: postImageUrl,
            token: OauthAPI.token,
            file: f,
            storageShared: Storage.prefs,
            isMicro: (building != null && (building.isMicro ?? false))));

    Executor()
        .addTask(
      task: task,
    )
        .listen((result) async {
      if (result != null && result.id != "") {
        print("==========> image id: " + result.id.toString());
        if (widget.imgCallback != null) {
          widget.imgCallback(CommentImageModel(
              image: result.image, imageThumb: result.imageThumb));
        }
      }
      completer.complete(result);
    }).onError((error) {
      completer.completeError(error);
      DialogCustom.showErrorDialog(
        context: context,
        title: 'fail_to_upload_image',
        errMsg: 'there_is_an_issue_please_try_again_later_0',
        callback: () => Navigator.pop(context),
      );
      setState(() {
        this._imgFile = null;
        this.isUploading = false;
      });
    });

    return completer.future;
  }

  Widget _imageView(BuildContext context) {
    return !isUploading
        ? Container(
            margin: EdgeInsets.only(left: 20.0, right: 0.0, top: 10.0),
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
                      File(this._imgFile.path),
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
                        widget.imgCallback(null);
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
                      fontFamily: AppFonts.font_family_display,
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
                  child: RaisedButton(
                    padding: const EdgeInsets.all(8.0),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Color(0xff7a1dff)),
                      borderRadius: BorderRadius.circular(2.0),
                    ),
                    textColor: Color(0xff7a1dff),
                    color: Colors.white,
                    onPressed: () {
                      if (this._imgFile != null &&
                          widget.fcomment.controller.text.trim().length == 0) {
                        if (widget.callback != null) {
                          widget.callback();
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
                          widget.callback();
                          setState(() {
                            this._imgFile = null;
                          });
                        }
                      }
                    },
                    child: Text(LocalizationsUtil.of(context).translate("send"),
                        style: AppFonts.medium12
                            .copyWith(color: Color(0xff7A1DFF))),
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
