import 'package:flutter/material.dart';
import 'package:houze_super/presentation/common_widgets/stateless/widget_cached_image.dart';
import 'package:houze_super/presentation/screen/community/run/challenge/model/event_model.dart';
import 'package:houze_super/presentation/index.dart';

import 'event_description_line.dart';
import 'status_run_event.dart';

class CartInformationEventRun extends StatelessWidget {
  final EventModel item;

  const CartInformationEventRun({
    @required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: DecoratedBox(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(
              8,
            ),
          ),
          color: Color(
            0xfff5f5f5,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Stack(children: [
            CachedImageWidget(
              cacheKey: item.imageThumb,
              imgUrl: item.imageThumb,
              width: double.infinity,
            ),
            Positioned(
              child: RunnningStateCategory(
                state: item.runningState,
                fontSize: 14,
              ),
              top: 10,
              left: 10,
            ),
            Positioned(
                child: Container(
                  padding: const EdgeInsets.only(right: 10, left: 10),
                  height: 55,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: AppColors.gradientBlack,
                  ),
                  child: Center(
                    child: EventDescriptionLineWidget(
                      description: item.description,
                      style: AppFonts.bold18.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                bottom: 0,
                right: 0,
                left: 0)
          ]),
        ),
      ),
      height: 178,
    );
  }
}
