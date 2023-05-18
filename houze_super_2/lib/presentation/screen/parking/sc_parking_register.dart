import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:houze_super/middle/api/oauth_api.dart';
import 'package:houze_super/middle/local/storage.dart';
import 'package:houze_super/middle/model/apartment_model.dart';
import 'package:houze_super/middle/model/page_model.dart';
import 'package:houze_super/middle/model/image_meta_model.dart';
import 'package:houze_super/middle/model/parking_vehicle_model.dart';
import 'package:houze_super/middle/repo/parking_repo.dart';
import 'package:houze_super/presentation/base/route_aware_state.dart';
import 'package:houze_super/presentation/common_widgets/button_widget.dart';
import 'package:houze_super/presentation/common_widgets/dropdown_custom.dart';
import 'package:houze_super/presentation/common_widgets/picker_image.dart';
import 'package:houze_super/presentation/common_widgets/widget_dialog_custom.dart';
import 'package:houze_super/presentation/common_widgets/widget_field_custom.dart';
import 'package:houze_super/presentation/common_widgets/widget_home_scaffold.dart';
import 'package:houze_super/presentation/common_widgets/widget_progress_indicator.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/presentation/screen/base/base_widget.dart';
import 'package:houze_super/presentation/screen/home/home_tab/facility/register/detail/widget_section_personal_info.dart';
import 'package:houze_super/presentation/screen/parking/bloc/parking_bloc.dart';
import 'package:houze_super/presentation/screen/parking/parking_constant.dart';
import 'package:houze_super/presentation/screen/ticket/widget_images_box.dart';
import 'package:houze_super/utils/custom_exceptions.dart';
import 'package:houze_super/utils/firebase_analytic/firebase_analytics.dart';
import 'package:houze_super/worker/ticket_worker.dart';
import 'package:worker_manager/worker_manager.dart';

import 'bloc/parking_event.dart';
import 'bloc/parking_state.dart';

class _VehicleInfo {
  final String? name;
  final String? imagePath;
  bool? hasSlot;

  _VehicleInfo({this.name, this.imagePath, this.hasSlot});
}

class ParkingRegisterPage extends StatefulWidget {
  const ParkingRegisterPage();

  @override
  _ParkingRegisterPageState createState() => _ParkingRegisterPageState();
}

class _ParkingRegisterPageState extends RouteAwareState<ParkingRegisterPage> {
  final _parkingVehicleBooking = ParkingVehicleBooking();

  Parking? parking;

  ApartmentMessageModel? apartment;

  int chipIndex = 0;

  bool? hasSlot;

  late WidgetImagesBox fImagePicker;
  var filesCompressedPick = <File>[];
  var filesCompressedPickMapWithBaseFile = <File, File>{};
  final ValueNotifier<bool> _validate = ValueNotifier(false);

  final List<FieldInfo> _fieldsInfo = [
    FieldInfo(
      title: 'model_of_vehicle',
      hint: 'model_of_vehicle_examples',
      controller: TextEditingController(),
    ),
    FieldInfo(
      title: 'vehicle_color',
      hint: 'vehicle_color_examples',
      controller: TextEditingController(),
    ),
    FieldInfo(
      title: "vehicle's_license_plate",
      hint: "vehicle's_license_plate_examples",
      controller: TextEditingController(),
    ),
  ];

  final List<_VehicleInfo> _vehiclesInfo = List<_VehicleInfo>.generate(
    ParkingConstant.vehicleNames.length,
    (i) => _VehicleInfo(
      name: ParkingConstant.vehicleNames[i],
      imagePath: ParkingConstant.vehicleImages[i],
    ),
  );

  void _checkValidation() {
    if (_fieldsInfo.every((e) => e.controller.text.trim().isNotEmpty) &&
        apartment != null &&
        (hasSlot ?? false) &&
        filesCompressedPick.isNotEmpty) {
      _validate.value = true;
    } else {
      _validate.value = false;
    }
  }

  final _streamController = StreamController<bool>.broadcast();

