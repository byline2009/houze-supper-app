import 'package:flutter/material.dart';
import 'package:houze_super/presentation/screen/community/run/challenge/model/event_model.dart';
import 'package:houze_super/presentation/index.dart';

import '../../widgets/widget_header_section.dart';
import '../index.dart';

/*
 * Widget: Danh sách giải chạy
 */
class EventListWidget extends StatelessWidget {
  final List<EventModel> events;

  const EventListWidget({
    @required this.events,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HeaderSection(
          icon: AppVectors.icTrophy,
          title: LocalizationsUtil.of(context).translate('run_award'),
          isViewAll: false,
        ),
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
          shrinkWrap: true,
          itemCount: events.length,
          itemBuilder: (BuildContext context, int index) {
            final EventModel item = events[index];

            return EventRunItem(
              data: item,
            );
          },
        ),
      ],
    );
  }
}
