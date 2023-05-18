import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:houze_super/middle/model/apartment_model.dart';
import 'package:houze_super/middle/model/page_model.dart';
import 'package:houze_super/middle/model/image_meta_model.dart';
import 'package:houze_super/middle/model/parking_vehicle_model.dart';
import 'package:houze_super/middle/repo/parking_repo.dart';
import 'package:houze_super/presentation/common_widgets/stateful/dropdown_custom.dart';
import 'package:houze_super/presentation/common_widgets/stateless/widget_button_custom.dart';
import 'package:houze_super/presentation/common_widgets/widget_dialog_custom.dart';
import 'package:houze_super/presentation/common_widgets/stateless/widget_field_custom.dart';
import 'package:houze_super/presentation/common_widgets/stateless/widget_home_scaffold.dart';
import 'package:houze_super/presentation/common_widgets/stateless/widget_progress_indicator.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/presentation/screen/base/base_widget.dart';
import 'package:houze_super/presentation/screen/home/home_tab/facility/register/detail/widget_section_personal_info.dart';
import 'package:houze_super/presentation/screen/parking/bloc/parking_bloc.dart';
import 'package:houze_super/presentation/screen/parking/parking_constant.dart';
import 'package:houze_super/presentation/screen/parking/register/parking_image_picker.dart';
import 'package:houze_super/utils/custom_exceptions.dart';
import 'package:houze_super/utils/index.dart';

import 'bloc/parking_event.dart';
import 'bloc/parking_state.dart';

class _VehicleInfo {
  final String name;
  final String imagePath;
  bool hasSlot;

  _VehicleInfo({this.name, this.imagePath, this.hasSlot});
}

class ParkingRegistrationPage extends StatefulWidget {
  const ParkingRegistrationPage();

  @override
  _ParkingRegistrationPageState createState() =>
      _ParkingRegistrationPageState();
}

class _ParkingRegistrationPageState extends State<ParkingRegistrationPage> {
  final _parkingVehicleBooking = ParkingVehicleBooking();

  Parking parking;

  ApartmentMessageModel apartment;

  int chipIndex = 0;

  bool hasSlot;

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

  bool _hasValidation = false;

  var _images = <ImageMetaModel>[];

  void _checkValidation() {
    if (_fieldsInfo.every((e) => e.controller.text.trim().isNotEmpty) &&
        apartment != null &&
        (hasSlot ?? false) &&
        _images.isNotEmpty)
      _hasValidation = true;
    else
      _hasValidation = false;
  }

  final _streamController = StreamController<bool>.broadcast();

  Stream<bool> get isProgressing => _streamController.stream;

  final fApartment = DropdownWidgetController();

