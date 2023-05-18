import 'dart:async';
import 'dart:io';
// ignore: import_of_legacy_library_into_null_safe
import 'package:christian_picker_image/christian_picker_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:houze_super/middle/api/index.dart';
import 'package:houze_super/middle/local/storage.dart';
import 'package:houze_super/middle/ws/chat_controller.dart';
import 'package:houze_super/presentation/common_widgets/widget_dialog_custom.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:houze_super/utils/firebase_analytic/firebase_analytics.dart';
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
  ChatImageModel? image,
);

class ChatInputField extends StatefulWidget {
  // final ChatInputFieldAttachMessageCallback callbackMessage;
  // final ChatInputFieldAttacImageCallback callbackImage;
  // final CallBackHandlerVoid callback;
  final FocusNode focusNode;
  final String roomIDLocal;
  const ChatInputField({
    Key? key,
    required this.roomIDLocal,
    // required this.callbackMessage,
    // required this.callbackImage,
    required this.focusNode,
  }) : super(key: key);

  @override
  _ChatInputFieldState createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  bool _isUploading = false;
  TextEditingController textEdittingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late ChatImageModel? _imageModel = ChatImageModel();
  late String _message;
  // late File? _imgFile;
  // bool get uploadedImage => _imageModel?.id != null && !_isUploading;

  @override
  void initState() {
    super.initState();
    _message = textEdittingController.text;
  }

  @override
  Widget build(BuildContext context) {
    const double _widthAttachImage = 44;
    const double _paddingVertical = 40;
    final double _textfiledWidth =
        ScreenUtil.defaultSize.width - _paddingVertical - _widthAttachImage;

    return SafeArea(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const SizedBox(
            width: 20,
          ),
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
                  if (_isUploading || _imageModel?.id != null) ...[
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
                          if (!mounted) return;
                          setState(() {
                            this._imageModel = null;
                          });
                          // widget.callbackImage(null);
                        },
                      ),
                    ),
                    SizedBox(
                      height: 1,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Color(0xffd0d0d0),
                        ),
                      ),
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
                              textCapitalization: TextCapitalization.sentences,
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
                                setState(() {
                                  _message = value;
                                });
                              },
                              onTap: () {
                                widget.focusNode.requestFocus();
                              },
                            ),
                          ),
                        ),
                        Positioned(
                          child: Align(
                              alignment: Alignment.bottomCenter,
                              child: sendButton()),
                          right: 0,
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
          const SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }

  Future<dynamic> runTaskUpload(
    File f,
    BuildContext context,
  ) async {
    final completer = Completer();
    final building = Sqflite.currentBuilding;
    try {
      final result = await Executor().execute(
          arg1: ArgUpload(
              oauthUrl: ChatPath.postChatImage,
              url: ChatPath.postChatImage,
              token: OauthAPI.token,
              file: f,
              storageShared: Storage.prefs,
              isMicro: ((building?.isMicro ?? false))),
          fun1: uploadChatImageWorker);
      print("==========> image id: " + result.id.toString());
      setState(() {
        _isUploading = false;
        _imageModel = result;
      });
    } catch (err) {
      print(err);
      if (_isUploading) {
        setState(() {
          this._isUploading = false;
        });
      }
      completer.completeError(err);

      DialogCustom.showErrorDialog(
          context: context,
          title: 'fail_to_upload_image',
          errMsg: 'there_is_an_issue_please_try_again_later_0',
          buttonText: 'ok',
          callback: () {
            Navigator.pop(context);
          });
    } finally {
      setState(() {
        this._isUploading = false;
      });
    }

    return completer.future;
  }

  Widget sendButton() {
    final bool validation =
        _message.trim().length > 0 || _imageModel?.id != null;
    return GestureDetector(
      onTap: () {
        if (validation) {
          sendMessageTextType(textEdittingController.text.trim());
          clearData();
        }
      },
      child: SizedBox(
        width: 50,
        height: 50,
        child: Icon(
          Icons.send,
          color: validation ? Color(0xff7A1DFF) : Color(0xff9c9c9c),
        ),
      ),
    );
  }

  void sendMessageTextType(
    String message,
  ) {
    if (widget.roomIDLocal.isEmpty) return;
    String? msgType;
    if (message.trim().length > 0) {
      if (_imageModel != null && _imageModel?.id != null) {
        ChatController().sendImageTextChat(
          image: _imageModel!.image!,
          text: message,
          roomID: widget.roomIDLocal,
        );
        msgType = RunConstant.kChatTypeImage;
      } else {
        ChatController().sendSingleChatMessage(
          message: message,
          roomID: widget.roomIDLocal,
        );
        msgType = RunConstant.kChatTypeText;
      }
    } else if (_imageModel?.id != null) {
      ChatController().sendImageChat(
        roomID: widget.roomIDLocal,
        imageUrl: _imageModel!.image!,
      );
      msgType = RunConstant.kChatTypeImage;
    }

    //Firebase Analytics
    GetIt.instance<FBAnalytics>().sendEventSendMessage(
        userID: Storage.getUserID() ?? "", messageType: msgType ?? "");
  }

  void clearData() {
    print('clearData');
    textEdittingController.clear();
    _message = '';
    setState(() {
      this._imageModel = null;
    });
  }

  Widget onPressPickImage(BuildContext context) {
    return GestureDetector(
      onTap: () {
        PermissionHandler.checkAndRequestStoragePermission(
            context: context,
            func: () async {
              //unfocus textfield when picking image
              if (this._isUploading) return;
              FocusScope.of(context).unfocus();
              new TextEditingController().clear();
              //pick and upload image
              try {
                final image =
                    await ChristianPickerImage.pickImages(maxImages: 1);
                await Future.delayed(Duration(microseconds: 600));
                if (image.length > 0) {
                  setState(() {
                    // this._imgFile = image.first;
                    this._isUploading = true;
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
                    await ProfileAPI().getProfile(); //refresh token

                    Future.wait([
                      runTaskUpload(
                        value!,
                        context,
                      )
                    ]).whenComplete(() {
                      value.deleteSync();
                    });
                  });
                }
              } catch (e) {
                print(e.toString());
                this.setState(() {
                  _isUploading = false;
                });
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
              color: _isUploading ? Colors.transparent : Color(0xfff2e8ff),
            ),
            child: Center(
              child: _isUploading
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
    textEdittingController.dispose();
    super.dispose();
  }
}
