import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:app_settings/app_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_video_info/flutter_video_info.dart';
import 'package:geolocator/geolocator.dart';
import 'package:houze_super/app/bloc/bloc_registry.dart';
import 'package:houze_super/app/bloc/overlay/index.dart';
import 'package:houze_super/middle/api/index.dart';
import 'package:houze_super/middle/api/oauth_api.dart';
import 'package:houze_super/middle/local/storage.dart';
import 'package:houze_super/middle/model/apartment_model.dart';
import 'package:houze_super/middle/model/ticket_model.dart';
import 'package:houze_super/middle/repo/ticket_repository.dart';
import 'package:houze_super/presentation/common_widgets/app_dialog.dart';
import 'package:houze_super/presentation/common_widgets/stateless/button_widget.dart';
import 'package:houze_super/presentation/common_widgets/stateful/dropdown_widget.dart';
import 'package:houze_super/presentation/common_widgets/stateful/picker_image.dart';
import 'package:houze_super/presentation/common_widgets/stateful/video_picker.dart';
import 'package:houze_super/presentation/common_widgets/widget_button.dart';
import 'package:houze_super/presentation/common_widgets/widget_dialog_custom.dart';
import 'package:houze_super/presentation/common_widgets/stateless/widget_home_scaffold.dart';
import 'package:houze_super/presentation/common_widgets/stateless/widget_input.dart';

import 'package:houze_super/presentation/common_widgets/stateful/widget_switch.dart';
import 'package:houze_super/presentation/common_widgets/stateless/widget_text.dart';
import 'package:houze_super/presentation/common_widgets/stateless/widget_text_controller.dart';
import 'package:houze_super/presentation/screen/ticket/widget_apartment_box.dart';
import 'package:houze_super/presentation/screen/ticket/widget_images_box.dart';
import 'package:houze_super/presentation/screen/ticket/widget_mini_box.dart';
import 'package:houze_super/presentation/screen/ticket/widget_standard_box.dart';
import 'package:houze_super/presentation/screen/ticket/widget_ticket_type_box.dart';
import 'package:houze_super/utils/constants/constants.dart';
import 'package:houze_super/utils/index.dart';
import 'package:houze_super/utils/localizations_util.dart';
import 'package:houze_super/utils/permission_handler.dart';
import 'package:houze_super/utils/progresshub.dart';
import 'package:houze_super/utils/sqflite.dart';
import 'package:houze_super/utils/string_util.dart';
import 'package:houze_super/worker/ticket_worker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_compress/video_compress.dart';
import 'package:worker_manager/worker_manager.dart';

import 'package:houze_super/middle/repo/point_earn_repo.dart';
import 'package:houze_super/middle/model/houze_point/point_earn_model.dart';
import 'package:houze_super/presentation/common_widgets/houze_point/widget_points_info.dart';

//---SCREEN: Gửi phản ánh---//

class SendRequestPage extends StatefulWidget {
  SendRequestPage({Key key}) : super(key: key);

  @override
  _SendRequestPageState createState() => _SendRequestPageState();
}

typedef void CallBackHandler(bool value);

