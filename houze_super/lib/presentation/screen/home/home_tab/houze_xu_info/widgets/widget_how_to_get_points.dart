import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';

import 'package:houze_super/app/bloc/overlay/overlay_bloc.dart';
import 'package:houze_super/app/bloc/overlay/overlay_event.dart';
import 'package:houze_super/app/bloc/overlay/overlay_state.dart';
import 'package:houze_super/presentation/screen/home/bloc/index.dart';

import 'package:houze_super/middle/model/building_model.dart';

import 'package:houze_super/presentation/common_widgets/skeletons/src/skeleton/parking_image_card_skeleton.dart';
import 'package:houze_super/presentation/common_widgets/stateless/widget_something_went_wrong.dart';
import 'package:houze_super/presentation/screen/home/home_tab/widget_bottom_sheet_switch_building.dart';

import 'package:houze_super/utils/constants/constants.dart';
import 'package:houze_super/utils/localizations_util.dart';
import 'package:houze_super/utils/string_util.dart';
import 'package:houze_super/utils/custom_exceptions.dart';
import 'package:houze_super/presentation/screen/home/home_tab/houze_xu_info/bloc/houze_xu_bloc.dart';

const ICON_SIZE = 45.0;

class FilterActionType {
  String type;
  String content;
  FilterActionType({this.type, this.content});
}

class WidgetHowToGetPoint extends StatefulWidget {
  final bool disabledChangeBuilding;
  final Function(bool) callback;
  WidgetHowToGetPoint(
      {this.disabledChangeBuilding = false, @required this.callback});

  @override
  _WidgetHowToGetPointState createState() => _WidgetHowToGetPointState();
}

class _WidgetHowToGetPointState extends State<WidgetHowToGetPoint> {
  final OverlayBloc overlayBloc = OverlayBloc();
  final TabbarTitleBloc tabbarBloc = TabbarTitleBloc();
  final HouzeXuBloc houzeXuBloc = HouzeXuBloc();

  String _currentBuildingId = '';

  //Service converter
  static Future<String> serviceConverter() {
    final service = ServiceConverter.convertTypeBuilding("building");
    return service;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody(context);
  }

