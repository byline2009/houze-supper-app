import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:houze_super/presentation/screen/community/conversation/chat/models/index.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:houze_super/middle/api/oauth_api.dart';
import 'package:houze_super/middle/api/profile_api.dart';
import 'package:houze_super/middle/local/storage.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:christian_picker_image/christian_picker_image.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:houze_super/presentation/common_widgets/widget_dialog_custom.dart';
import 'package:houze_super/utils/constants/constants.dart';
import 'package:houze_super/utils/index.dart';
import 'package:houze_super/utils/permission_handler.dart';
import 'package:houze_super/worker/ticket_worker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:worker_manager/worker_manager.dart';
import '../index.dart';

typedef void ChatInputFieldAttachMessageCallback(
  String text,
);
typedef void ChatInputFieldAttacImageCallback(
  ChatImageModel image,
);

class ChatInputField extends StatefulWidget {
  final ChatInputFieldAttachMessageCallback callbackMessage;
  final ChatInputFieldAttacImageCallback callbackImage;
  final CallBackHandlerVoid callback;
  final FocusNode focusNode;

  const ChatInputField({
    Key key,
    @required this.callback,
    @required this.callbackMessage,
    @required this.callbackImage,
    @required this.focusNode,
  }) : super(key: key);

  @override
  _ChatInputFieldState createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  bool _isUploading;
  TextEditingController textEdittingController;
  final _formKey = GlobalKey<FormState>();
  ChatImageModel _imageModel;
  bool get uploadedImage => _imageModel != null;
  ProfileAPI profileAPI;

