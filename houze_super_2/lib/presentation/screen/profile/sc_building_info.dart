import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:houze_super/app/blocs/apartment/index.dart';
import 'package:houze_super/app/blocs/overlay/index.dart';
import 'package:houze_super/middle/model/apartment_model.dart';
import 'package:houze_super/middle/model/building_model.dart';
import 'package:houze_super/middle/repo/apartment_repository.dart';
import 'package:houze_super/presentation/base/route_aware_state.dart';
import 'package:houze_super/presentation/common_widgets/widget_cached_image.dart';
import 'package:houze_super/presentation/common_widgets/widget_tween_animation.dart';
import 'package:houze_super/presentation/screen/community/run/statistic/widget/summary_statistic_section_in_progress.dart';
import 'package:houze_super/presentation/screen/home/bloc/index.dart';

import 'package:houze_super/utils/custom_exceptions.dart';

import '../../index.dart';
import 'index.dart';

const String buildingInfoKey = 'buildingInfoKey';

class InfoArguments {
  final title;
  InfoArguments({this.title});
}

class BuildingInfoScreen extends StatefulWidget {
  final InfoArguments argument;
  BuildingInfoScreen({required this.argument});
  @override
  _BuildingInfoScreenState createState() => _BuildingInfoScreenState();
}

class _BuildingInfoScreenState extends RouteAwareState<BuildingInfoScreen> {
  // final OverlayBloc _overlayBloc = OverlayBloc();

  // final ApartmentBloc _apartmentBloc = ApartmentBloc(
  //   apartmentRepo: ApartmentRepository(),
  // );

  // final ApartmentDetailBloc _apartmentDetailBloc = ApartmentDetailBloc(
  //   apartmentRepo: ApartmentRepository(),
  // );

  // final TabbarTitleBloc tabbarBloc = TabbarTitleBloc();

  ApartmentRepository _repoApartment = ApartmentRepository();

