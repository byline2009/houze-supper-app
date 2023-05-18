import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:houze_super/app/bloc/overlay/overlay_bloc.dart';
import 'package:houze_super/app/bloc/overlay/overlay_event.dart';
import 'package:houze_super/app/bloc/overlay/overlay_state.dart';

import 'package:houze_super/middle/model/building_model.dart';

import 'package:houze_super/presentation/common_widgets/stateless/widget_something_went_wrong.dart';
import 'package:houze_super/presentation/screen/home/bloc/index.dart';
import 'package:houze_super/presentation/screen/home/home_tab/widget_bottom_sheet_switch_building.dart';
import 'package:houze_super/presentation/screen/profile/point/widget_point_transaction_history.dart';
import 'package:houze_super/presentation/common_widgets/houze_point/widget_points_info.dart';

import 'package:houze_super/utils/constants/constants.dart';
import 'package:houze_super/utils/custom_exceptions.dart';
import 'package:houze_super/utils/localizations_util.dart';

import '../../app_router.dart';

//---SCREEN: Houze Xu---//

class HouseXuScreen extends StatefulWidget {
  @override
  _HouseXuScreenState createState() => _HouseXuScreenState();
}

class _HouseXuScreenState extends State<HouseXuScreen> {
  final OverlayBloc overlayBloc = OverlayBloc();
  // ignore: close_sinks
  final TabbarTitleBloc tabbarBloc = TabbarTitleBloc();
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
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Column(
        children: [
          WidgetXuInfo(
              textContent: LocalizationsUtil.of(context)
                  .translate('learn_how_to_earn_houze_points'),
              callback: () {
                overlayBloc.add(BuildingPicked());
              }),
          Expanded(
            child: MultiBlocProvider(
              providers: <BlocProvider>[
                BlocProvider<OverlayBloc>(create: (_) => overlayBloc),
                BlocProvider<TabbarTitleBloc>(create: (_) => tabbarBloc),
              ],
              child: BlocBuilder<OverlayBloc, OverlayBlocState>(
                builder: (_, OverlayBlocState overlayState) {
                  if (overlayState is AppInitial)
                    overlayBloc.add(BuildingPicked());

                  if (overlayState is BuildingFailure &&
                      overlayState.error.error is! NoDataToLoadMoreException) {
                    if (overlayState.error.error is NoDataException)
                      return SomethingWentWrong(true);
                    else
                      return SomethingWentWrong();
                  }

                  if (overlayState is PickBuildingSuccessful) {
                    return WidgetPointHistory(
                      header: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 30,
                        ),
                        child: _pickBuilding(
                          buildings: overlayState.buildings,
                          currentBuilding: overlayState.currentBuilding,
                          context: _,
                        ),
                      ),
                      physics: const BouncingScrollPhysics(),
                    );
                  }

                  return Center(child: CupertinoActivityIndicator());
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  Column _pickBuilding({
    @required List<BuildingMessageModel> buildings,
    @required BuildingMessageModel currentBuilding,
    @required BuildContext context,
  }) {
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
                    SwitchBuilding.showBottomSheet(
                      contextParent: context,
                      buildings: buildings,
                      currentBuildingID: currentBuilding.id,
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
              ),
            ],
          ),
        ),
      ],
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: Text(
        'Houze Xu',
        style: AppFonts.semibold18, //semibold18,
      ),
      centerTitle: true,
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 20.0),
          child: IconButton(
            iconSize: 40.0,
            icon: SvgPicture.asset(
              "assets/svg/profile/ic-voucher-xu.svg",
              width: 40.0,
              height: 40.0,
            ),
            onPressed: () {
              AppRouter.pushNoParams(context, AppRouter.VOUCHER_LIST_PAGE);
            },
          ),
        ),
      ],
    );
  }
}
