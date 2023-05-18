import 'package:flutter/material.dart';
import 'package:houze_super/utils/constants/constants.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';

typedef void CallBackHandler(String phone);

class WidgetPinCode extends StatelessWidget {
  final BuildContext context;
  final TextEditingController pinEditingController;
  final FocusNode pinFocus;
  final CallBackHandler callback;

  const WidgetPinCode(
      {this.context, this.pinFocus, this.pinEditingController, this.callback});

  @override
  Widget build(BuildContext context) {
    final pinWidth = ((MediaQuery.of(context).size.width - 100) / 6);

    return Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: PinCodeTextField(
            autofocus: true,
            focusNode: pinFocus,
            controller: pinEditingController,
            hideCharacter: false,
            highlight: true,
            highlightColor: Colors.black,
            defaultBorderColor: Color(0xffd0d0d0),
            hasTextBorderColor: Colors.black,
            maxLength: 6,
            hasError: false,
            pinTextStyle: AppFonts.bold27,
            pinTextAnimatedSwitcherTransition:
                ProvidedPinBoxTextAnimation.scalingTransition,
            pinTextAnimatedSwitcherDuration: Duration(milliseconds: 200),
            wrapAlignment: WrapAlignment.center,
            pinBoxWidth: pinWidth,
            pinBoxBorderWidth: 1,
            pinBoxRadius: 4.0,
            hideDefaultKeyboard: false,
            onDone: (text) => callback(text),
            // RouterHM.pushDialogNoParams(context, RouterHM.CREATE_PASSWORD_PAGE);

            onTextChanged: (text) {}));
  }
}