  @override
  void initState() {
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
            //FocusScopeNode currentFocus = FocusScope.of(context);
            // if (!currentFocus.hasPrimaryFocus) {
            //   currentFocus.unfocus();
            // }
            FocusManager.instance.primaryFocus.unfocus();
            new TextEditingController().clear();
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
                        setState(() {
                          apartment = value;
                          _checkValidation();
                        });
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
                          style: AppFonts.bold.copyWith(fontSize: 16),
                        ),
                        const SizedBox(height: 10.0),
                        RichText(
                          text: TextSpan(
                            style: AppFonts.regular,
                            children: <TextSpan>[
                              TextSpan(
                                text: '*',
                                style: TextStyle(
                                    fontFamily: AppFonts.font_family_display,
                                    color: Color(0xFFff6666)),
                              ),
                              TextSpan(
                                  text: LocalizationsUtil.of(context).translate(
                                      'for_with_space_and_lower_case')),
                              TextSpan(
                                text: LocalizationsUtil.of(context).translate(
                                    'car_and_motorcycles_with_lower_case'),
                                style: TextStyle(
                                  fontFamily: AppFonts.font_family_display,
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
                                  fontFamily: AppFonts.font_family_display,
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
                                  fontFamily: AppFonts.font_family_display,
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
                        const SizedBox(height: 20.0),
                        ParkingImagePicker(
                          onChangeImages: (images) {
                            setState(() => _images = images);
                            _parkingVehicleBooking.images = _images;
                            _checkValidation();
                          },
                          images: _images,
                        ),
                      ],
                    ),
                  ),
                  _dividerBottom(),
                  RegisterSection(
                    apartment: apartment,
                    parking: parking,
                    hasValidation: _hasValidation,
                    fieldsInfo: _fieldsInfo,
                    parkingVehicleBooking: _parkingVehicleBooking,
                    chipIndex: chipIndex,
                    controller: _streamController,
                  ),
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
                  style: AppFonts.bold.copyWith(fontSize: 16),
                ),
                const SizedBox(height: 16.0),
                Text(
                  LocalizationsUtil.of(context).translate('parking_lot'),
                  style: AppFonts.regular15.copyWith(color: Color(0xff808080)),
                ),
                const SizedBox(height: 10.0),
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
                                parking.motoSlots > 0,
                                parking.carSlots > 0,
                                parking.bikeSlots > 0,
                                parking.eSlots > 0,
                              ]);

                              _vehiclesInfo.forEach((e) =>
                                  e.hasSlot = status[_vehiclesInfo.indexOf(e)]);

                              hasSlot = _vehiclesInfo[chipIndex].hasSlot;
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
                                      color: Color(0xffdcdcdc),
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
                                      const SizedBox(width: 16.0),
                                      SvgPicture.asset(
                                        e.imagePath,
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

                                    hasSlot = e.hasSlot;

                                    _checkValidation();
                                  },
                                  labelStyle: chipIndex ==
                                          _vehiclesInfo.indexOf(e)
                                      ? AppFonts.medium
                                          .copyWith(color: Color(0xff7a1dff))
                                      : AppFonts.medium,
                                  selectedColor: Color(0xFFf2e8ff),
                                  backgroundColor: Colors.white,
                                ),
                              )
                              .toList(),
                        ),
                      ),
                      hasSlot != null
                          ? Container(
                              margin: EdgeInsets.symmetric(horizontal: 20.0),
                              child: hasSlot
                                  ? Text(
                                      LocalizationsUtil.of(context)
                                          .translate('available_for_booking'),
                                      style:
                                          TextStyle(color: Color(0xFF38d6ac)),
                                    )
                                  : Text(
                                      LocalizationsUtil.of(context)
                                              .translate('parking_lot_full') +
                                          " " +
                                          LocalizationsUtil.of(context)
                                              .translate(
                                                  _vehiclesInfo[chipIndex]
                                                      .name) +
                                          ' ' +
                                          LocalizationsUtil.of(context)
                                              .translate('is_full'),
                                      style:
                                          TextStyle(color: Color(0xFFfb5252)),
                                    ),
                            )
                          : const SizedBox.shrink(),
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
        decoration: BaseWidget.dividerTop(height: 5, color: Color(0xfff5f5f5)),
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

  RegisterSection({
    @required this.hasValidation,
    @required this.parkingVehicleBooking,
    @required this.fieldsInfo,
    @required this.parking,
    @required this.apartment,
    @required this.chipIndex,
    @required this.controller,
  });

  @override
  _RegisterSectionState createState() => _RegisterSectionState();
}

class _RegisterSectionState extends State<RegisterSection> {
  Future<void> _submit(BuildContext context) async {
    widget.controller.add(true);

    widget.parkingVehicleBooking
      ..buildingId = widget.apartment.buildingId
      ..apartmentId = widget.apartment.id
      ..residentId = widget.apartment.residentId
      ..parkingId = widget.parking.id
      ..typeVehicle = widget.chipIndex
      ..vehicleName = widget.fieldsInfo[0].controller.text
      ..vehicleColor = widget.fieldsInfo[1].controller.text
      ..licensePlate = widget.fieldsInfo[2].controller.text;

    try {
      final _repo = ParkingRepo();

      await _repo.postParkingBooking(widget.parkingVehicleBooking.toJson());
      DialogCustom.showSuccessDialog(
        context: context,
        svgPath: AppVectors.icFacility,
        title: 'booking_successfully',
        content: 'the_building_admin_will_confirm_your_booking_later',
        onPressed: () => Navigator.of(context)
            .popUntil(ModalRoute.withName("app://home/parking-card-list")),
      );
    } catch (err) {
      var e = ErrorModel.fromJson(json.decode(err));
      DialogCustom.showErrorDialog(
        context: context,
        title: 'register_failed',
        errMsg: e?.errorCitizenJson?.httpBody?.typeVehicle[0] ?? "",
        callback: () => Navigator.pop(context),
      );
    } finally {
      widget.controller.add(false);
    }
  }

  @override
  Container build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20.0),
      child: RaisedButtonCustom(
        buttonText: 'confirm_registration',
        onPressed: widget.hasValidation ? () => _submit(context) : null,
      ),
    );
  }
}