  @override
  void initState() {
    super.initState();
    profileAPI = ProfileAPI();
    _isUploading = false;
    textEdittingController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    const double _widthAttachImage = 44;
    const double _paddingVertical = 40;
    final double _textfiledWidth =
        ScreenUtil.screenWidth - _paddingVertical - _widthAttachImage;

    return SafeArea(
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            onPressPickImage(context),
            const SizedBox(width: 10),
            Expanded(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Color(0xfff5f5f5),
                  borderRadius: BorderRadius.circular(
                    37,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_isUploading || uploadedImage) ...[
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 20,
                          top: 5,
                          bottom: 10,
                        ),
                        child: ImagePreviewWidget(
                          isUploading: _isUploading,
                          image: _imageModel,
                          callbackRemoveImage: () {
                            setState(() {
                              this._imageModel = null;
                            });
                            widget.callbackImage(null);
                          },
                        ),
                      ),
                      Container(
                        height: 1,
                        color: Color(0xffd0d0d0),
                      ),
                    ],
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xfff5f5f5),
                        borderRadius: BorderRadius.circular(
                          37,
                        ),
                      ),
                      constraints: BoxConstraints(
                        maxHeight: 100.0,
                        maxWidth: _textfiledWidth,
                        minHeight: 50.0,
                        minWidth: _textfiledWidth,
                      ),
                      child: Stack(
                        children: [
                          Form(
                            key: _formKey,
                            child: Container(
                              padding: const EdgeInsets.only(
                                left: 0,
                                right: 13,
                                top: 15.0,
                                bottom: 15,
                              ),
                              margin: EdgeInsets.only(
                                right: 40,
                                top: 0,
                                left: 20,
                                bottom: 0,
                              ),
                              child: TextField(
                                focusNode: widget.focusNode,
                                scrollPadding: const EdgeInsets.all(0),
                                controller: textEdittingController,
                                style: AppFonts.regular15,
                                textAlign: TextAlign.start,
                                cursorColor: Colors.black,
                                maxLines: null,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                textInputAction: TextInputAction.newline,
                                keyboardType: TextInputType.multiline,
                                onEditingComplete:
                                    () {}, // this prevents keyboard from closing
                                decoration: InputDecoration.collapsed(
                                  hintText: LocalizationsUtil.of(context)
                                      .translate('k_enter_message'),
                                  border: InputBorder.none,
                                ),
                                onChanged: (value) {
                                  widget.callbackMessage(
                                    value.trim(),
                                  );
                                },
                                onTap: () {
                                  widget.focusNode.requestFocus();
                                },
                              ),
                            ),
                          ),
                          Positioned(
                            child: Container(
                              alignment: Alignment.bottomCenter,
                              child: textEdittingController.text.length > 0 ||
                                      uploadedImage
                                  ? sendButton(true)
                                  : sendButton(false),
                            ),
                            right: 13,
                            bottom: 0,
                            top: 0,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> runTaskUpload(
    File f,
    BuildContext context,
  ) async {
    final completer = Completer();
    final building = Sqflite.currentBuilding;

    final task = Task(
      function: uploadChatImageWorker,
      arg: ArgUpload(
        oauthUrl: ChatPath.postChatImage,
        url: ChatPath.postChatImage,
        token: OauthAPI.token,
        file: f,
        storageShared: Storage.prefs,
        isMicro: (building != null && (building.isMicro ?? false)),
      ),
    );

    Executor()
        .addTask(
      task: task,
    )
        .listen((ChatImageModel result) async {
      if (result != null &&
          !StringUtil.isEmpty(
            result.imageThumb,
          )) {
        setState(() {
          this._imageModel = result;
        });
        widget.callbackImage(result);
      }
      completer.complete(result);
    }).onError((error) {
      setState(() {
        _isUploading = false;
      });
      completer.completeError(error);

      DialogCustom.showErrorDialog(
        context: context,
        title: 'fail_to_upload_image',
        errMsg: 'there_is_an_issue_please_try_again_later_0',
        callback: () => Navigator.pop(context),
      );
    });

    return completer.future;
  }

  Widget sendButton(bool isActive) {
    return GestureDetector(
      onTap: () {
        if (isActive) {
          widget.callback();
          _imageModel = null;
          textEdittingController.clear();
          textEdittingController.text = '';
        }
      },
      child: SizedBox(
        width: 40,
        height: 50,
        child: Icon(
          Icons.send,
          color: isActive ? Color(0xff7A1DFF) : Color(0xff9c9c9c),
        ),
      ),
    );
  }

  onPressPickImage(BuildContext context) {
    return GestureDetector(
      onTap: () {
        PermissionHandler.checkAndRequestStoragePermission(
            context: context,
            func: () async {
              if (uploadedImage) {
                return;
              }
              try {
                if (widget.focusNode.hasFocus) {
                  widget.focusNode.unfocus();
                }

                final _imagesPicked = await ChristianPickerImage.pickImages(
                  maxImages: 1,
                );

                await Future.delayed(
                  Duration.zero,
                );
                if (_imagesPicked != null && _imagesPicked.length > 0) {
                  setState(() {
                    _isUploading = true;
                  });
                  final Directory _directory = await getTemporaryDirectory();
                  final String _targetPath = _directory.absolute.path +
                      "/" +
                      basename(
                        _imagesPicked.first.path,
                      );

                  await FlutterImageCompress.compressAndGetFile(
                    _imagesPicked.first.absolute.path,
                    _targetPath,
                    minHeight: 960,
                    minWidth: 960,
                    quality: 60,
                    keepExif: false,
                  ).then((File value) async {
                    try {
                      await profileAPI.getProfile(); //refresh token

                      Future.delayed(
                        Duration.zero,
                      );

                      await Future.wait(
                        [
                          runTaskUpload(
                            value,
                            Storage.scaffoldKey.currentContext,
                          ),
                        ],
                      ).then((List responses) async {
                        print('Upload image on chat successful');
                        for (var i = 0; i < responses.length; ++i) {
                          print(((i + 1) * 90) / responses.length);
                          await Future.delayed(Duration(milliseconds: 100));
                        }
                        value.deleteSync();
                        setState(() {
                          _isUploading = false;
                        });
                      });
                    } catch (e) {
                      setState(() {
                        _isUploading = false;
                      });
                    }
                  });
                }
              } catch (e) {
                setState(() {
                  _isUploading = false;
                });
                print(e.toString());
                DialogCustom.showErrorDialog(
                  context: Storage.scaffoldKey.currentContext,
                  title: 'fail_to_upload_image',
                  errMsg: 'there_is_an_issue_please_try_again_later_0',
                  callback: () => Navigator.pop(context),
                );
              }
            });
      },
      child: SizedBox(
        height: 44,
        width: 44,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: uploadedImage ? Colors.transparent : Color(0xfff2e8ff),
            ),
            child: Center(
              child: uploadedImage
                  ? SvgPicture.asset(
                      AppVectors.icDisableAttachImage,
                      color: Colors.black26,
                    )
                  : SvgPicture.asset(
                      AppVectors.icAttachImageIssue,
                    ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    if (textEdittingController != null) textEdittingController.dispose();
    super.dispose();
  }
}
