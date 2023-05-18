import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:houze_super/middle/api/index.dart';
import 'package:houze_super/middle/local/storage.dart';
import 'package:houze_super/middle/model/ticket_model.dart';
import 'package:houze_super/presentation/base/route_aware_state.dart';
import 'package:houze_super/presentation/common_widgets/app_dialog.dart';
import 'package:houze_super/presentation/common_widgets/button_widget.dart';
import 'package:houze_super/presentation/common_widgets/picker_image.dart';
import 'package:houze_super/presentation/common_widgets/widget_button.dart';
import 'package:houze_super/presentation/common_widgets/widget_dialog_custom.dart';
import 'package:houze_super/presentation/common_widgets/widget_text.dart';
import 'package:houze_super/presentation/common_widgets/widget_text_controller.dart';
import 'package:houze_super/presentation/screen/base/base_widget.dart';
import 'package:houze_super/presentation/screen/community/conversation/forum/discussion/models/index.dart';
import 'package:houze_super/middle/api/discussion_api.dart';
import 'package:houze_super/presentation/screen/ticket/widget_images_box.dart';
import 'package:houze_super/presentation/screen/ticket/widget_standard_box.dart';
import 'package:houze_super/utils/constant/index.dart';
import 'package:houze_super/utils/firebase_analytic/firebase_analytics.dart';
import 'package:houze_super/utils/localizations_util.dart';
import 'package:houze_super/utils/progresshub.dart';
import 'package:houze_super/utils/sqflite.dart';
import 'package:houze_super/worker/ticket_worker.dart';
import 'package:worker_manager/worker_manager.dart';

class PostThreadScreenArgument extends Equatable {
  const PostThreadScreenArgument({
    required this.isDetailPage,
  });
  final bool isDetailPage;

  @override
  List<Object> get props => [];
}

class RadioSubmitEvent {
  int? value;

  RadioSubmitEvent(int value) {
    this.value = value;
  }
}

class PostThreadScreen extends StatefulWidget {
  final PostThreadScreenArgument argument;
  const PostThreadScreen({Key? key, required this.argument}) : super(key: key);

  @override
  _PostThreadScreenState createState() => _PostThreadScreenState();
}

