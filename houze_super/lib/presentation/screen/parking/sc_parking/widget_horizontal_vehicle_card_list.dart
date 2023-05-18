import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:houze_super/presentation/common_widgets/skeletons/src/skeleton/card_horizontal_skeleton.dart';
import 'package:houze_super/presentation/screen/parking/bloc/parking_bloc.dart';
import 'package:houze_super/presentation/screen/parking/bloc/parking_state.dart';
import 'package:houze_super/presentation/screen/parking/sc_parking/widget_vehicle_card_item.dart';
import 'package:houze_super/utils/custom_exceptions.dart';

import '../../../index.dart';

class HorizontalVehicleCardList extends StatefulWidget {
  const HorizontalVehicleCardList();

  @override
  _HorizontalVehicleCardListState createState() =>
      _HorizontalVehicleCardListState();
}

class _HorizontalVehicleCardListState extends State<HorizontalVehicleCardList> {
  PageController pageController;
  @override
  void initState() {
    super.initState();

    pageController = PageController(initialPage: 0, viewportFraction: 0.8);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 40),
      height: 180.0,
      child: BlocBuilder<ParkingVehicleBloc, ParkingVehicleState>(
          builder: (_, ParkingVehicleState vehicleState) {
        if (vehicleState is ParkingVehicleGetListFailure) {
          if (vehicleState.error.error is NoDataException)
            return SomethingWentWrong(true);
          else
            return SomethingWentWrong();
        }

        if (vehicleState is ParkingVehicleGetListSuccessful) {
          if (vehicleState.parkingVehicles.isEmpty) {
            return Column(children: <Widget>[
              SvgPicture.asset(AppVectors.large_parking,
                  width: 80.0, height: 80.0),
              const SizedBox(height: 16.0),
              Text(
                  LocalizationsUtil.of(context)
                      .translate('you_don\'t_have_a_parking_card'),
                  style: AppFonts.regular15.copyWith(
                    color: Color(0xff838383),
                  )),
            ]);
          }
          return PageView.builder(
            controller: pageController,
            physics: const BouncingScrollPhysics(),
            itemCount: vehicleState.parkingVehicles.length,
            itemBuilder: (_, i) {
              return VehicleCardItem(item: vehicleState.parkingVehicles[i]);
            },
          );
        }
        final double _width = (AppConstant.screenWidth * 295) / 375;

        return Padding(
          padding:const EdgeInsets.only(left: 20),
          child: CardListHorizontalSkeleton(
              length: 2,
              width: _width,
              shrinkWrap: true,
              config: SkeletonConfig(
                  isCircleAvatar: true,
                  isShowAvatar: true,
                  theme: SkeletonTheme.Light,
                  bottomLinesCount: 0,
                  radius: 0.0)),
        );
      }),
    );
  }
}
