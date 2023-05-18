import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:houze_super/presentation/screen/login/style/style_login.dart';
import 'package:houze_super/utils/index.dart';

typedef void CallBackHandler(String code);

class WidgetCountryPicker extends StatelessWidget {
  final CallBackHandler callback;

  const WidgetCountryPicker({
    required this.callback,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: StyleLogin.borderBlackOutline,
      child: CountryCodePicker(
        onChanged: (CountryCode countryCode) {
          callback(countryCode.toString());
        },
        initialSelection: AppConstant.phoneCode,
        textStyle: AppFonts.bold18,
        favorite: [
          AppConstant.phoneDial,
          AppConstant.phoneCode,
        ],
        showCountryOnly: false,
        showOnlyCountryWhenClosed: false,
        alignLeft: false,
      ),
    );
  }
}
