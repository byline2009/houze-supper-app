import 'package:flutter/material.dart';
import 'package:houze_super/utils/constants/constants.dart';
import 'package:houze_super/utils/localizations_util.dart';

class NoInternetPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            LocalizationsUtil.of(context)
                .translate('please_check_your_network_and_try_connect_again'),
            style: AppFonts.regular15.copyWith(color: Color(0xff808080)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
