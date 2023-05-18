import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:houze_super/utils/constant/index.dart';
import 'package:intl/intl.dart';

class HouzePoint extends StatelessWidget {
  final int point;
  const HouzePoint({required this.point});

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(NumberFormat('#,###').format((point)),
              style: AppFont.BOLD_BLACK_27),
          SizedBox(width: 6),
          SvgPicture.asset(AppVectors.icPoint)
        ]);
  }
}
