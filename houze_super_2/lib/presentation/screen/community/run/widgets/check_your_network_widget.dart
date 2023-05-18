import 'package:flutter/material.dart';
import 'package:houze_super/utils/index.dart';


class NoInternetPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment(0, -1 / 3),
      child: Text(
        LocalizationsUtil.of(context)
            .translate('please_check_your_network_and_try_connect_again'),
        style: AppFonts.regular15.copyWith(color: Color(0xff808080)),
      ),
    );
  }
}