class _PostThreadScreenState extends RouteAwareState<PostThreadScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late WidgetImagesBox fImagePicker;
  final fImagePickerStatus = StreamController<String>.broadcast();
  final fDescription = TextEditingController();

  //Action Event List data
  var filesCompressedPick = <File>[];
  var filesCompressedPickMapWithBaseFile = <File, File>{};

  final ProgressHUD progressToolkit = Progress.instanceCreateWithNormal();
  StreamController<ButtonSubmitEvent> _sendButtonController =
      StreamController<ButtonSubmitEvent>.broadcast();

  final StreamController<RadioSubmitEvent> _radioController =
      StreamController<RadioSubmitEvent>.broadcast();

  bool isActive = false;
  var profileAPI = ProfileAPI();
  var discssionAPI = DiscussionApi();

  DiscussionUpdateModel ticketModel = DiscussionUpdateModel();

  final category = [
    "general_discussion",
    "need_to_buy",
    "for_sale",
  ];
  int chipIndex = 0;
  int displayType = 0;

  @override
  void initState() {
    fImagePicker = WidgetImagesBox(
      callbackUploadResult: (FilePick f, FilePick fCompress) {
        this.filesCompressedPick.add(f.file);
        //print(identityHashCode(f.file));
        filesCompressedPickMapWithBaseFile[f.file] = fCompress.file;
        fImagePickerStatus.add(
            LocalizationsUtil.of(context).translate("photos_attachment") +
                "(${this.filesCompressedPick.length}/5)");
      },
      callbackRemoveResult: (FilePick f) {
        //print(identityHashCode(f.file));
        this.filesCompressedPick.remove(f.file);
        fImagePickerStatus.add(
            LocalizationsUtil.of(context).translate("photos_attachment") +
                "(${this.filesCompressedPick.length}/5)");
      },
      maxImage: 5,
    );
    _sendButtonController.sink.add(ButtonSubmitEvent(true));
    ticketModel.buildingId = Sqflite.currentBuildingID;
    ticketModel.category = 0;
    ticketModel.displayType = 0;
    super.initState();
  }

  @override
  void dispose() {
    fImagePickerStatus.close();
    fDescription.dispose();
    _sendButtonController.close();
    _radioController.close();
    super.dispose();
  }

  bool checkValidation() {
    if ((ticketModel.buildingId ?? "").isNotEmpty &&
        ticketModel.category != null &&
        (ticketModel.description ?? "").isNotEmpty) {
      this.isActive = true;
    } else {
      this.isActive = false;
    }

    _sendButtonController.sink.add(ButtonSubmitEvent(this.isActive));
    return this.isActive;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          LocalizationsUtil.of(context).translate("post_new_thread"),
          style: AppFont.SEMIBOLD_BLACK_18,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () {
          bool isKeyboardShowing = MediaQuery.of(context).viewInsets.bottom > 0;
          if (isKeyboardShowing) {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          }
        },
        child: SafeArea(
          child: Stack(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: ListView(
                  padding: const EdgeInsets.only(bottom: 68),
                  shrinkWrap: true,
                  children: [
                    _categoryView(),
                    _typeView(),
                    _imageView(),
                    _descriptionView(),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: _sendButtonView(),
              ),
              progressToolkit,
            ],
          ),
        ),
      ),
    );
  }

  // Widget _appBar() {
  //   return AppBar(
  //     title: Text(
  //       LocalizationsUtil.of(context).translate("post_new_thread"),
  //       style: AppFonts.semibold18,
  //     ),
  //     centerTitle: true,
  //     leading: IconButton(
  //       icon: Icon(Icons.arrow_back),
  //       onPressed: () {
  //         Navigator.pop(context);
  //       },
  //     ),
  //   );
  // }

  void onTap(index) {
    _radioController.sink.add(RadioSubmitEvent(index));
    setState(() {
      displayType = index;
    });
    ticketModel.displayType = index;
    this.checkValidation();
  }

  Widget _categoryView() {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
            child: WidgetStandardBox(
              title: TextWidget(
                LocalizationsUtil.of(context).translate("display_type_thread"),
                // style: AppFonts.medium16.copyWith(letterSpacing: 0.26),
                style: AppFonts.medium16.copyWith(letterSpacing: 0.26),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color:
                      displayType == 0 ? Color(0xff6001d2) : Color(0xfff5f5f5),
                  width: 2,
                  style: BorderStyle.solid,
                ),
              ),
              padding: const EdgeInsets.symmetric(vertical: 0),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                title: Row(
                  children: [
                    SizedBox(
                      width: 22,
                      child: StreamBuilder(
                          stream: _radioController.stream,
                          initialData: RadioSubmitEvent(0),
                          builder: (BuildContext context,
                              AsyncSnapshot<RadioSubmitEvent> snapshot) {
                            return Radio(
                              value: 0,
                              activeColor: Color(0xff6001d2),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              //groupValue: item.key,
                              groupValue: int.parse(
                                  snapshot.data?.value.toString() ?? ""),
                              hoverColor: Color(0xff6001d2),
                              focusColor: Color(0xff6001d2),
                              onChanged: (dynamic value) {
                                onTap(0);
                              },
                            );
                          }),
                    ),
                    const SizedBox(width: 15),
                    BaseWidget.avatar(
                        imageUrl: Storage.getAvatar(), size: 40.0),
                    const SizedBox(width: 18),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            Storage.getPhoneNumber()
                                    .toString()
                                    .substring(0, 6) +
                                "****",
                            // style: AppFonts.medium14
                            //     .copyWith(color: Colors.black)
                            //     .copyWith(
                            //         fontFamily: AppFonts.font_family_display),
                            style: AppFonts.medium14.copyWith(
                                fontFamily: AppFont.font_family_display),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  onTap(0);
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color:
                      displayType == 1 ? Color(0xff6001d2) : Color(0xfff5f5f5),
                  width: 2,
                  style: BorderStyle.solid,
                ),
              ),
              padding: const EdgeInsets.symmetric(vertical: 0),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                title: Row(
                  children: [
                    SizedBox(
                      width: 22,
                      child: StreamBuilder(
                          stream: _radioController.stream,
                          initialData: RadioSubmitEvent(0),
                          builder: (BuildContext context,
                              AsyncSnapshot<RadioSubmitEvent> snapshot) {
                            return Radio(
                              value: 1,
                              activeColor: Color(0xff6001d2),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              //groupValue: item.key,
                              groupValue: int.parse(
                                  snapshot.data?.value.toString() ?? ""),
                              hoverColor: Color(0xff6001d2),
                              focusColor: Color(0xff6001d2),
                              onChanged: (dynamic value) {
                                onTap(1);
                              },
                            );
                          }),
                    ),
                    const SizedBox(width: 15),
                    BaseWidget.avatar(
                        imageUrl: Storage.getAvatar(), size: 40.0),
                    const SizedBox(width: 18),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            Storage.getUserName() ?? '',
                            // style: AppFonts.medium14
                            //     .copyWith(color: Colors.black)
                            //     .copyWith(
                            //         fontFamily: AppFonts.font_family_display),
                            style: AppFonts.medium14.copyWith(
                                fontFamily: AppFont.font_family_display),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  onTap(1);
                },
              ),
            ),
          ),
          const SizedBox(height: 19),
        ],
      ),
    );
  }

  Widget _typeView() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 15),
            child: WidgetStandardBox(
              title: TextWidget(
                LocalizationsUtil.of(context).translate("category_thread"),
                //style: AppFonts.medium16.copyWith(letterSpacing: 0.26),
                style: AppFonts.medium16.copyWith(letterSpacing: 0.26),
              ),
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              vertical: 16.0,
              horizontal: 20.0,
            ),
            scrollDirection: Axis.horizontal,
            child: Wrap(
              spacing: 16.0,
              children: category
                  .map(
                    (e) => ChoiceChip(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(
                          width: 1.5,
                          color: chipIndex == category.indexOf(e)
                              ? Color(0xff6001d1)
                              : Color(0xff9c9c9c),
                        ),
                      ),
                      labelPadding: const EdgeInsets.symmetric(
                        horizontal: 5.0,
                        vertical: 0.0,
                      ),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      label: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(LocalizationsUtil.of(context).translate(e)),
                        ],
                      ),
                      selected: chipIndex == category.indexOf(e),
                      onSelected: (bool value) {
                        final int index = category.indexOf(e);

                        setState(() => chipIndex = index);
                        ticketModel.category = index;

                        checkValidation();
                      },
                      labelStyle: chipIndex == category.indexOf(e)
                          ? AppFonts.medium14.copyWith(color: Color(0xff7A1DFF))
                          : AppFonts.medium14
                              .copyWith(color: Color(0xff9c9c9c)),
                      selectedColor: Colors.white,
                      backgroundColor: Colors.white,
                    ),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(height: 19),
        ],
      ),
    );
  }

  Widget _imageView() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: WidgetStandardBox(
              title: TextDynamicWidget(
                defaultText: LocalizationsUtil.of(context)
                        .translate("photos_attachment") +
                    "(0/5)",
                // style: AppFonts.medium16.copyWith(letterSpacing: 0.26),
                style: AppFonts.medium16.copyWith(letterSpacing: 0.26),
                controller: fImagePickerStatus,
              ),
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(left: 20, top: 5),
              child: fImagePicker),
          const SizedBox(height: 29),
        ],
      ),
    );
  }

  Widget _descriptionView() {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 15),
            child: WidgetStandardBox(
              title: TextWidget(
                LocalizationsUtil.of(context).translate("discussion_content"),
                // style: AppFonts.medium16.copyWith(letterSpacing: 0.26),
                style: AppFonts.medium16.copyWith(letterSpacing: 0.26),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: TextField(
              controller: fDescription,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: LocalizationsUtil.of(context)
                    .translate("input_description_here"),
                hintStyle: AppFont.MEDIUM_GRAY_9C9C9C_11
                    .copyWith(fontSize: 18.0), //MEDIUM_GRAY_9C9C9C_18,
                labelStyle: AppFonts.medium18.copyWith(letterSpacing: 0.29),
              ),
              keyboardType: TextInputType.multiline,
              maxLines: 5,
              onChanged: (String value) {
                ticketModel.description = value;
                this.checkValidation();
              },
            ),
          ),
          const SizedBox(height: 29),
        ],
      ),
    );
  }

  Widget _sendButtonView() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: ButtonWidget(
        defaultHintText: LocalizationsUtil.of(context).translate('post_thread'),
        controller: _sendButtonController,
        callback: () {
          sendTicket(context);
        },
      ),
    );
  }

  //Task processing
  Future<dynamic> runTaskUpload(File? f) async {
    var completer = Completer();
    final building = await Sqflite.getCurrentBuilding();
    try {
      final result = await Executor().execute(
          arg1: ArgUpload(
              oauthUrl: PollPath.postImage,
              url: PollPath.postImage,
              token: OauthAPI.token,
              file: f,
              storageShared: Storage.prefs,
              isMicro: (building != null && (building.isMicro ?? false))),
          fun1: uploadTicketImageWorker);

      if (result.id != "") {
        ticketModel.images?.add(ImageUploadModel(id: result.id));
      }
      completer.complete(result);
    } catch (error) {
      completer.completeError(error);
    }

    return completer.future;
  }

  void sendTicket(BuildContext context) async {
    progressToolkit.state.show();
    progressToolkit.state.update(0);
    await profileAPI.getProfile();

    //Fetch all picked lasted
    await Future.wait(this.filesCompressedPick.map((file) {
      return runTaskUpload(this.filesCompressedPickMapWithBaseFile[file]);
    }).toList())
        .then((List responses) async {
      print('Upload ${this.filesCompressedPick.length} successful');
      for (var i = 0; i < responses.length; ++i) {
        print(((i + 1) * 90) / responses.length);
        progressToolkit.state.update(((i + 1) * 90) / responses.length);
        await Future.delayed(Duration(milliseconds: 100));
      }

      print(json.encode(ticketModel.toJson()));
      final rs = await discssionAPI.postThread(data: ticketModel);

      progressToolkit.state.update(100);

      final t = DiscussionUpdateModel.fromJson(rs);
      if (t.id != null) {
        ticketModel = DiscussionUpdateModel();
        showSuccessfulDialog(context);
      }
    }).whenComplete(() {
      progressToolkit.state.dismiss();
      fImagePicker.child.refresh();
      fDescription.clear();
      _sendButtonController.sink.add(ButtonSubmitEvent(this.isActive = false));
    }).catchError(
      (e) {
        final body = json.decode(e);
        if (body['detail'] ==
            "You do not have permission to create or comment on forum.") {
          DialogCustom.showErrorDialog(
              context: context,
              title: "attention",
              errMsg: "block_discussion_content",
              buttonText: "ok",
              callback: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              });
          return;
        }
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return CupertinoAlertDialog(
              content: Text(
                LocalizationsUtil.of(context)
                    .translate('there_is_an_issue_please_try_again_later_0'),
                style: TextStyle(fontFamily: AppFont.font_family_display),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    //prevent images duplication
                    ticketModel.images!.clear();
                    filesCompressedPick.clear();
                    fImagePicker.child.refresh();
                    fImagePickerStatus.add(LocalizationsUtil.of(context)
                            .translate("photos_attachment") +
                        "(${this.filesCompressedPick.length}/5)");
                    Navigator.pop(context);
                  },
                  child: Text(
                    LocalizationsUtil.of(context).translate('ok'),
                    style: TextStyle(fontFamily: AppFont.font_family_display),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void showSuccessfulDialog(BuildContext context) {
    AppDialog.showContentDialog(
        context: context,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: ListBody(children: <Widget>[
            const SizedBox(height: 20),
            SvgPicture.asset('assets/svg/ticket/ic-sendissue-large.svg'),
            const SizedBox(height: 15),
            Text(
              LocalizationsUtil.of(context).translate('post_thread_success'),
              textAlign: TextAlign.center,
              style: AppFont.BOLD_BLACK_24
                  .copyWith(fontFamily: AppFont.font_family_display),
            ),
            const SizedBox(height: 20),
            Text(
              LocalizationsUtil.of(context)
                  .translate("post_thread_success_desc"),
              textAlign: TextAlign.center,
              style: AppFonts.regular15.copyWith(
                color: Color(
                  0xff808080,
                ),
              ),
            ),
            const SizedBox(height: 40),
            WidgetButton.pink(LocalizationsUtil.of(context).translate('ok'),
                callback: () {
              // Firebase analytics
              GetIt.instance<FBAnalytics>()
                  .sendEventPostNewThread(userID: Storage.getUserID() ?? "");
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            })
          ]),
        ),
        closeShow: false,
        barrierDismissible: true);
  }
}
