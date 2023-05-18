import 'package:flutter/material.dart';

import 'package:houze_super/presentation/index.dart';

typedef FieldSubmittedFunction(String value);

class WidgetInput extends StatelessWidget {
  final Key? fieldKey;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final Widget? label;
  final bool require;
  final bool obscureText;
  final bool autoFocus;
  final String? hint;
  final FocusNode? focusNode;
  final int? maxLines;
  final TextStyle? style;
  final FormFieldValidator<String>? validator;
  final FormFieldSetter<String>? onSaved;
  final FormFieldSetter<String>? onChanged;
  final Widget? suffixIcon;
  final TextInputAction? textInputAction;
  WidgetInput({
    required this.controller,
    this.fieldKey,
    this.keyboardType,
    this.textInputAction,
    this.label,
    this.require: false,
    this.autoFocus: false,
    this.obscureText: false,
    this.hint,
    this.maxLines,
    this.style,
    this.suffixIcon,
    this.focusNode,
    this.validator,
    this.onSaved,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        label != null || require
            ? Row(
                children: <Widget>[
                  require
                      ? Text(
                          "* ",
                          style: AppFonts.regular15.copyWith(
                            color: Color(0xff838383),
                          ),
                        )
                      : Text(""),
                  label != null ? label! : Center(),
                ],
              )
            : Center(),
        label != null || require ? SizedBox(height: 10) : Center(),
        Form(
          key: fieldKey,
          child: TextFormField(
            textInputAction: textInputAction ?? TextInputAction.done,
            keyboardAppearance: Brightness.light,
            focusNode: focusNode,
            controller: controller,
            autofocus: autoFocus,
            obscureText: obscureText,
            keyboardType: keyboardType,
            maxLines: keyboardType == TextInputType.multiline ? 5 : 1,
            style: style ?? AppFonts.bold18,
            textAlign: TextAlign.left,
            cursorColor: AppColor.black,
            decoration: InputDecoration(
              suffixIcon: suffixIcon,
              contentPadding: EdgeInsets.symmetric(
                vertical: 15,
                horizontal: 13,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(
                  color: AppColor.purple_6001d1,
                  width: 1,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(
                  color: AppColor.gray_d0d0d0,
                  width: 1,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(
                  color: AppColor.gray_d0d0d0,
                  width: 1,
                ),
              ),
              hintText: LocalizationsUtil.of(context).translate(
                hint ?? "",
              ),
            ),
            onSaved: onSaved,
            onChanged: onChanged,
            onFieldSubmitted: (String value) {
              bool isKeyboardShowing =
                  MediaQuery.of(context).viewInsets.bottom > 0;
              if (isKeyboardShowing) {
                FocusScopeNode currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
              }
            },
            validator: validator,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            cursorWidth: 1,
            textCapitalization: TextCapitalization.none,
          ),
        ),
      ],
    );
  }
}