  final StreamController<String> _titelTabController =
      StreamController<String>.broadcast();
  String _appBarTitle = "";
  int chipIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<OverlayBloc>().add(BuildingPicked());
    // context.read<ApartmentBloc>().add(ApartmentLoadList());
  }

  Stream<String> get _streamTitleTab => _titelTabController.stream;
  @override
  void dispose() {
    _titelTabController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TabbarTitleBloc, String>(
      listener: (context, state) {
        switch (state) {
          case "building":
            this._appBarTitle = "building_info";
            break;
          case "house":
            this._appBarTitle = "house_information";
            break;
          case "residential_area":
            this._appBarTitle = "residential_area_information";
            break;
        }
        _titelTabController.sink.add(_appBarTitle);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            title: StreamBuilder<String>(
                initialData: widget.argument.title,
                stream: _streamTitleTab,
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data?.isNotEmpty == true)
                    return Text(
                      LocalizationsUtil.of(context).translate(snapshot.data),
                      style: AppFonts.semibold18,
                    );

                  return CupertinoActivityIndicator();
                }),
            centerTitle: true,
            backgroundColor: Colors.white,
            elevation: 0.0,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )),
        body: SafeArea(
            child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: BlocBuilder<OverlayBloc, OverlayBlocState>(
            builder: (context, overlayState) {
              if (overlayState is BuildingFailure) return SomethingWentWrong();
              if (overlayState is PickBuildingSuccessful) {
                return Column(
                  children: [
                    _mainBuildingInfo(
                      context: context,
                      buildings: overlayState.buildings,
                      currentBuilding: overlayState.currentBuilding,
                    ),
                    _apartmentSection(overlayState.apartments),
                  ],
                );
              }
              return Padding(
                  padding: const EdgeInsets.all(20),
                  child: StatisticInProgress());
            },
          ),
        )),
      ),
    );
  }

  Widget _apartmentSection(List<ApartmentMessageModel?> apartments) {
    if (apartments.length > 0) {
      context
          .read<ApartmentDetailBloc>()
          .add(ApartmentGetDetail(id: apartments[chipIndex]?.id ?? ""));

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Wrap(
              spacing: 16.0,
              runSpacing: 8.0,
              children: apartments
                  .map(
                    (e) => ChoiceChip(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 10.0,
                      ),
                      label: Text(e?.name ?? ''),
                      selected: chipIndex == apartments.indexOf(e),
                      onSelected: (bool value) {
                        if (chipIndex != apartments.indexOf(e))
                          setState(() => chipIndex = apartments.indexOf(e));
                      },
                      labelStyle: chipIndex == apartments.indexOf(e)
                          ? AppFont.SEMIBOLD_PURPLE_6001d2_13
                          : AppFonts.semibold13.copyWith(
                              color: Color(
                                0xff838383,
                              ),
                            ),
                      selectedColor: AppColor.purple_f2e8ff,
                      backgroundColor: AppColor.gray_f5f5f5,
                    ),
                  )
                  .toList(),
            ),
          ),
          BlocBuilder<ApartmentDetailBloc, ApartmentState>(
            builder: (_, ApartmentState state) {
              if (state is ApartmentGetDetailSuccessful)
                return TweenAnimationWidget(
                  duration: Duration(milliseconds: 500),
                  widget: _apartmentDetailSection(
                    apartmentDetail: state.apartmentDetail,
                  ),
                );

              if (state is ApartmentFailure) {
                if (state.error.error is NoDataException)
                  return SomethingWentWrong(true);
                else
                  return SomethingWentWrong();
              }

              return Padding(
                padding: const EdgeInsets.all(40),
                child: Align(child: const SizedBox.shrink()),
              );
            },
          )
        ],
      );
    } else if (apartments.isEmpty)
      return Align(
        child: Text(
          LocalizationsUtil.of(context).translate('there_is_no_information'),
        ),
      );

    return SomethingWentWrong();
  }

  Column _apartmentDetailSection(
      {required ApartmentDetailModel apartmentDetail}) {
    final List<Field> fields = [
      Field(
        name: 'building_with_colon',
        value: apartmentDetail.building!.name!,
      ),
      Field(
        name: 'block_with_colon',
        value: apartmentDetail.block!.name!,
      ),
      Field(
        name: 'floor_with_colon',
        value: apartmentDetail.floor!.name!,
      ),
      Field(
        name: 'apartment_area_with_colon',
        value: apartmentDetail.area!,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Wrap(runSpacing: 8.0, children: [
            ...fields
                .map(
                  (e) => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FutureBuilder(
                        future: ServiceConverter.getTextToConvert(e.name),
                        builder: (context, snap) {
                          if (snap.connectionState == ConnectionState.waiting) {
                            return const SizedBox.shrink();
                          }
                          if (snap.hasData) {
                            return Text(
                              LocalizationsUtil.of(context)
                                  .translate(snap.data as String),
                              style: AppFont.MEDIUM.copyWith(
                                color: Color(0xff808080),
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                      Text(
                        e.value,
                        style: AppFonts.medium14,
                      ),
                    ],
                  ),
                )
                .toList(),
            FutureBuilder<ApartmentAccModel>(
              future: _repoApartment.getApartmentAccByID(
                  id: apartmentDetail.id ?? ''),
              builder: (BuildContext context,
                  AsyncSnapshot<ApartmentAccModel> snapshot) {
                if (snapshot.hasData) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        LocalizationsUtil.of(context).translate(
                            'amount_left_in_wallet'), // số tiền còn lại trong ví
                        style: AppFont.MEDIUM.copyWith(
                          color: Color(0xff808080),
                        ),
                      ),
                      Text('${StringUtil.numberFormat(snapshot.data?.total)}đ',
                          style: AppFonts.medium14),
                    ],
                  );
                }

                return Container();
              },
            ),
          ]),
        ),
        const DividerCustom(),
        _roomInfo(apartmentDetail: apartmentDetail),
        const DividerCustom(),
        _humanInfo(
          type: 'owner',
          users: apartmentDetail.owners!,
        ),
        const DividerCustom(),
        _humanInfo(
          type: 'tenant',
          users: apartmentDetail.renters!,
        ),
        const DividerCustom(),
        _humanInfo(
          type: 'resident',
          users: apartmentDetail.residents!,
        ),
      ],
    );
  }

  Container _roomInfo({required ApartmentDetailModel apartmentDetail}) {
    final List<_Room> _rooms = [
      _Room(
        name: 'bedrooms',
        quality: apartmentDetail.apartmentType!.bedrooms!,
        svgPath: AppVectors.singleBed,
      ),
      _Room(
        name: 'bathrooms',
        quality: apartmentDetail.apartmentType!.bathrooms!,
        svgPath: AppVectors.toilet,
      ),
      _Room(
        name: 'kitchens',
        quality: apartmentDetail.apartmentType!.kitchens!,
        svgPath: AppVectors.cook,
      ),
      _Room(
        name: 'balconies',
        quality: apartmentDetail.apartmentType!.balconies!,
        svgPath: AppVectors.balcony,
      ),
    ];
    return Container(
      margin: EdgeInsets.only(top: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text(
              apartmentDetail.apartmentType!.name!,
              style: AppFonts.bold18,
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Wrap(
              spacing: 10.0,
              children: _rooms
                  .map(
                    (e) => Column(
                      children: [
                        SizedBox(height: 16.0),
                        Container(
                          width: 96.0,
                          height: 96.0,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12.0,
                            vertical: 16.0,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(6.0),
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromRGBO(0, 0, 0, 0.1),
                                offset: Offset(0, 2.0),
                                blurRadius: 8.0,
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SvgPicture.asset(
                                    e.svgPath ?? '',
                                    width: 20.0,
                                    height: 20.0,
                                  ),
                                  Text(
                                    e.quality.toString(),
                                    style: AppFont.BOLD_PURPLE_7a1dff.copyWith(
                                      fontSize: 24,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 16.0),
                              Text(
                                LocalizationsUtil.of(context).translate(e.name),
                                style: AppFonts.semibold13.copyWith(
                                  color: Color(
                                    0xff838383,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 30.0),
                      ],
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Container _mainBuildingInfo({
    required List<BuildingMessageModel> buildings,
    required BuildingMessageModel currentBuilding,
    required BuildContext context,
  }) {
    return Container(
      margin: EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DecoratedBox(
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
            child: Padding(
              padding: const EdgeInsets.all(16.0).copyWith(bottom: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FutureBuilder(
                    future: ServiceConverter.getTextToConvert("building"),
                    builder: (context, snap) {
                      if (snap.connectionState == ConnectionState.waiting) {
                        return const Text("");
                      }
                      return Text(
                        LocalizationsUtil.of(context).translate(snap.data),
                        style: AppFonts.medium14,
                      );
                    },
                  ),
                  const SizedBox(height: 8.0),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.black, width: 1),
                      ),
                    ),
                    child: SizedBox(
                      height: 28.0,
                      child: TextButton(
                        onPressed: () {
                          SwitchBuilding.showBottomSheet(
                            contextParent: context,
                            buildings: buildings,
                            currentBuildingID: currentBuilding.id!,
                            setChipIndex: (value) => chipIndex = value,
                          );
                        },
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all<EdgeInsets>(
                              EdgeInsets.all(0)),
                          overlayColor: MaterialStateColor.resolveWith(
                              (states) => Colors.transparent),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              currentBuilding.name ?? '',
                              style: AppFonts.medium14,
                            ),
                            Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 30.0),
          Row(
            children: [
              DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xfff2f2f2), width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(14.0)),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(12.0)),
                    child: Stack(
                      clipBehavior: Clip.hardEdge,
                      children: <Widget>[
                        CachedImageWidget(
                          cacheKey: buildingInfoKey,
                          imgUrl: currentBuilding.company!.imageThumb!,
                          width: 60.0,
                          height: 60.0,
                        ),
                      ],
                    ),
                  )),
              const SizedBox(width: 16.0),
              Flexible(
                child: Text(
                  LocalizationsUtil.of(context)
                      .translate(currentBuilding.company!.name),
                  style: AppFonts.bold18,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _humanInfo(
      {required String type, required Iterable<UserListModel> users}) {
    return Padding(
      padding: const EdgeInsets.all(20).copyWith(bottom: 30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocalizationsUtil.of(context).translate(type),
            style: AppFonts.bold16,
          ),
          const SizedBox(height: 30.0),
          users.isNotEmpty
              ? Wrap(
                  runSpacing: 40.0,
                  children: users
                      .map(
                        (e) => Row(
                          children: [
                            CircleAvatar(
                              radius: 20.0,
                              child: SvgPicture.asset(
                                "assets/svg/gender/avt-${e.resident!.gender != null ? e.resident!.gender : 'O'}.svg",
                              ),
                            ),
                            const SizedBox(width: 10.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  e.resident!.fullname!,
                                  style: AppFonts.medium14,
                                ),
                                const SizedBox(height: 5.0),
                                Text('0${e.resident!.phoneNumber!}',
                                    style: AppFonts.semibold13.copyWith(
                                        color: Color(
                                            0xff838383)) //.SEMIBOLD_GRAY_838383_13,
                                    ),
                              ],
                            ),
                            Spacer(),
                            SizedBox(
                              width: 40.0,
                              height: 40.0,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColor.purple_f2e8ff,
                                ),
                                child: IconButton(
                                    padding: const EdgeInsets.all(0),
                                    icon: Icon(Icons.phone_in_talk),
                                    onPressed: () => Utils.makePhoneCall(
                                        url: '0${e.resident!.phoneNumber!}')),
                              ),
                            )
                          ],
                        ),
                      )
                      .toList(),
                )
              : Align(
                  child: Text(
                    LocalizationsUtil.of(context)
                        .translate('there_is_no_$type'),
                    style:
                        AppFonts.regular14.copyWith(color: Color(0xff838383)),
                  ),
                ),
        ],
      ),
    );
  }
}

class _Room {
  final String? name;
  final int? quality;
  final String? svgPath;

  _Room({this.name, this.quality, this.svgPath});
}

class AnimatedWidget extends StatelessWidget {
  final Widget widget;
  AnimatedWidget({required this.widget});
  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      curve: Curves.easeIn,
      duration: const Duration(milliseconds: 500),
      builder: (BuildContext context, double opacity, Widget? child) {
        return Opacity(opacity: opacity, child: widget);
      },
    );
  }
}
