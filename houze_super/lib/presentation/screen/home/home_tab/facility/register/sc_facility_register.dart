import 'dart:async';

import 'package:houze_super/middle/repo/apartment_repository.dart';
import 'package:houze_super/middle/repo/profile_repository.dart';
import 'package:houze_super/presentation/screen/profile/bloc/profile_bloc.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:houze_super/app/bloc/apartment/index.dart';

import 'package:houze_super/middle/model/apartment_model.dart';
import 'package:houze_super/middle/model/facility/index.dart';
import 'package:houze_super/middle/model/keyvalue_model.dart';
import 'package:houze_super/middle/repo/facility_repository.dart';
import 'package:houze_super/presentation/app_router.dart';
import 'package:houze_super/presentation/common_widgets/app_dialog.dart';
import 'package:houze_super/presentation/common_widgets/stateless/button_widget.dart';
import 'package:houze_super/presentation/common_widgets/stateful/dropdown_widget.dart';
import 'package:houze_super/presentation/common_widgets/stateless/textfield_widget.dart';
import 'package:houze_super/presentation/common_widgets/stateless/widget_boxes_container.dart';
import 'package:houze_super/presentation/common_widgets/widget_button.dart';
import 'package:houze_super/presentation/common_widgets/widget_dialog_custom.dart';
import 'package:houze_super/presentation/screen/home/home_tab/facility/register/widget_number.dart';

import 'package:houze_super/presentation/common_widgets/stateless/widget_scaffold_presentation.dart';
import 'package:houze_super/presentation/screen/base/base_widget.dart';
import 'package:houze_super/presentation/screen/home/home_tab/facility/register/sc_facility_term.dart';
import 'package:houze_super/presentation/screen/home/home_tab/facility/register/widget_info_apartment_section.dart';
import 'package:houze_super/presentation/screen/ticket/widget_mini_box.dart';
import 'package:houze_super/utils/index.dart';
import 'package:houze_super/utils/localizations_util.dart';
import 'package:houze_super/utils/progresshub.dart';
import 'package:houze_super/utils/string_util.dart';

import 'picker/sc_facility_pickevent.dart';

//---SCREEN: Đăng ký tiện ích---//

/*
 * "id": widget.params.facilityId,
              "title": appTitle,
              "callback_successful": () {
                //Allow refresh
                setState(() {
                  _facilityDetail = null;
                });
              }
 */
typedef void FacilityRegisterCallback(FacilityDetailModel facility);

class FacilityRegisterScreenArgument {
  final String facilityId;
  final String title;
  final FacilityRegisterCallback callback;

  FacilityRegisterScreenArgument({
    @required this.facilityId,
    @required this.title,
    @required this.callback,
  });
}

class FacilityRegisterScreen extends StatefulWidget {
  final FacilityRegisterScreenArgument params;

  FacilityRegisterScreen({Key key, this.params}) : super(key: key);

  @override
  FacilityRegisterScreenState createState() => FacilityRegisterScreenState();
}

class FacilityRegisterScreenState extends State<FacilityRegisterScreen> {
  Future<List<String>> serviceApartments;

  final double betweenPadding = 20;
  var padding = 0.0;

  final ProgressHUD progressToolkit = Progress.instanceCreateWithNormal();

  final _facilityRepository = FacilityRepository();
  FacilityRegistryModel registerModel = FacilityRegistryModel();

  //Fcontroller
  final fSubmit = StreamController<ButtonSubmitEvent>.broadcast();
  final fdescription = TextFieldWidgetController();
  bool isActive = false;

  final _adultsController = TextEditingController();
  final _childrenController = TextEditingController();
  var numChild = 0;
  var numAdult = 0;

  bool checkValidation() {
    final total = registerModel.adultsNum + registerModel.childrenNum;
    this.isActive = (!StringUtil.isEmpty(registerModel.apartmentId) &&
        !StringUtil.isEmpty(registerModel.residentId) &&
        !StringUtil.isEmpty(registerModel.facilitySlotId) &&
        total > 0);

    fSubmit.sink.add(ButtonSubmitEvent(this.isActive));
    return this.isActive;
  }

  FacilityRegistryModel facilityRegistryResult(FacilityRegistryModel model) {
    model.facilityId = widget.params.facilityId;
    model.date = DateFormat('yyyy-MM-dd').format(model.dateTime);
    return model;
  }

