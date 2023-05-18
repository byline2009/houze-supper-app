import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:houze_super/middle/model/apartment_model.dart';
import 'package:houze_super/middle/model/parking_vehicle_model.dart';
import 'package:houze_super/presentation/common_widgets/stateless/widget_slide_animation.dart';
import 'package:houze_super/presentation/screen/parking/bloc/parking_bloc.dart';
import 'package:houze_super/presentation/screen/parking/bloc/parking_event.dart';
import 'package:houze_super/presentation/screen/parking/bloc/parking_state.dart';
import 'package:houze_super/utils/custom_exceptions.dart';

import '../../../app_router.dart';
import '../../../index.dart';
import 'widget_register_pending_vehicle_card.dart';

class VerticalRegisterVehicleList extends StatelessWidget {
  final ApartmentMessageModel apartment;
  const VerticalRegisterVehicleList({@required this.apartment});

  @override
  Widget build(BuildContext context) {
    List<ParkingVehicle> _parkingBookingHistories = [];

    return BlocBuilder<ParkingHistoryBookingBloc, ParkingHistoryBookingState>(
        builder: (_, ParkingHistoryBookingState bookingState) {
      if (bookingState is ParkingHistoryBookingInitial) {
        BlocProvider.of<ParkingHistoryBookingBloc>(context).add(
            ParkingHistoryBookingGetList(
                params: {'apartment_id': apartment.id}));
      }
      if (bookingState is ParkingHistoryBookingGetListFailure) {
        if (bookingState.error.error is NoDataException)
          return SomethingWentWrong(true);
        else
          return SomethingWentWrong();
      }

      if (bookingState is ParkingHistoryBookingGetListSuccessful) {
        if (bookingState.parkingBookingHistories.isEmpty) {
          return const SizedBox.shrink();
        }
        _parkingBookingHistories = bookingState.parkingBookingHistories
          ..removeWhere((e) => e.status == 1);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Text(
                LocalizationsUtil.of(context).translate('pending_registration'),
                style: AppFonts.bold18,
              ),
            ),
            const SizedBox(height: 20.0),
            ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.all(0),
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _parkingBookingHistories.length,
              itemBuilder: (BuildContext context, int index) {
                final ParkingVehicle item = _parkingBookingHistories[index];

                return GestureDetector(
                  onTap: () {
                    AppRouter.push(context, AppRouter.PARKING_DETAIL, item);
                  },
                  child: WidgetSlideAnimation(
                    position: index,
                    child: Padding(
                        padding:
                            EdgeInsets.only(left: 5, right: 5, bottom: 15.0),
                        child: RegisterPendingVehicleCard(item: item)),
                  ),
                );
              },
            ),
          ],
        );
      }
      return ListSkeleton(
        length: 3,
        shrinkWrap: true,
        config: SkeletonConfig(
            isCircleAvatar: true,
            isShowAvatar: true,
            bottomLinesCount: 2,
            theme: SkeletonTheme.Light,
            radius: 5),
      );
    });
  }
}
