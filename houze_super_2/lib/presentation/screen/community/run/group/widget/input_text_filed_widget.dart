import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:houze_super/presentation/common_widgets/button_widget.dart';
import 'package:houze_super/presentation/common_widgets/widget_btn_gradient.dart';
import 'package:houze_super/utils/constant/app_fonts.dart';

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

enum FieldType { create, code }

class EnterTeamNameTextFiled extends StatefulWidget {
  final CallBackCreateTeam callback;
  final FieldType type;
  final String titleButton;
  EnterTeamNameTextFiled({
    required this.callback,
    required this.titleButton,
    required this.type,
  });
  @override
  _EnterTeamNameTextFiledState createState() => _EnterTeamNameTextFiledState();
}

typedef void CallBackCreateTeam(String value);

class _EnterTeamNameTextFiledState extends State<EnterTeamNameTextFiled> {
  final fTeamName = TextEditingController();

  final StreamController<ButtonSubmitEvent> nextBtnController =
      StreamController<ButtonSubmitEvent>.broadcast();

  @override
  void initState() {
    super.initState();
    nextBtnController.add(ButtonSubmitEvent(false));
  }

  @override
  void dispose() {
    nextBtnController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 20,
          right: 20),
      child: Column(
        children: [
          TextField(
            inputFormatters: [
              if (widget.type == FieldType.code) UpperCaseTextFormatter(),
            ],
            onChanged: (String text) {
              bool isValid = text.isNotEmpty &&
                  text.trim().length >= 1 &&
                  text.length <= 255;
              nextBtnController.add(ButtonSubmitEvent(isValid));
            },
            decoration: InputDecoration(
                fillColor: Colors.white, focusedBorder: InputBorder.none),
            autofocus: true,
            controller: fTeamName,
            cursorColor: Color(0xff6001d2),
            cursorHeight: 30,
            cursorWidth: 1,
            maxLines: 2,
            maxLength: 255,
            keyboardAppearance: Brightness.light,
            textCapitalization: TextCapitalization.sentences,
            keyboardType: TextInputType.text,
            style: AppFonts.bold24,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 50),
          WidgetGradientButton(
            title: widget.titleButton,
            controller: nextBtnController,
            callback: () {
              widget.callback(fTeamName.text.toString());
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
