import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:houze_super/utils/index.dart';

class RemindToWarmUp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset('assets/svg/community/ic-walk.svg'),
        const SizedBox(width: 10.0),
        Flexible(
          child: Text(
            LocalizationsUtil.of(context)
                .translate('remember_to_warm_up_before_starting_the_run'),
            maxLines: 2,
            style: AppFonts.semibold13.copyWith(
              color: Color(0xff838383),
            ),
          ),
        ),
      ],
    );
  }
}
