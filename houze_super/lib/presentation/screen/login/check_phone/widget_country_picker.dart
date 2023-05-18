import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:houze_super/presentation/screen/login/style/style_login.dart';
import 'package:houze_super/utils/index.dart';

typedef void CallBackHandler(String value);

class WidgetCountryPicker extends StatefulWidget {
  final CallBackHandler callback;

  WidgetCountryPicker({@required this.callback});

  @override
  WidgetCountryPickerState createState() => new WidgetCountryPickerState();
}

class WidgetCountryPickerState extends State<WidgetCountryPicker> {
  //Default
  String phoneCode = AppConstant.phoneCode;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 10),
        decoration: StyleLogin.borderBlackOutline,
        child: CountryCodePicker(
          onChanged: (CountryCode countryCode) {
            //Todo : manipulate the selected country code here
            widget.callback(countryCode.toString());
          },
          // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
          initialSelection: AppConstant.phoneCode,
          textStyle: AppFonts.bold18,
          favorite: [AppConstant.phoneDial, AppConstant.phoneCode],
          // optional. Shows only country name and flag
          showCountryOnly: false,
          // optional. Shows only country name and flag when popup is closed.
          showOnlyCountryWhenClosed: false,
          // optional. aligns the flag and the Text left
          alignLeft: false,
        ));
  }
}
