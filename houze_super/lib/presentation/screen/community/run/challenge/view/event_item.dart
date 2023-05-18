import 'package:flutter/material.dart';
import 'package:houze_super/presentation/screen/community/run/challenge/model/event_model.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/presentation/screen/community/run/group/index.dart';
import 'package:houze_super/utils/index.dart';

import '../index.dart';

typedef void UpdateEventItem(bool update);

/*
 * Widget: Giải chạy item
 */
class EventRunItem extends StatelessWidget {
  final EventModel data;

  const EventRunItem({
    @required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AppRouter.push(
          context,
          AppRouter.RUN_EVENT_DETAIL_PAGE,
          RunEventDetailScreenArgument(
            eventModel: data,
          ),
        );
      },
      child: SizedBox(
        key: Key(data.id),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Builder(builder: (
              context,
            ) {
              return CartInformationEventRun(
                item: data,
              );
            }),
            const SizedBox(height: 5),
            Text(
              data.name,
              maxLines: 2,
              style: AppFonts.bold15,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 5),
            Text(
              data.timeToRun(context),
              maxLines: 1,
              style: AppFonts.semibold13.copyWith(
                color: Color(0xff838383),
              ),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
