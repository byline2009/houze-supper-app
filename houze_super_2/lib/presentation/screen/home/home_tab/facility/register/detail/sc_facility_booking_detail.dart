import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:houze_super/domain/index.dart';
import 'package:houze_super/middle/local/storage.dart';
import 'package:houze_super/middle/model/facility/index.dart';
import 'package:houze_super/presentation/base/route_aware_state.dart';
import 'package:houze_super/presentation/common_widgets/translator_vi_to_en.dart';
import 'package:houze_super/presentation/common_widgets/widget_status_tag.dart';
import 'package:houze_super/presentation/custom_ui/widget_scaffold_presentation.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/presentation/screen/base/base_widget.dart';
import 'package:houze_super/utils/custom_exceptions.dart';
import 'package:houze_super/utils/firebase_analytic/firebase_analytics.dart';

class FacilityBookingDetailScreenArgument {
  final String id;
  const FacilityBookingDetailScreenArgument({required this.id});
}

class FacilityBookingDetailScreen extends StatefulWidget {
  final FacilityBookingDetailScreenArgument args;
  FacilityBookingDetailScreen({Key? key, required this.args}) : super(key: key);

  @override
  FacilityBookingDetailScreenState createState() =>
      FacilityBookingDetailScreenState();
}

class FacilityBookingDetailScreenState
    extends RouteAwareState<FacilityBookingDetailScreen> {
  FacilityBookingDetailModel? model;
  final _facilityBloc = FacilityBloc();
  var locale = Locale('vi', 'VN');
  //Service converter
  late Future<String> service;
  @override
  void initState() {
    //Firebase Analytics
    GetIt.instance<FBAnalytics>()
        .sendEventViewRecentlyBooking(userID: Storage.getUserID() ?? "");
    //Service converter
    service = ServiceConverter.convertTypeBuilding("apartment_with_colon");
    super.initState();
  }

  Widget _buildInfoRow(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 10.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(LocalizationsUtil.of(context).translate(title),
              style: AppFonts.regular14.copyWith(
                color: Color(
                  0xff808080,
                ),
              )),
          Text(content, style: AppFonts.medium14),
        ],
      ),
    );
  }

  Widget _bottomTerms() {
    return GestureDetector(
      onTap: () {
        AppRouter.pushDialog(context, AppRouter.FACILITY_TERMS_PAGE,
            FacilityTermScreenArgument(id: model!.facility!.id!));
      },
      child: Container(
        height: 100,
        decoration:
            BaseWidget.dividerTop(height: 5, color: AppColor.gray_f5f5f5),
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
                style: AppFont.BOLD_PURPLE_7a1dff_14)
          ],
        ),
        margin: EdgeInsets.only(top: 20),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      ),
    );
  }

  Widget _buildBodySection(BuildContext context) {
    final getLanguage = Storage.getLanguage();
    final countryCode = {
      "en": "US",
      "vi": "VN",
      "zh": "CN",
      "ko": "KR",
      "ja": "JP",
    };
    locale = Locale(getLanguage.locale!, countryCode[getLanguage.locale]);

    return BlocProvider<FacilityBloc>(
      create: (_) => _facilityBloc,
      child: BlocBuilder<FacilityBloc, FacilityState>(builder: (
        BuildContext context,
        FacilityState facilityState,
      ) {
        if (facilityState is FacilityInitial) {
          _facilityBloc.add(FacilityGetBookingDetailEvent(id: widget.args.id));
        }

        if (facilityState is FacilityFailureState) {
          if (facilityState.error.error is NoDataException)
            return SomethingWentWrong(true);
          else
            return SomethingWentWrong();
        }

        if (facilityState is GetFacilityBookingDetailSuccess) {
          model = facilityState.result;
          return ListView(children: [
            Container(
                color: AppColor.gray_f5f7f8,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        LocalizationsUtil.of(context)
                            .translate('registration_date_with_colon'),
                        style: AppFonts.medium14.copyWith(
                          color: Color(
                            0xff5B00E4,
                          ),
                        ),
                      ),
                      Text(
                          DateUtil.format(
                              "dd/MM/yyyy - HH:mm ", "${model!.created!}"),
                          style: AppFonts.medium14.copyWith(
                            color: Color(
                              0xff5B00E4,
                            ),
                          )),
                    ])),
            SectionBookingStatusTag(status: model!.status!),

            //Check null and blank of note
            model?.note == null
                ? SizedBox.shrink()
                : model!.note == ""
                    ? SizedBox.shrink()
                    : Column(
                        children: <Widget>[
                          Container(
                            width: 1000.0,
                            padding: const EdgeInsets.all(15.0),
                            margin: EdgeInsets.only(
                              top: 20.0,
                              left: 20.0,
                              right: 20.0,
                            ),
                            decoration: BoxDecoration(
                              color: Color(0xfff5f7f8),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                            child: Text(model!.note!),
                          ),
                          //Detect language to show the translate button
                          getLanguage.name !=
                                  LocalizationsUtil.of(context)
                                      .translate('vietnamese')
                              ? TranslatorViToEn(
                                  model!.note!, getLanguage.locale!)
                              : SizedBox.shrink(),
                        ],
                      ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    LocalizationsUtil.of(context)
                        .translate("personal_information"),
                    style: AppFonts.bold16,
                  ),
                  SizedBox(height: 5.0),
                  _buildInfoRow(
                      "full_name_with_colon_1", model!.resident!.fullname!),
                  FutureBuilder(
                    future: service, //service converter
                    builder: (context, dynamic snap) {
                      if (snap.connectionState == ConnectionState.waiting) {
                        return SizedBox.shrink();
                      }
                      return _buildInfoRow(snap.data, model!.apartment!.name!);
                    },
                  ),
                  _buildInfoRow("phone_number_with_colon",
                      "${model!.resident!.phoneNumber!}"),
                  SizedBox(height: 10),
                ],
              ),
            ),
            Container(
              height: 5.0,
              decoration: BoxDecoration(color: AppColor.gray_f5f5f5),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    LocalizationsUtil.of(context)
                        .translate("facility_information"),
                    style: AppFonts.bold16,
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  _buildInfoRow("type_of_facility", model!.facility!.title!),
                  _buildInfoRow("booking_date_with_colon",
                      "${model!.startTime} - ${model!.endTime}, ${DateUtil.format("dd/MM/yyyy", model!.date!)}"),
                  _buildInfoRow(
                      "location_with_colon", model!.facilitySlot!.name!),
                  _buildInfoRow(
                      "no_of_adults_with_colon_0", model!.adultsNum.toString()),
                  _buildInfoRow("no_of_children_with_colon_0",
                      model!.childrenNum.toString()),
                  //Check null and blank of description
                  model?.description == null
                      ? Container()
                      : model!.description == ""
                          ? Container()
                          : Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                          LocalizationsUtil.of(context)
                                              .translate("note_with_colon"),
                                          style: AppFonts.regular14.copyWith(
                                            color: Color(
                                              0xff808080,
                                            ),
                                          ))),
                                  SizedBox(height: 10.0),
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        color: Color(0xffeeeeee),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0))),
                                    child: Text(
                                      '" ${model!.description} "',
                                      style: AppFonts.medium14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                ],
              ),
            ),
            _bottomTerms()
          ]);
        }

        return Align(child: CupertinoActivityIndicator());
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffoldPresent(
        title: "register",
        body: Stack(children: <Widget>[
          Positioned(child: _buildBodySection(context)),
        ]));
  }
}
