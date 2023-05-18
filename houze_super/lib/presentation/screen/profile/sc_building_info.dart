import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:houze_super/app/bloc/apartment/index.dart';
import 'package:houze_super/app/bloc/apartment/apartment_state.dart';
import 'package:houze_super/app/bloc/overlay/index.dart';
import 'package:houze_super/middle/model/apartment_model.dart';
import 'package:houze_super/middle/model/building_model.dart';
import 'package:houze_super/middle/repo/apartment_repository.dart';
import 'package:houze_super/presentation/common_widgets/stateless/widget_cached_image.dart';
import 'package:houze_super/presentation/common_widgets/stateless/widget_home_scaffold.dart';
import 'package:houze_super/presentation/common_widgets/stateless/widget_something_went_wrong.dart';
import 'package:houze_super/presentation/screen/home/bloc/index.dart';
import 'package:houze_super/presentation/screen/home/home_tab/widget_bottom_sheet_switch_building.dart';
import 'package:houze_super/utils/custom_exceptions.dart';
import 'package:houze_super/utils/index.dart';
import '../../index.dart';
import 'index.dart';

const String buildingInfoKey = 'buildingInfoKey';

class InfoArguments {
  final title;
  InfoArguments({this.title});
}

class BuildingInfoScreen extends StatefulWidget {
  final InfoArguments argument;
  BuildingInfoScreen({this.argument});
  @override
  _BuildingInfoScreenState createState() => _BuildingInfoScreenState();
}

class _BuildingInfoScreenState extends State<BuildingInfoScreen> {
  final OverlayBloc _overlayBloc = OverlayBloc();

  final ApartmentBloc _apartmentBloc = ApartmentBloc(
    apartmentRepo: ApartmentRepository(),
  );

  final ApartmentDetailBloc _apartmentDetailBloc = ApartmentDetailBloc(
    apartmentRepo: ApartmentRepository(),
  );

  final TabbarTitleBloc tabbarBloc = TabbarTitleBloc();

  int chipIndex = 0;
  String _appBarTitle = "";

