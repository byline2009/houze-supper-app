import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:houze_super/utils/constant/index.dart';

class WidgetLogoHouze extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(AppVectors.logoHouze);
  }
}
