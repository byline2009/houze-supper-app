import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../../index.dart';

class EmptyHistory extends StatelessWidget {
  final BuildContext? parentContext;
  const EmptyHistory({this.parentContext});
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(top: 80),
        alignment: Alignment.topCenter,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SvgPicture.asset(AppVectors.icRegistercEmpty),
            SizedBox(height: 15),
            Text(
              LocalizationsUtil.of(parentContext)
                  .translate('the_booking_history_is_empty'),
              style: AppFont.MEDIUM_GRAY_808080_16,
            )
          ],
        ));
  }
}
