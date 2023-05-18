import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:houze_super/utils/constants/constants.dart';
import 'package:houze_super/utils/localizations_util.dart';

//'Hoàn thành mục tiêu',
class CompletedTargetLine extends StatelessWidget {
  const CompletedTargetLine({
    Key key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(
          AppVectors.icTeamSuccess,
          width: 16,
          height: 16,
        ),
        const SizedBox(width: 5),
        Text(
          LocalizationsUtil.of(context).translate('k_goal_accomplishment'),
          style: AppFonts.semibold13.copyWith(
            color: Color(
              0xff00aa7d,
            ),
          ),
        )
      ],
    );
  }
}
