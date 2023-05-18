import 'package:flutter/material.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/presentation/screen/community/run/activity/index.dart';

import 'package:houze_super/utils/index.dart';

typedef void BottomSheetStartRunningCallback(bool success);

class BottomSheetStartRunning extends StatelessWidget {
  final BuildContext parentContext;
  final BottomSheetStartRunningCallback callback;
  final bool isActive;

  const BottomSheetStartRunning({
    Key? key,
    required this.parentContext,
    required this.callback,
    required this.isActive,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 60,
            child: Row(
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
                      Text(
                        '0.00 km',
                        style: AppFonts.bold27,
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 27),
                  width: 1,
                  height: 30,
                  decoration: BoxDecoration(color: Color(0xffc4c4c4)),
                ),
                Expanded(
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
                        '00:00:00',
                        style: AppFonts.bold27,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30, bottom: 40),
            child: _buildButton(),
          ),
          RemindToWarmUp(),
        ]);
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
    return ButtonStartRunning(
      callback: () {
        callback(true);
      },
      isActive: isActive,
    );
  }
}
