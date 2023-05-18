import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:houze_super/utils/index.dart';

class CongratuationAfterRun extends StatelessWidget {
  final double compare;
  const CongratuationAfterRun({
    required this.compare,
  });
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SvgPicture.asset('assets/svg/community/ic-walk.svg'),
        const SizedBox(width: 4.0),
        Expanded(
          child: RichText(
            maxLines: 2,
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                  text: LocalizationsUtil.of(context)
                      .translate('great_you_ran_more_than_last_time'),
                  style: AppFonts.semibold13.copyWith(
                    color: Color(0xff838383),
                  ),
                ),
                TextSpan(
                  text: ' +${compare.toStringAsFixed(2)} km',
                  style: AppFonts.semibold13.copyWith(color: Color(0xff00aa7d)),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
