import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:houze_super/domain/index.dart';
import 'package:houze_super/middle/model/facility/index.dart';
import 'package:houze_super/presentation/common_widgets/stateless/widget_booking_item.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/presentation/screen/home/home_tab/facility/detail/history/widget_empty_history.dart';
import 'package:houze_super/presentation/screen/home/home_tab/facility/register/detail/sc_facility_booking_detail.dart';
import 'package:intl/intl.dart';

class FacilityHistoriesScreen extends StatelessWidget {
  final BuildContext parentContext;
  final String id;

  FacilityHistoriesScreen({Key key, this.parentContext, this.id})
      : super(key: key);

  final cubit = FacilityBloc();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FacilityBloc, FacilityState>(
        cubit: cubit,
        builder: (ctx, state) {
          if (state is FacilityInitial) {
            cubit.add(FacilityGetHistoryEvent(id: id));
          }

          if (state is FacilityLoadHistoriesInProgress) {
            return Center(child: CupertinoActivityIndicator());
          }

          if (state is FacilityLoadHistoriesSuccess) {
            if (state.result.length == 0) {
              return EmptyHistory(parentContext: parentContext);
            }
            return AnimationLimiter(
                child: ListView.builder(
                    padding: const EdgeInsets.all(0),
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: state.result.length,
                    itemBuilder: (BuildContext context, int index) {
                      FacilityHistoryModel item = state.result[index];
                      return GestureDetector(
                        onTap: () {
                          AppRouter.pushDialog(
                              parentContext,
                              AppRouter.FACILITY_BOOKING_DETAIL_PAGE,
                              FacilityBookingDetailScreenArgument(id: item.id));
                        },
                        child: Padding(
                            key: Key(item.id),
                            padding: const EdgeInsets.only(bottom: 10),
                            child: BookingRowData(
                              title: "${item.facilitySlotName}",
                              date:
                                  "${item.startTime} - ${item.endTime}, ${DateFormat('dd/MM/yyyy').format(DateTime.parse(item.date))}",
                              status: BookingRowData.statusOrder(
                                  parentContext, item.status),
                              statusCode: item.status,
                            )),
                      );
                    }));
          }
          return const SizedBox.shrink();
        });
  }
}