  @override
  void initState() {
    serviceApartments = Future.wait([
      ServiceConverter.getTextToConvert("apartment_id_with_colon"),
      ServiceConverter.getTextToConvert('select_an_apartment'),
      ServiceConverter.getTextToConvert('apartment')
    ]);

    super.initState();
  }

  Widget choseDate(BuildContext context) {
    Widget buttonSelect = SizedBox.shrink();

    if (!StringUtil.isEmpty(registerModel.facilitySlotId)) {
      buttonSelect = Container(
          width: double.maxFinite,
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          decoration: BoxDecoration(
              gradient: AppColors.gradient,
              borderRadius: BorderRadius.all(Radius.circular(5.0))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SvgPicture.asset(AppVectors.ic_touch_active),
              const SizedBox(width: 20),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                    Text(
                        "${registerModel.startTime} - ${registerModel.endTime}, ${DateFormat('dd/MM/yyyy').format(registerModel.dateTime)}",
                        style: AppFonts.medium14.copyWith(color: Colors.white)),
                    const SizedBox(height: 5),
                    Text(registerModel.facilityName,
                        style: AppFonts.medium14.copyWith(color: Colors.white))
                  ])),
              const SizedBox(width: 20),
              SvgPicture.asset(AppVectors.icEdit),
            ],
          ));
    } else {
      buttonSelect = DottedBorder(
        padding: const EdgeInsets.all(0),
        borderType: BorderType.RRect,
        dashPattern: [5, 5],
        color: Color(0xff737373),
        radius: Radius.circular(5),
        child: Container(
          width: double.maxFinite,
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SvgPicture.asset("assets/svg/icon/booking/ic-touch.svg"),
              const SizedBox(width: 20),
              Expanded(
                child: Text(
                  LocalizationsUtil.of(context)
                      .translate("click_to_pick_your_date_and_slot"),
                  maxLines: 2,
                ),
              )
            ],
          ),
        ),
      );
    }

    return GestureDetector(
      child: buttonSelect,
      onTap: () {
        AppRouter.push(
          context,
          AppRouter.FACILITY_PICK_PAGE,
          FacilityPickEventScreenArgument(
            facilityId: widget.params.facilityId,
            callback: (result) {
              registerModel.startTime = result.startTime;
              registerModel.endTime = result.endTime;
              registerModel.dateTime = result.dateTime;
              registerModel.facilityName = result.facilityName;
              registerModel.adultsNum = result.adultsNum;
              registerModel.childrenNum = result.childrenNum;

              setState(() {
                registerModel.adultsNum = numAdult;
                registerModel.childrenNum = numChild;
                registerModel.facilitySlotId = result.facilitySlotId;
              });
              this.checkValidation();
            },
          ),
        );
      },
    );
  }

  final apartmentBloc = ApartmentBloc(
    apartmentRepo: ApartmentRepository(),
  );
  final fApartment = DropdownWidgetController();

  Widget _apartmentCodeBox() {
    return FutureBuilder(
      future: serviceApartments,
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return CupertinoActivityIndicator();
        }
        return WidgetMiniBox(
          title: snap.data[0],
          child: BlocProvider<ApartmentBloc>(
            create: (_) => apartmentBloc..add(GetAllApartment()),
            child: BlocBuilder<ApartmentBloc, List<ApartmentMessageModel>>(
              builder: (BuildContext context,
                  List<ApartmentMessageModel> apartments) {
                var _listResident = List<KeyValueModel>();

                var _listApartment = apartments.map((f) {
                  _listResident
                      .add(KeyValueModel(key: f.id, value: f.residentId));

                  return KeyValueModel(key: f.id, value: f.name);
                }).toList();

                return DropdownWidget(
                  controller: fApartment,
                  defaultHintText: snap.data[1],
                  dataSource: _listApartment,
                  buildChild: (index) {
                    return Center(
                      child: Text(
                        LocalizationsUtil.of(context).translate(snap.data[2]) +
                            ' ' +
                            apartments[index].name,
                        style:
                            TextStyle(fontFamily: AppFonts.font_family_display),
                      ),
                    );
                  },
                  doneEvent: (index) async {
                    registerModel.apartmentId = _listApartment[index].key;
                    registerModel.residentId = _listResident[index].value;
                    this.checkValidation();
                  },
                  cancelEvent: (index) async {},
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildTerms(BuildContext context) {
    return SliverToBoxAdapter(
        child: GestureDetector(
      onTap: () {
        AppRouter.pushDialog(context, AppRouter.FACILITY_TERMS_PAGE,
            FacilityTermScreenArgument(id: widget.params.facilityId));
      },
      child: Container(
        height: 100,
        decoration: BaseWidget.dividerTop(height: 5, color: Color(0xfff5f5f5)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
                LocalizationsUtil.of(context).translate(
                    'by_clicking_on_the_booking_confirmation_button_you_agreed_with'),
                style: AppFonts.regular14),
            Text(
                LocalizationsUtil.of(context)
                    .translate('facility_regulations_and_terms_1'),
                style: AppFonts.bold.copyWith(color: Color(0xff7a1dff)))
          ],
        ),
        margin: const EdgeInsets.only(top: 20),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      ),
    ));
  }

  Widget _buildRegisterInfo(BuildContext context) {
    final serviceTitle = widget.params.title.toLowerCase();
    final isHouzeService = serviceTitle.contains('houze service') ||
        serviceTitle.contains('hs') ||
        serviceTitle.contains('combo');

    if (isHouzeService) {
      numAdult = 1;
      numChild = 0;
    }

    return SliverToBoxAdapter(
      child: WidgetBoxesContainer(
        title: 'registration_information',
        padding: const EdgeInsets.all(20),
        hasLine: false,
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              choseDate(context),
              const SizedBox(height: 29),
              Text(LocalizationsUtil.of(context).translate('note_with_colon'),
                  style: AppFonts.medium14.copyWith(color: Colors.black)),
              TextFieldWidget(
                  controller: fdescription,
                  defaultHintText: LocalizationsUtil.of(context)
                      .translate("enter_your_note_here"),
                  keyboardType: TextInputType.multiline,
                  textCapitalization: TextCapitalization.sentences,
                  callback: (String value) {
                    registerModel.description = value;
                    this.checkValidation();
                  }),
              const SizedBox(height: 29),
              isHouzeService
                  ? const SizedBox.shrink()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                  LocalizationsUtil.of(context)
                                      .translate('no_of_adults_with_colon_1'),
                                  style: AppFonts.medium14
                                      .copyWith(color: Colors.black)),
                              WidgetNumber(
                                controller: _adultsController,
                                maxNumber: 99,
                                doneEvent: (value) async {
                                  setState(() {
                                    numAdult = value;
                                    registerModel.adultsNum = numAdult;
                                    this.checkValidation();
                                  });
                                },
                              )
                            ],
                          ),
                          const SizedBox(height: 29),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                  LocalizationsUtil.of(context)
                                      .translate('no_of_children_with_colon_1'),
                                  style: AppFonts.medium14
                                      .copyWith(color: Colors.black)),
                              WidgetNumber(
                                controller: _childrenController,
                                maxNumber: 99,
                                doneEvent: (value) async {
                                  setState(() {
                                    numChild = value;
                                    registerModel.childrenNum = numChild;
                                    this.checkValidation();
                                  });
                                },
                              )
                            ],
                          )
                        ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() => SliverToBoxAdapter(
        child: WidgetBoxesContainer(
          hasLine: false,
          title: widget.params.title,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Container(
            width: double.infinity,
            color: Color(0xfff5f5f5),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Text(
                LocalizationsUtil.of(context)
                    .translate('please_fill_the_required_information_below'),
                style: AppFonts.medium14.copyWith(color: Color(0xff838383))),
          ),
        ),
      );

  Widget _buildInfo() {
    return SliverToBoxAdapter(
      child: WidgetBoxesContainer(
        title: 'personal_information',
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: <Widget>[
              _apartmentCodeBox(),
              Builder(builder: (
                context,
              ) {
                return BlocProvider<ProfileBloc>(
                    create: (context) =>
                        ProfileBloc(profileRepo: ProfileRepository()),
                    child: WidgetApartmentInfo());
              }),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    fApartment.controller.dispose();
    fSubmit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sizeSystem = MediaQuery.of(context).size;
    this.padding = sizeSystem.width * 5 / 100;

    return BaseScaffoldPresent(
        title: "facility_booking",
        body: SafeArea(
            child: Stack(children: <Widget>[
          GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: BlocProvider(
                create: (context) => apartmentBloc,
                child: BlocListener(
                    cubit: apartmentBloc,
                    listener: (context, apartmentState) async {
                      if (apartmentState is ApartmentLoading) {
                        progressToolkit.state.show();
                      }

                      if (apartmentState is ApartmentSuccessful) {
                        progressToolkit.state.dismiss();
                      }
                    },
                    child: Container(
                        color: Colors.white,
                        child: CustomScrollView(
                          physics: const BouncingScrollPhysics(),
                          slivers: [
                            _buildTitle(),
                            _buildInfo(),
                            _buildRegisterInfo(context),
                            _buildTerms(context),
                            SliverToBoxAdapter(
                                child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: padding, vertical: padding),
                                    child: ButtonWidget(
                                        defaultHintText:
                                            LocalizationsUtil.of(context)
                                                .translate('book_now'),
                                        controller: fSubmit,
                                        isActive: this.isActive,
                                        callback: () async {
                                          progressToolkit.state.show();

                                          final _registerModel =
                                              facilityRegistryResult(
                                                  registerModel);

                                          try {
                                            final result =
                                                await _facilityRepository
                                                    .sendOrder(_registerModel);
                                            if (result == true) {
                                              showSuccessfulDialog(context);
                                            }
                                          } catch (e) {
                                            if (<DioErrorType>[
                                              DioErrorType.DEFAULT,
                                              DioErrorType.CONNECT_TIMEOUT,
                                              DioErrorType.RECEIVE_TIMEOUT,
                                              DioErrorType.RESPONSE,
                                            ].contains(e.type)) {
                                              if (e.type ==
                                                  DioErrorType.RESPONSE) {
                                                DialogCustom.showErrorDialog(
                                                  context: context,
                                                  title:
                                                      'fail_to_register_facility',
                                                  errMsg:
                                                      'there_is_an_issue_please_try_again_later_0',
                                                  callback: () =>
                                                      Navigator.pop(context),
                                                );
                                              } else {
                                                DialogCustom.showErrorDialog(
                                                  context: context,
                                                  title: 'there_is_no_network',
                                                  errMsg:
                                                      'please_check_your_network_and_try_connect_again',
                                                  callback: () =>
                                                      Navigator.pop(context),
                                                );
                                              }
                                              setState(() {
                                                this.isActive = false;
                                                fSubmit.sink.add(
                                                    ButtonSubmitEvent(
                                                        this.isActive));
                                              });
                                            } else
                                              AppDialog.showAlertDialog(
                                                context,
                                                null,
                                                e.error.message,
                                              );
                                          } finally {
                                            progressToolkit.state.dismiss();
                                          }
                                        })))
                          ],
                        )))),
          ),
          progressToolkit
        ])));
  }

  void showSuccessfulDialog(
    BuildContext context,
  ) async {
    if (widget.params.callback != null) widget.params.callback(null);

    AppDialog.showContentDialog(
      context: context,
      child: Container(
        height: 310,
        padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SvgPicture.asset(AppVectors.ic_facility),
            const SizedBox(height: 15),
            Text(
                LocalizationsUtil.of(context).translate('booking_successfully'),
                textAlign: TextAlign.center,
                style: AppFonts.bold18),
            const SizedBox(height: 20),
            Text(
                LocalizationsUtil.of(context).translate(
                  "the_building_admin_will_confirm_your_booking_later",
                ),
                textAlign: TextAlign.center,
                style: AppFonts.regular15
                    .copyWith(color: Color(0xff808080))
                    .copyWith(
                        letterSpacing: 0.24,
                        fontFamily: AppFonts.font_family_display)),
            const SizedBox(height: 40),
            WidgetButton.pink(
              LocalizationsUtil.of(context).translate('done_0'),
              callback: () async {
                Navigator.of(context).popUntil(
                  (route) {
                    if (route.settings.name == AppRouter.FACILITY_DETAIL_PAGE) {
                      return true;
                    }
                    return false;
                  },
                );
              },
            )
          ],
        ),
      ),
      closeShow: false,
      barrierDismissible: true,
    );
  }
}
