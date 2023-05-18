import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/utils/constants/constants.dart';

//'Không hoàn thành mục tiêu'
class UncompletedTargetLine extends StatelessWidget {
  const UncompletedTargetLine({
    Key key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(
          AppVectors.icTeamFailed,
          width: 16,
          height: 16,
        ),
        const SizedBox(width: 5),
        Text(
          LocalizationsUtil.of(context)
              .translate('k_did_not_complete_the_goal'),
          style: AppFonts.semibold13.copyWith(
            color: Color(0xffb5b5b5),
            letterSpacing: 0.26,
            height: 1.23,
          ),
        )
      ],
    );
  }
}