  Stream<bool> get isProgressing => _streamController.stream;

  final fApartment = DropdownWidgetController();

  @override
  void initState() {
    fImagePicker = WidgetImagesBox(
      callbackUploadResult: (FilePick f, FilePick fCompress) {
        this.filesCompressedPick.add(f.file);
        filesCompressedPickMapWithBaseFile[f.file] = fCompress.file;
        _checkValidation();
      },
      callbackRemoveResult: (FilePick f) {
        this.filesCompressedPick.remove(f.file);
        _checkValidation();
      },
      maxImage: 5,
    );
    super.initState();
  }

  @override
  void dispose() {
    _fieldsInfo.forEach((e) => e.controller.dispose());
    _streamController.close();
    fApartment.controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return HomeScaffold(
      title: 'parking_card_registration',
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
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  const WidgetSectionTitle(
                      title: 'please_fill_the_required_information_below'),
                  SectionPersonalInfomation(
                      controller: fApartment,
                      callback: (value) {
                        apartment = value;
                        _checkValidation();
                      }),
                  buildRegisterInfo(context),
                  _dividerBottom(),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.all(20.0).copyWith(bottom: 50.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          LocalizationsUtil.of(context)
                              .translate('photos_attachment'),
                          style: AppFonts.bold16,
                        ),
                        SizedBox(height: 10.0),
                        RichText(
                          text: TextSpan(
                            style: AppFonts.regular14,
                            children: <TextSpan>[
                              TextSpan(
                                text: '*',
                                style: TextStyle(
                                    fontFamily: AppFont.font_family_display,
                                    color: Color(0xFFff6666)),
                              ),
                              TextSpan(
                                  text: LocalizationsUtil.of(context).translate(
                                      'for_with_space_and_lower_case')),
                              TextSpan(
                                text: LocalizationsUtil.of(context).translate(
                                    'car_and_motorcycles_with_lower_case'),
                                style: TextStyle(
                                  fontFamily: AppFont.font_family_display,
                                  color: Color(0xFF7a1dff),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: LocalizationsUtil.of(context)
                                    .translate('hint_car_and_motorcycle'),
                              ),
                              TextSpan(
                                text: '*',
                                style: TextStyle(
                                  fontFamily: AppFont.font_family_display,
                                  color: Color(0xFFff6666),
                                ),
                              ),
                              TextSpan(
                                text: LocalizationsUtil.of(context)
                                    .translate('for_with_space_and_lower_case'),
                              ),
                              TextSpan(
                                text: LocalizationsUtil.of(context)
                                    .translate('bicycle_with_lowercase'),
                                style: TextStyle(
                                  fontFamily: AppFont.font_family_display,
                                  color: Color(0xFF7a1dff),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: LocalizationsUtil.of(context)
                                    .translate('hint_bicycles'),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20.0),
                        // ParkingImagePicker(
                        //   onChangeImages: (images) {
                        //     setState(() => _images = images);
                        //     _parkingVehicleBooking.images = _images;
                        //     _checkValidation();
                        //   },
                        //   images: _images,
                        // ),
                        Padding(
                            padding: const EdgeInsets.only(left: 0, top: 0),
                            child: fImagePicker),
                      ],
                    ),
                  ),
                  _dividerBottom(),
                  ValueListenableBuilder(
                      valueListenable: _validate,
                      builder: (context, value, _) {
                        return RegisterSection(
                          apartment: apartment ?? ApartmentMessageModel(),
                          parking: parking ?? Parking(),
                          hasValidation: _validate.value,
                          fieldsInfo: _fieldsInfo,
                          parkingVehicleBooking: _parkingVehicleBooking,
                          chipIndex: chipIndex,
                          controller: _streamController,
                          map: this.filesCompressedPickMapWithBaseFile,
                          files: this.filesCompressedPick,
                        );
                      }),
                ],
              ),
            ),
            ProgressIndicatorWidget(isProgressing),
          ],
        ),
      ),
    );
  }

  final _parkingBloc = ParkingListBloc();
  Container buildRegisterInfo(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 20.0, bottom: 30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LocalizationsUtil.of(context)
                      .translate('register_vehicle_information'),
                  style: AppFonts.bold16,
                ),
                SizedBox(height: 16.0),
                Text(
                  LocalizationsUtil.of(context).translate('parking_lot'),
                  style: AppFont.REGULAR_GREY,
                ),
                SizedBox(height: 10.0),
              ],
            ),
          ),
          BlocProvider<ParkingListBloc>(
            create: (_) => _parkingBloc,
            child: BlocBuilder<ParkingListBloc, ParkingState>(
              builder: (_, ParkingState state) {
                if (state is ParkingListInitial) {
                  _parkingBloc.add(ParkingGetList());
                }
                if (state is ParkingGetListFailure) {
                  if (state.error.error is NoDataException)
                    return SomethingWentWrong(true);
                  else
                    return SomethingWentWrong();
                }

                if (state is ParkingGetListSuccessful) {
                  final List<Parking> parkingList =
                      state.result.where((f) => f.status == 0).toList();

                  if (parkingList.length == 0) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Text("Hiện chưa có bãi xe."),
                    );
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20.0),
                        child: DropdownCustom(
                          hintText: 'choose_a_parking_lot',
                          items: parkingList,
                          item: parking,
                          setItem: (value) {
                            setState(() => parking = value);

                            final List<bool> status = [];

                            if (parking != null) {
                              status.addAll([
                                parking!.motoSlots! > 0,
                                parking!.carSlots! > 0,
                                parking!.bikeSlots! > 0,
                                parking!.eSlots! > 0,
                              ]);

                              _vehiclesInfo.forEach((e) =>
                                  e.hasSlot = status[_vehiclesInfo.indexOf(e)]);

                              hasSlot = _vehiclesInfo[chipIndex].hasSlot!;
                            }

                            _checkValidation();
                          },
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
                          children: _vehiclesInfo
                              .map(
                                (e) => ChoiceChip(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    side: BorderSide(
                                      color: AppColor.gray_dcdcdc,
                                    ),
                                  ),
                                  labelPadding: const EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                    vertical: 4.0,
                                  ),
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  label: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(LocalizationsUtil.of(context)
                                          .translate(e.name)),
                                      SizedBox(width: 16.0),
                                      SvgPicture.asset(
                                        e.imagePath!,
                                        width: 24.0,
                                        height: 24.0,
                                      ),
                                    ],
                                  ),
                                  selected:
                                      chipIndex == _vehiclesInfo.indexOf(e),
                                  onSelected: (bool value) {
                                    final int index = _vehiclesInfo.indexOf(e);

                                    setState(() => chipIndex = index);

                                    hasSlot = e.hasSlot ?? false;

                                    _checkValidation();
                                  },
                                  labelStyle:
                                      chipIndex == _vehiclesInfo.indexOf(e)
                                          ? AppFont.MEDIUM_PURPLE_7a1dff
                                          : AppFonts.medium14,
                                  selectedColor: Color(0xFFf2e8ff),
                                  backgroundColor: Colors.white,
                                ),
                              )
                              .toList(),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20.0),
                        child: hasSlot != null
                            ? hasSlot!
                                ? Text(
                                    LocalizationsUtil.of(context)
                                        .translate('available_for_booking'),
                                    style: TextStyle(color: Color(0xFF38d6ac)),
                                  )
                                : Text(
                                    LocalizationsUtil.of(context)
                                            .translate('parking_lot_full') +
                                        " " +
                                        LocalizationsUtil.of(context).translate(
                                            _vehiclesInfo[chipIndex].name) +
                                        ' ' +
                                        LocalizationsUtil.of(context)
                                            .translate('is_full'),
                                    style: TextStyle(color: Color(0xFFfb5252)),
                                  )
                            : Container(),
                      )
                    ],
                  );
                }

                return Align(child: CupertinoActivityIndicator());
              },
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: _fieldsInfo
                  .map(
                    (e) => FieldCustom(
                      field: e,
                      onChanged: (_) => setState(() => _checkValidation()),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dividerBottom() => Container(
        decoration:
            BaseWidget.dividerTop(height: 5, color: AppColor.gray_f5f5f5),
      );
}

class RegisterSection extends StatefulWidget {
  final bool hasValidation;
  final ParkingVehicleBooking parkingVehicleBooking;
  final List<FieldInfo> fieldsInfo;
  final Parking parking;
  final ApartmentMessageModel apartment;
  final int chipIndex;
  final StreamController<bool> controller;
  final Map<File, File> map;
  final List<File> files;

  RegisterSection({
    required this.hasValidation,
    required this.parkingVehicleBooking,
    required this.fieldsInfo,
    required this.parking,
    required this.apartment,
    required this.chipIndex,
    required this.controller,
    required this.map,
    required this.files,
  });

  @override
  _RegisterSectionState createState() => _RegisterSectionState();
}

class _RegisterSectionState extends State<RegisterSection> {
  List<ImageMetaModel> _list = [];
  Future<void> _submit(BuildContext context) async {
    widget.controller.add(true);

    try {
      await Future.wait(widget.files.map((file) {
        return runTaskUpload(widget.map[file]);
      }).toList())
          .then((List responses) async {
        for (var i = 0; i < responses.length; ++i) {
          await Future.delayed(Duration(milliseconds: 100));
        }
        final _repo = ParkingRepo();

        widget.parkingVehicleBooking
          ..images = _list
          ..buildingId = widget.apartment.buildingId
          ..apartmentId = widget.apartment.id
          ..residentId = widget.apartment.residentId
          ..parkingId = widget.parking.id
          ..typeVehicle = widget.chipIndex
          ..vehicleName = widget.fieldsInfo[0].controller.text
          ..vehicleColor = widget.fieldsInfo[1].controller.text
          ..licensePlate = widget.fieldsInfo[2].controller.text;

        await _repo.postParkingBooking(widget.parkingVehicleBooking.toJson());
        DialogCustom.showSuccessDialog(
            context: context,
            svgPath: AppVectors.icFacility,
            title: 'booking_successfully',
            content: 'the_building_admin_will_confirm_your_booking_later',
            buttonText: "completed",
            onPressed: () {
              //Firebase Analytics
              GetIt.instance<FBAnalytics>().sendEventRequestACardRegistration(
                  userID: Storage.getUserID() ?? "");
              //Redirect to parking card list page
              Navigator.of(context).popUntil(ModalRoute.withName("/parking"));
            });
      });
    } on DioError catch (err) {
      var e = ErrorModel.fromJson(json.decode(err.error));
      DialogCustom.showErrorDialog(
        context: context,
        title: 'register_failed',
        errMsg: e.errorCitizenJson?.httpBody?.typeVehicle![0] ?? "",
      );
    } finally {
      widget.controller.add(false);
    }
  }

  //Task processing
  Future<dynamic> runTaskUpload(File? f) async {
    var completer = Completer();
    final building = await Sqflite.getCurrentBuilding();
    try {
      final result = await Executor().execute(
          arg1: ArgUpload(
              oauthUrl: APIConstant.postParkingVehicleImage,
              url: APIConstant.postParkingVehicleImage,
              token: OauthAPI.token,
              file: f,
              storageShared: Storage.prefs,
              isMicro: (building != null && (building.isMicro ?? false))),
          fun1: uploadTicketParkingImageWorker);

      this._list.add(result);

      completer.complete(result);
    } catch (error) {
      completer.completeError(error);
    }

    return completer.future;
  }

  @override
  Container build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20.0),
      child: ButtonWidget(
        defaultHintText:
            LocalizationsUtil.of(context).translate('confirm_registration'),
        callback: () {
          if (widget.hasValidation) {
            _submit(context);
          }
        },
        isActive: widget.hasValidation,
      ),
    );
  }
}