  @override
  void initState() {
    super.initState();
    _apartmentBloc.add(ApartmentLoadList());
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: <BlocProvider>[
          BlocProvider<OverlayBloc>(create: (_) => _overlayBloc),
          BlocProvider<ApartmentBloc>(create: (_) => _apartmentBloc),
          BlocProvider<ApartmentDetailBloc>(
            create: (_) => _apartmentDetailBloc,
          ),
          BlocProvider<TabbarTitleBloc>(create: (_) => tabbarBloc),
        ],
        child: BlocListener<TabbarTitleBloc, String>(
            listener: (context, state) {
              if (state is String) {
                setState(() {
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
                });
              }
            },
            child: HomeScaffold(
              title: this._appBarTitle.length > 0
                  ? this._appBarTitle
                  : widget.argument.title,
              child: BlocBuilder<OverlayBloc, OverlayBlocState>(
                builder: (_, OverlayBlocState overlayState) {
                  if (overlayState is AppInitial)
                    _overlayBloc.add(BuildingPicked());

                  if (overlayState is PickBuildingSuccessful) {
                    return SingleChildScrollView(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Column(
                        children: [
                          _mainBuildingInfo(
                            context: _,
                            buildings: overlayState.buildings,
                            currentBuilding: overlayState.currentBuilding,
                          ),
                          BlocBuilder<ApartmentBloc,
                              List<ApartmentMessageModel>>(
                            builder:
                                (_, List<ApartmentMessageModel> apartments) =>
                                    _apartmentSection(apartments),
                          ),
                        ],
                      ),
                    );
                  }

                  if (overlayState is BuildingFailure)
                    return SomethingWentWrong();

                  return Padding(
                    padding: const EdgeInsets.all(30),
                    child: Align(child: CupertinoActivityIndicator()),
                  );
                },
              ),
            )));
  }

  Widget _apartmentSection(List<ApartmentMessageModel> apartments) {
    if (apartments.isNotEmpty) {
      _apartmentDetailBloc
          .add(ApartmentGetDetail(id: apartments[chipIndex].id));

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
                      label: Text(e.name),
                      selected: chipIndex == apartments.indexOf(e),
                      onSelected: (bool value) {
                        if (chipIndex != apartments.indexOf(e))
                          setState(() => chipIndex = apartments.indexOf(e));
                      },
                      labelStyle: chipIndex == apartments.indexOf(e)
                          ? AppFonts.semibold13.copyWith(
                              color: Color(0xff6001d2),
                            )
                          : AppFonts.semibold13.copyWith(
                              color: Color(0xff838383),
                            ),
                      selectedColor: Color(0xfff2e8ff),
                      backgroundColor: Color(0xfff5f5f5),
                    ),
                  )
                  .toList(),
            ),
          ),
          BlocBuilder<ApartmentDetailBloc, ApartmentState>(
            builder: (_, ApartmentState state) {
              if (state is ApartmentGetDetailSuccessful)
                return AnimatedWidget(
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
                child: Align(child: CupertinoActivityIndicator()),
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
      {@required ApartmentDetailModel apartmentDetail}) {
    final List<Field> fields = [
      Field(
        name: 'building_with_colon',
        value: apartmentDetail.building.name,
      ),
      Field(
        name: 'block_with_colon',
        value: apartmentDetail.block.name,
      ),
      Field(
        name: 'floor_with_colon',
        value: apartmentDetail.floor.name,
      ),
      Field(
        name: 'apartment_area_with_colon',
        value: apartmentDetail.area,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Wrap(
            runSpacing: 8.0,
            children: fields
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
                          return Text(
                            LocalizationsUtil.of(context).translate(snap.data),
                            style: AppFonts.medium
                                .copyWith(color: Color(0xff808080)),
                          );
                        },
                      ),
                      Text(
                        e.value,
                        style: AppFonts.medium,
                      ),
                    ],
                  ),
                )
                .toList(),
          ),
        ),
        const DividerCustom(),
        _roomInfo(apartmentDetail: apartmentDetail),
        const DividerCustom(),
        _humanInfo(
          type: 'owner',
          users: apartmentDetail.owners,
        ),
        const DividerCustom(),
        _humanInfo(
          type: 'tenant',
          users: apartmentDetail.renters,
        ),
        const DividerCustom(),
        _humanInfo(
          type: 'resident',
          users: apartmentDetail.residents,
        ),
      ],
    );
  }

  Container _roomInfo({@required ApartmentDetailModel apartmentDetail}) {
    final List<_Room> _rooms = [
      _Room(
        name: 'bedrooms',
        quality: apartmentDetail.apartmentType.bedrooms,
        svgPath: AppVectors.singleBed,
      ),
      _Room(
        name: 'bathrooms',
        quality: apartmentDetail.apartmentType.bathrooms,
        svgPath: AppVectors.toilet,
      ),
      _Room(
        name: 'kitchens',
        quality: apartmentDetail.apartmentType.kitchens,
        svgPath: AppVectors.cook,
      ),
      _Room(
        name: 'balconies',
        quality: apartmentDetail.apartmentType.balconies,
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
              apartmentDetail.apartmentType.name,
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
                        const SizedBox(height: 16.0),
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
                                    e.svgPath,
                                    width: 20.0,
                                    height: 20.0,
                                  ),
                                  Text(
                                    e.quality.toString(),
                                    style: AppFonts.bold
                                        .copyWith(color: Color(0xff7A1DFF))
                                        .copyWith(
                                          fontSize: 24,
                                        ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16.0),
                              Text(
                                LocalizationsUtil.of(context).translate(e.name),
                                style: AppFonts.semibold13.copyWith(
                                  color: Color(0xff838383),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30.0),
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
    @required List<BuildingMessageModel> buildings,
    @required BuildingMessageModel currentBuilding,
    @required BuildContext context,
  }) {
    return Container(
      margin: EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 30.0),
      child: Column(
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
                    future: ServiceConverter.getTextToConvert("building"),
                    builder: (context, snap) {
                      if (snap.connectionState == ConnectionState.waiting) {
                        return const Text("");
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
                      SwitchBuilding.showBottomSheet(
                        contextParent: context,
                        buildings: buildings,
                        apartmentBloc: _apartmentBloc,
                        currentBuildingID: currentBuilding.id,
                        setChipIndex: (value) => chipIndex = value,
                      );
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
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 30.0),
          Row(
            children: [
              Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xfff2f2f2), width: 2.0),
                    borderRadius: BorderRadius.all(Radius.circular(14.0)),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(12.0)),
                    child: Stack(
                      overflow: Overflow.clip,
                      children: <Widget>[
                        CachedImageWidget(
                          cacheKey: buildingInfoKey,
                          imgUrl: currentBuilding.company?.imageThumb,
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
                      .translate(currentBuilding.company.name),
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
      {@required String type, @required Iterable<UserListModel> users}) {
    return Padding(
      padding: const EdgeInsets.all(20).copyWith(bottom: 30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocalizationsUtil.of(context).translate(type),
            style: AppFonts.bold.copyWith(fontSize: 16),
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
                                "assets/svg/gender/avt-${e.resident.gender != null ? e.resident.gender : 'O'}.svg",
                              ),
                            ),
                            const SizedBox(width: 10.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  e.resident.fullname,
                                  style: AppFonts.medium,
                                ),
                                const SizedBox(height: 5.0),
                                Text(
                                  '0${e.resident.phoneNumber}',
                                  style: AppFonts.semibold13.copyWith(
                                    color: Color(0xff838383),
                                  ),
                                ),
                              ],
                            ),
                            Spacer(),
                            Container(
                              width: 40.0,
                              height: 40.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xfff2e8ff),
                              ),
                              child: IconButton(
                                  padding: const EdgeInsets.all(0),
                                  icon: Icon(Icons.phone_in_talk),
                                  onPressed: () => Utils.makePhoneCall(
                                      phone: '0${e.resident.phoneNumber}')),
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
                    style: AppFonts.regular.copyWith(color: Color(0xff808080)),
                  ),
                ),
        ],
      ),
    );
  }
}

class _Room {
  final String name;
  final int quality;
  final String svgPath;

  _Room({this.name, this.quality, this.svgPath});
}

class AnimatedWidget extends StatelessWidget {
  final Widget widget;
  AnimatedWidget({@required this.widget});
  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      curve: Curves.easeIn,
      duration: const Duration(milliseconds: 500),
      builder: (BuildContext context, double opacity, Widget child) {
        return Opacity(opacity: opacity, child: widget);
      },
    );
  }
}