class _SendRequestPageState extends State<SendRequestPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  //Service converter
  Future<String> service;

  //Repository
  final rpTicket = TicketRepository();
  WidgetImagesBox fImagePicker;
  final fImagePickerStatus = StreamController<String>.broadcast();
  final fApartment = DropdownWidgetController();
  final fIssue = DropdownWidgetController();
  final fDescription = TextEditingController();
  final fPhone = TextEditingController();
  // ignore: close_sinks
  StreamController<ButtonSubmitEvent> _sendButtonController =
      StreamController<ButtonSubmitEvent>.broadcast();

  TicketModel ticketModel = TicketModel();
  bool isActive = false;
  var profileAPI = ProfileAPI();

  //Action Event List data
  var filesCompressedPick = <File>[];
  var filesCompressedPickMapWithBaseFile = <File, File>{};

  final ProgressHUD progressToolkit = Progress.instanceCreateWithNormal();
  final StreamController<SwitchEvent> switchController =
      StreamController<SwitchEvent>.broadcast();

  // houze xu
  final String buildingId = Sqflite.currentBuildingID;
  final rpXu = PointEarnRepository();
  PointEarnModel _xuEarn;

  Future<void> getXuEarnInfo() async {
    var xu = await rpXu.getXuEarnInfo(buildingId);

    setState(() {
      _xuEarn = xu;
    });
  }

  bool checkValidation() {
    if (!StringUtil.isEmpty(ticketModel.apartmentID) &&
        ticketModel.category != null &&
        !StringUtil.isEmpty(ticketModel.description)) {
      if (_video != null) {
        if (isVideoUploadSuccessfully != null && isVideoUploadSuccessfully) {
          this.isActive = true;
        } else {
          this.isActive = false;
        }
      } else {
        this.isActive = true;
      }
    } else {
      this.isActive = false;
    }

    _sendButtonController.sink.add(ButtonSubmitEvent(this.isActive));
    return this.isActive;
  }

  //video picker
  File _video;
  final picker = ImagePicker();
  final videoInfo = FlutterVideoInfo();
  File _thumbnailFile;
  WidgetVideoPicker fVideoPicker = WidgetVideoPicker();
  CallBackHandler callback;
  bool isVideoUploading = false;
  bool isVideoUploadSuccessfully;
  void showSnackBar(String content) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(content),
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _showVideoPickedActionSheet(BuildContext context) {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15.0), topRight: Radius.circular(20.0)),
      ),
      context: context,
      builder: (builder) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(
                  Icons.camera_alt,
                  color: Color(0xFF725ef6),
                ),
                title: Text(
                    LocalizationsUtil.of(context).translate('recording_video')),
                onTap: () {
                  Navigator.pop(context);
                  PermissionHandler.checkAndRequestStoragePermission(
                      context: context,
                      func: () {
                        _pickAndUploadVideo(context, ImageSource.camera);
                      });
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.photo_album,
                  color: Color(0xFF725ef6),
                ),
                title: Text(LocalizationsUtil.of(context)
                    .translate('pick_video_from_gallery')),
                onTap: () {
                  Navigator.pop(context);
                  PermissionHandler.checkAndRequestStoragePermission(
                      context: context,
                      func: () {
                        _pickAndUploadVideo(context, ImageSource.gallery);
                      });
                },
              ),
            ],
          ),
        );
      },
    );
  }

  _formatBytes(int bytes, int decimals) {
    if (bytes <= 0) return 0.0;
    var i = (log(bytes) / log(1024)).floor();
    return num.parse((bytes / pow(1024, i)).toStringAsFixed(decimals));
  }

  void _pickAndUploadVideo(
      BuildContext context, ImageSource imageSource) async {
    //pick video from gallery
    try {
      await Future.delayed(Duration(milliseconds: 300));

      PickedFile pickedFile = await picker.getVideo(
          source: imageSource, maxDuration: Duration(seconds: 4));

      if (pickedFile != null) {
        //get file thumbnail
        _thumbnailFile = await VideoCompress.getFileThumbnail(pickedFile.path);
        setState(() {
          this._video = File(pickedFile.path);
        });
        //get file info
        videoInfo.getVideoInfo(this._video.path).then((videoInfo) {
          if (videoInfo.duration > 5000) {
            //max duration allowed
            print("========> Violate maxDuration: " +
                (videoInfo.duration * (0.001)).toString());
            showSnackBar(LocalizationsUtil.of(context)
                .translate('video_exceeds_5_seconds'));
            this._video = null;
          } else {
            //loading animation
            setState(() {
              this.isVideoUploading = true;
            });
            //get file size
            var fileSize = _formatBytes(this._video.lengthSync(), 2);
            print("================> Origin file size: $fileSize MB");
            //Compression and upload video
            print("================> Compress to default quality");
            _compressAndUploadVideo(this._video, VideoQuality.DefaultQuality);
          }
        });
      } else {
        return;
      }
    } on PlatformException catch (e) {
      print('Failed to perform action: ${e.message}');
      if (e.message == "The user did not allow camera access.") {
        PermissionHandler.permissionAlertDialog(
            context: context,
            title: 'camera_permission',
            content: 'camera_permission_msg',
            buttonText: 'settings',
            buttonCancel: 'houze_run_popup_location_permission_dont_allow');
      }
    }
  }

  _compressAndUploadVideo(File video, VideoQuality quality) {
    //compress video
    Future.delayed(Duration(milliseconds: 250));
    VideoCompress.compressVideo(video.path,
            quality: quality, deleteOrigin: false, includeAudio: true)
        .then((value) async {
      print("=====================> Compress size: " +
          _formatBytes(File(value.path).lengthSync(), 2).toString() +
          " MB");

      //upload compressed video.
      try {
        await profileAPI.getProfile(); //refresh token
        Future.delayed(Duration(milliseconds: 300));
        Future.wait([runTaskUploadVideo(File(value.path))])
            .then((List responses) async {
          print('Upload video successfully');
          for (var i = 0; i < responses.length; ++i) {
            print((((i + 1) * 100) / responses.length).toString());
            await Future.delayed(Duration(milliseconds: 100));
          }
          setState(() {
            //stop loading animation
            this.isVideoUploading = false;
            this.isVideoUploadSuccessfully = true;
          });
        });
      } catch (e) {
        print(e.toString());
        setState(() {
          this.isVideoUploading = false;
        });
      }
    });
  }

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
    //Service converter
    service = ServiceConverter.convertTypeBuilding("apartment_with_colon");

    getXuEarnInfo();

    super.initState();
  }

  @override
  void dispose() {
    switchController.close();
    fImagePickerStatus.close();
    fApartment.controller.dispose();
    fDescription.dispose();
    fIssue.controller.dispose();
    fPhone.dispose();
    _sendButtonController.close();
    //_videoPlayerController?.dispose();
    super.dispose();
  }

  //Location
  Position currentLocation;

  Future<Position> _getLocation() async {
    Position _current;
    var locationPermission = await Geolocator.checkPermission();
    if (locationPermission == LocationPermission.denied) {
      locationPermission = await Geolocator.requestPermission();
    }
    // GeolocationStatus geolocationStatus =
    //     await geolocator.checkGeolocationPermissionStatus();
    if (locationPermission != LocationPermission.denied) {
      await Future.delayed(const Duration(milliseconds: 2000));
    }

    try {
      _current = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
    } catch (e) {
      return null;
    }
    return _current;
  }

  @override
  Widget build(BuildContext context) {
    fVideoPicker = WidgetVideoPicker(
      videoUrl: ticketModel.videoUrl,
      thumbnail: _thumbnailFile,
      pickVideo: _showVideoPickedActionSheet,
      parentCtx: context,
      callback: (value) {
        if (value != null && value) {
          setState(() {
            this._video = null;
            this.ticketModel.videoUrl = null;
            this._thumbnailFile = null;
          });
        }
      },
    );

    return HomeScaffold(
      scaffoldKey: _scaffoldKey,
      title: 'send_a_request',
      child: GestureDetector(
        onTap: () {
          bool isKeyboardShowing = MediaQuery.of(context).viewInsets.bottom > 0;
          if (isKeyboardShowing) {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          }
        },
        child: Stack(
          children: <Widget>[
            ListView(
              shrinkWrap: true,
              children: <Widget>[
                if (_xuEarn != null && _xuEarn.ticketRatingAward != 0)
                  WidgetXuInfo(
                    textContent:
                        '${LocalizationsUtil.of(context).translate('reflect_enough_content_immediately_receive')} ${StringUtil.numberFormat(_xuEarn.ticketCreatedAward)} ${LocalizationsUtil.of(context).translate('points')}',
                    disabledChangeBuilding: true,
                  ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 15),
                  child: Text(
                    LocalizationsUtil.of(context)
                        .translate('short_video_attachment'),
                    style: AppFonts.medium16.copyWith(letterSpacing: 0.26),
                  ),
                ),
                !isVideoUploading
                    ? Padding(
                        padding: const EdgeInsets.only(left: 20, top: 15.0),
                        child: fVideoPicker,
                      )
                    : Padding(
                        padding: EdgeInsets.only(
                            right: MediaQuery.of(context).size.width * 0.7,
                            top: 20.0),
                        child: const Center(
                          child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(0xff5b00e4))),
                        ),
                      ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 15),
                  child: WidgetStandardBox(
                    title: TextDynamicWidget(
                      defaultText: LocalizationsUtil.of(context)
                              .translate("photos_attachment") +
                          "(0/5)",
                      style: AppFonts.medium16.copyWith(letterSpacing: 0.26),
                      controller: fImagePickerStatus,
                    ),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: fImagePicker),
                const SizedBox(height: 29),
                Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: WidgetStandardBox(
                      title: TextWidget(
                        LocalizationsUtil.of(context)
                            .translate("send_a_request_with_location_gps"),
                        style: AppFonts.medium16.copyWith(letterSpacing: 0.26),
                      ),
                      actions: SwitchWidget(
                        defaultValue: false,
                        controller: switchController,
                        initEvent: (SwitchWidgetState obj) async {
                          if (await this._getLocation() != null) {
                            obj.toggle(true);
                          }
                        },
                        doneEvent: (value) async {
                          if (value == false) {
                            currentLocation = null;
                          } else {
                            final _current = await _getLocation();
                            if (_current == null) {
                              AppSettings.openLocationSettings();
                            } else {
                              currentLocation = _current;
                              return true;
                            }
                          }
                          return false;
                        },
                      ),
                    )),
                const SizedBox(height: 31),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: FutureBuilder(
                    future: service, //Service converter
                    builder: (context, snap) {
                      if (snap.connectionState == ConnectionState.waiting) {
                        return const SizedBox.shrink();
                      }
                      return WidgetApartmentBox(
                        title:
                            LocalizationsUtil.of(context).translate(snap.data),
                        controller: fApartment,
                        callbackResult: (ApartmentMessageModel apartmentModel) {
                          if (apartmentModel == null) {
                            ticketModel.buildingID = "";
                            ticketModel.blockID = "";
                            ticketModel.floorID = "";
                            ticketModel.apartmentID = "";
                            ticketModel.residentID = "";
                          } else {
                            ticketModel.buildingID = apartmentModel.buildingId;
                            ticketModel.blockID = apartmentModel.blockId;
                            ticketModel.floorID = apartmentModel.floorId;
                            ticketModel.apartmentID = apartmentModel.id;
                            ticketModel.residentID = apartmentModel.residentId;
                          }
                          this.checkValidation();
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 29),
                Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: WidgetTicketTypeBox(
                      controller: fIssue,
                      callbackResult: (int category) {
                        ticketModel.category = category;
                        this.checkValidation();
                      },
                    )),
                const SizedBox(height: 29),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: WidgetMiniBox(
                    title: "description_with_colon",
                    child: WidgetInput(
                      controller: fDescription,
                      keyboardType: TextInputType.multiline,
                      style: AppFonts.regular14,
                      hint: 'write_your_description',
                      onChanged: (String value) {
                        ticketModel.description = value;
                        this.checkValidation();
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 29),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: WidgetMiniBox(
                    title: 'another_phone_number_optional',
                    child: WidgetInput(
                      keyboardType: TextInputType.number,
                      controller: fPhone,
                      style: AppFonts.regular14,
                      hint: 'your_phone_number',
                      onChanged: (String value) {
                        ticketModel.phone = value;
                        this.checkValidation();
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 29),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: ButtonWidget(
                    defaultHintText:
                        LocalizationsUtil.of(context).translate('continue'),
                    controller: _sendButtonController,
                    callback: () {
                      sendTicket(context);
                    },
                  ),
                ),
              ],
            ),
            progressToolkit,
          ],
        ),
      ),
    );
  }

  //Task processing
  Future<dynamic> runTaskUpload(File f) async {
    var completer = Completer();
    final building = Sqflite.currentBuilding;

    final task = Task(
        function: uploadTicketImageWorker,
        arg: ArgUpload(
            oauthUrl: APIConstant.postImage,
            url: APIConstant.postImage,
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
        ticketModel.images.add(ImageUploadModel(id: result.id));
      }
      completer.complete(result);
    }).onError((error) {
      completer.completeError(error);
    });

    return completer.future;
  }

  //Task processing
  Future<dynamic> runTaskUploadVideo(File pickedVideo) async {
    var completer = Completer();
    final building = Sqflite.currentBuilding;

    final task = Task(
        function: uploadTicketVideoWorker,
        arg: ArgUpload(
            oauthUrl: APIConstant.postVideo,
            url: APIConstant.postVideo,
            token: OauthAPI.token,
            file: pickedVideo,
            storageShared: Storage.prefs,
            isMicro: (building != null && (building.isMicro ?? false))));

    Executor()
        .addTask(
      task: task,
    )
        .listen((result) async {
      if (result != null && result != "") {
        ticketModel.videoUrl = result;
      }
      completer.complete(result);
    }).onError((error) {
      completer.completeError(error);

      DialogCustom.showErrorDialog(
        context: context,
        title: 'fail_to_upload_video',
        errMsg: 'there_is_an_issue_please_try_again_later_0',
        callback: () => Navigator.pop(context),
      );
      setState(() {
        this._video = null;
        this.isVideoUploading = false;
      });
    });

    return completer.future;
  }

  Future<void> sendTicket(BuildContext context) async {
    //Validation
    if (!StringUtil.isEmpty(fPhone.text) && fPhone.text.length < 10) {
      return AppDialog.showAlertDialog(
          context,
          null,
          LocalizationsUtil.of(context)
                  .translate("please_write_your_phone_number_longer") +
              " 10 " +
              LocalizationsUtil.of(context)
                  .translate("characters_with_lower_case"));
    }

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
        print((((i + 1) * 90) / responses.length).toString());
        progressToolkit.state.update(((i + 1) * 90) / responses.length);
        await Future.delayed(Duration(milliseconds: 100));
      }

      //Merge current position
      if (currentLocation != null) {
        print('currentLocation: $currentLocation');
        ticketModel.lat = currentLocation.latitude;
        ticketModel.long = currentLocation.longitude;
      }

      print(json.encode(ticketModel.toJson()));
      final rs = await rpTicket.sendTicket(ticketModel);

      progressToolkit.state.update(100);

      if (rs == true) {
        ticketModel = TicketModel();
        showSuccessfulDialog(context);
      }
    }).whenComplete(() {
      progressToolkit.state.dismiss();
      fImagePicker.child.refresh();
      fApartment.refresh();
      fIssue.refresh();
      fDescription.clear();
      fPhone.clear();
      this._video = null;
      _sendButtonController.sink.add(ButtonSubmitEvent(this.isActive = false));
    }).catchError(
      (e) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return CupertinoAlertDialog(
              content: Text(
                LocalizationsUtil.of(context)
                    .translate('there_is_an_issue_please_try_again_later_0'),
                style: TextStyle(fontFamily: AppFonts.font_family_display),
              ),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    //prevent images duplication
                    ticketModel.images.clear();
                    filesCompressedPick.clear();
                    fImagePicker.child.refresh();
                    fImagePickerStatus.add(LocalizationsUtil.of(context)
                            .translate("photos_attachment") +
                        "(${this.filesCompressedPick.length}/5)");
                    Navigator.pop(context);
                  },
                  child: Text(
                    LocalizationsUtil.of(context).translate('ok'),
                    style: TextStyle(fontFamily: AppFonts.font_family_display),
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
              LocalizationsUtil.of(context)
                  .translate('request_sent_successfully'),
              textAlign: TextAlign.center,
              style: AppFonts.bold.copyWith(
                fontFamily: AppFonts.font_family_display,
                color: Colors.black,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 20),
            Text(
                LocalizationsUtil.of(context)
                    .translate("building_pm_will_reply_your_request_soon"),
                textAlign: TextAlign.center,
                style: AppFonts.regular15
                    .copyWith(color: Color(0xff808080))
                    .copyWith(
                        letterSpacing: 0.24,
                        fontFamily: AppFonts.font_family_display)),
            const SizedBox(height: 40),
            WidgetButton.pink(
                LocalizationsUtil.of(context).translate('go_to_mailbox'),
                callback: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              //Jump to Mailbox tab
              (BlocRegistry.get("overlay_bloc") as OverlayBloc)
                  .pageController
                  .animateToPage(AppTabbar.mailbox,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.ease);
            })
          ]),
        ),
        closeShow: false,
        barrierDismissible: true);
  }
}