  _buildBody(BuildContext parentCtx) {
    final double imageWidth = (MediaQuery.of(parentCtx).size.width / 100) * 65;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(top: 5),
      child: Column(children: [
        Expanded(
          child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            return Container(
                height: constraints.maxHeight,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 17, horizontal: 20),
                          color: Color(0xfff5f5f5),
                          child: Text(
                            LocalizationsUtil.of(context).translate(
                                'quickly_earn_houze_xu_to_deduct_fee_payment_as_well_as_redeem_attractive_offers'),
                            style: AppFonts.medium14
                                .copyWith(
                                  color: Color(0xff808080),
                                )
                                .copyWith(letterSpacing: 0.14),
                          )),
                      MultiBlocProvider(
                        providers: <BlocProvider>[
                          BlocProvider<OverlayBloc>(create: (_) => overlayBloc),
                          BlocProvider<TabbarTitleBloc>(
                              create: (_) => tabbarBloc),
                          BlocProvider<HouzeXuBloc>(create: (_) => houzeXuBloc)
                        ],
                        child: BlocBuilder<OverlayBloc, OverlayBlocState>(
                          builder: (_, OverlayBlocState overlayState) {
                            if (overlayState is AppInitial)
                              overlayBloc.add(BuildingPicked());

                            if (overlayState is BuildingFailure &&
                                overlayState.error.error
                                    is! NoDataToLoadMoreException) {
                              if (overlayState.error.error is NoDataException)
                                return SomethingWentWrong(true);
                              else
                                return SomethingWentWrong();
                            }

                            if (overlayState is PickBuildingSuccessful) {
                              if (overlayState.currentBuilding.id !=
                                  _currentBuildingId) {
                                houzeXuBloc.add(GetHouzeXu(
                                    buildingId:
                                        overlayState.currentBuilding.id));
                              }

                              _currentBuildingId =
                                  overlayState.currentBuilding.id;

                              return Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 20,
                                    ),
                                    child: _pickBuilding(
                                      buildings: overlayState.buildings,
                                      currentBuilding:
                                          overlayState.currentBuilding,
                                      context: _,
                                      disabled: widget.disabledChangeBuilding,
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      SvgPicture.asset(
                                        AppVectors.point_graphic,
                                        width:
                                            imageWidth > 195 ? 195 : imageWidth,
                                      ),
                                      Container(
                                        child: BlocBuilder<HouzeXuBloc,
                                                HouzeXuState>(
                                            builder: (BuildContext context,
                                                HouzeXuState _houzeXuState) {
                                          print(_houzeXuState);
                                          if (_houzeXuState == null) {
                                            return Center(
                                                child: Text(LocalizationsUtil
                                                        .of(context)
                                                    .translate(
                                                        "lost_connection")));
                                          }

                                          if (_houzeXuState
                                              is HouzeXuSuccessful) {
                                            return Container(
                                              padding: const EdgeInsets.all(20),
                                              margin: const EdgeInsets.only(
                                                  left: 40.0, right: 40.0),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Color(0xffdcdcdc)),
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              child: Column(
                                                children: [
                                                  houzeXuItem(
                                                    amount: _houzeXuState
                                                        .houzeXu
                                                        .ticketCreatedAward,
                                                    imagePath:
                                                        AppVectors.icIssue,
                                                    title: 'send_a_request',
                                                  ),
                                                  houzeXuItem(
                                                    amount: _houzeXuState
                                                        .houzeXu
                                                        .ticketRatingAward,
                                                    imagePath: AppVectors
                                                        .ic_rating_medium,
                                                    title: 'start_review',
                                                  ),
                                                  houzeXuItem(
                                                    amount: _houzeXuState
                                                        .houzeXu
                                                        .feeBankTransferAward,
                                                    imagePath:
                                                        AppVectors.icBank,
                                                    title: 'bank_transfer',
                                                  ),
                                                ],
                                              ),
                                            );
                                          }

                                          if (_houzeXuState is HouzeXuLoading) {
                                            return Container(
                                              padding: const EdgeInsets.all(20),
                                              margin: const EdgeInsets.only(
                                                  left: 40.0, right: 40.0),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Color(0xffdcdcdc)),
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              child: Column(
                                                children: [
                                                  houzeXuItemLoading(),
                                                  houzeXuItemLoading(),
                                                  houzeXuItemLoading(),
                                                ],
                                              ),
                                            );
                                          }

                                          return const SizedBox.shrink();
                                        }),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(40.0),
                                        child: Text(
                                          LocalizationsUtil.of(context).translate(
                                              "note_houze_xu_bonus_level_is_subject_to_change_from_time_to_time_until_further_notice"),
                                          style: AppFonts.medium14.copyWith(
                                              letterSpacing: 0.14,
                                              color: Color(0xff808080)),
                                          textAlign: TextAlign.center,
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              );
                            }

                            return Container(
                              margin: const EdgeInsets.only(top: 30),
                              child:
                                  Center(child: CupertinoActivityIndicator()),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ));
          }),
        )
      ]),
    );
  }

  Widget houzeXuItem({int amount, String imagePath, String title}) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: SvgPicture.asset(
              imagePath,
              width: ICON_SIZE,
              height: ICON_SIZE,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LocalizationsUtil.of(context).translate(title),
                  style: AppFonts.semibold13
                      .copyWith(color: Color(0xff6001d2))
                      .copyWith(letterSpacing: 0.14),
                ),
                const SizedBox(
                  height: 5.0,
                ),
                Row(children: [
                  RichText(
                    maxLines: 2,
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                            text: LocalizationsUtil.of(context)
                                .translate('get_it_now'),
                            style: AppFonts.semibold.copyWith(fontSize: 15)),
                        TextSpan(
                          text: ' ${StringUtil.numberFormat(amount)}',
                          style: AppFonts.semibold13
                              .copyWith(color: Color(0xffd68100))
                              .copyWith(fontSize: 15),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 5.0,
                  ),
                  SvgPicture.asset(AppVectors.icPoint),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget houzeXuItemLoading() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        children: [
          ParkingCardSkeleton(width: ICON_SIZE, height: ICON_SIZE),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ParkingCardSkeleton(width: 200, height: 16),
                const SizedBox(
                  height: 5.0,
                ),
                ParkingCardSkeleton(width: 400, height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Column _pickBuilding(
      {@required List<BuildingMessageModel> buildings,
      @required BuildingMessageModel currentBuilding,
      @required BuildContext context,
      bool disabled = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16.0).copyWith(bottom: 20.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.1),
                offset: Offset(0, 2.0),
                blurRadius: 10.0,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder(
                  future: serviceConverter(),
                  builder: (context, snap) {
                    if (snap.connectionState == ConnectionState.waiting) {
                      return const SizedBox.shrink();
                    }
                    return Text(
                      LocalizationsUtil.of(context).translate(snap.data),
                      style: AppFonts.medium,
                    );
                  }),
              const SizedBox(height: 8.0),
              SizedBox(
                height: 28.0,
                child: FlatButton(
                  onPressed: () {
                    if (!disabled) {
                      widget.callback(true);
                      SwitchBuilding.showBottomSheet(
                        contextParent: context,
                        buildings: buildings,
                        currentBuildingID: currentBuilding.id,
                      );
                    }
                  },
                  padding: const EdgeInsets.all(0),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: UnderlineInputBorder(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        currentBuilding.name,
                        style: AppFonts.medium,
                      ),
                      if (!disabled)
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.black,
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
