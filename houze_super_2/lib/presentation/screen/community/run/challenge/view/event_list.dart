import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/presentation/screen/community/run/blocs/index.dart';

import '../../../../../common_widgets/skeletons/src/skeleton/parking_image_card_skeleton.dart';
import '../../widgets/widget_header_section.dart';
import '../index.dart';

/*
 * Widget: Danh sách giải chạy
 */
class EventListWidget extends StatelessWidget {
  const EventListWidget();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RunBloc, RunState>(
      buildWhen: (p, c) => p.events != c.events,
      builder: (context, state) {
        if (state.hasData && state.events != null) {
          if (state.events!.length == 0) return const SizedBox.shrink();
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeaderSection(
                icon: AppVectors.icTrophy,
                title: LocalizationsUtil.of(context).translate('run_award'),
                isViewAll: false,
                callback: () {},
              ),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                shrinkWrap: true,
                itemCount: state.events?.length ?? 0,
                itemBuilder: (BuildContext context, int index) {
                  final EventModel item = state.events![index];

                  return EventRunItem(
                    data: item,
                  );
                },
              ),
            ],
          );
        }
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ParkingCardSkeleton(
                  width: ScreenUtil.defaultSize.width, height: 16),
              const SizedBox(height: 10),
              ParkingCardSkeleton(
                  width: ScreenUtil.defaultSize.width, height: 16),
            ],
          ),
        );
      },
    );
  }
}
