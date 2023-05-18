import 'package:flutter/material.dart';
import 'package:houze_super/presentation/common_widgets/widget_button_custom.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/presentation/screen/community/run/activity/index.dart';

import 'package:houze_super/utils/index.dart';

typedef void BottomSheetRunningPauseCallback(bool success);
typedef void BottomSheetRunningContinueCallback(bool success);

class BottomSheetRunningPause extends StatelessWidget {
  final BuildContext parentContext;
  final BottomSheetRunningPauseCallback pauseCallback;
  final BottomSheetRunningContinueCallback continueCallback;
  final double compare;
  final Map<String, dynamic> mapValue;

  const BottomSheetRunningPause({
    Key? key,
    required this.compare,
    required this.parentContext,
    required this.pauseCallback,
    required this.continueCallback,
    required this.mapValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String timeStr = formatTime(mapValue['time']);

    final double totalDistance = mapValue['total_distance'];
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 70,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LocalizationsUtil.of(context).translate('distance'),
                      style: AppFonts.semibold13.copyWith(
                        color: Color(0xff838383),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        totalDistance.toStringAsFixed(2) + ' km',
                        style: AppFonts.bold27,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                width: 1,
                height: 30,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Color(
                      0xffc4c4c4,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 27),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        LocalizationsUtil.of(context).translate('time'),
                        style: AppFonts.semibold13.copyWith(
                          color: Color(0xff838383),
                        ),
                      ),
                      Text(
                        timeStr,
                        style: AppFonts.bold27,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        _buildButton(),
        const SizedBox(
          height: 40,
        ),
        compare >= 0
            ? CongratuationAfterRun(compare: compare)
            : const SizedBox.shrink(),
      ],
    );
  }

  String formatTime(int milliseconds) {
    if (milliseconds == 0) return '00:00:00';

    final secs = milliseconds ~/ 1000;
    final hours = (secs ~/ 3600).toString().padLeft(2, '0');
    final minutes = ((secs % 3600) ~/ 60).toString().padLeft(2, '0');
    final seconds = (secs % 60).toString().padLeft(2, '0');
    return "$hours:$minutes:$seconds";
  }

  Widget _buildButton() {
    return Row(
      children: [
        Flexible(
          fit: FlexFit.tight,
          child: FlatStadiumButton(
            buttonText: 'continue',
            onPressed: () {
              continueCallback(true);
            },
          ),
        ),
        const SizedBox(width: 16.0),
        Flexible(
          fit: FlexFit.tight,
          child: FlatStadiumButton(
            buttonText: 'end',
            onPressed: () {
              pauseCallback(true);
            },
          ),
        ),
      ],
    );
  }
}
