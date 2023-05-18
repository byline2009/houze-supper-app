import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:houze_super/presentation/index.dart';

import 'widget_total_team_bottom.dart';

typedef void CallBackHandler();

class EmptyTeamSection extends StatelessWidget {
  final int groupTotal;

  final CallBackHandler createTeamCallback;
  final CallBackHandler joinInTeamCallback;

  const EmptyTeamSection(
      {@required this.groupTotal,
      @required this.createTeamCallback,
      @required this.joinInTeamCallback});
  @override
  Widget build(BuildContext context) {
    double _width = (ScreenUtil.screenWidth - 55) / 2.0;
    return WidgetBoxesContainer(
      hasLine: false,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: createTeamCallback,
                  child: roundedRectBorderWidget(
                    width: _width,
                    title: LocalizationsUtil.of(context)
                        .translate('k_build_your_team_to_join_the_run_now'),
                    icon: Icon(
                      Icons.add_circle,
                      color: Color(0xfff2e8ff),
                      size: 32,
                    ),
                  ),
                ),
                SizedBox(width: 15),
                GestureDetector(
                  onTap: joinInTeamCallback,
                  child: roundedRectBorderWidget(
                    width: _width,
                    title: LocalizationsUtil.of(context)
                        .translate('k_join_the_team_by_code'),
                    icon: Icon(
                      Icons.people,
                      color: Color(0xfff2e8ff),
                      size: 32,
                    ),
                  ),
                ),
              ],
            ),
            Container(
              child: TotalTeamBottom(
                groupTotal: groupTotal,
              ),
              alignment: Alignment.center,
            ),
          ],
        ),
      ),
      // ),
    );
  }

  Widget roundedRectBorderWidget({double width, String title, Icon icon}) {
    return DottedBorder(
      padding: const EdgeInsets.all(0),
      borderType: BorderType.RRect,
      radius: Radius.circular(5),
      color: Color(0xffd0d0d0),
      strokeWidth: 1,
      dashPattern: [5, 5],
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        child: Container(
          height: 111,
          width: width,
          color: Colors.white,
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: AppFonts.semibold.copyWith(
                  fontSize: 13,
                ),
              ),
              SizedBox(height: 7),
              icon
            ],
          ),
        ),
      ),
    );
  }
}
