import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:houze_super/presentation/screen/community/index.dart';
import 'package:houze_super/utils/index.dart';

class FieldCustom extends StatelessWidget {
  final FieldInfo field;
  final TextInputType keyboardType;
  final List<TextInputFormatter> inputFormatters;
  final ValueChanged<String> onChanged;

  const FieldCustom({
    @required this.field,
    this.keyboardType,
    this.inputFormatters,
    @required this.onChanged,
  });

  @override
  Column build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 16.0),
        Text(
          LocalizationsUtil.of(context).translate(field.title),
          style: AppFonts.medium,
        ),
        SizedBox(height: 10.0),
        SizedBox(
          height: 48.0,
          child: TextField(
            keyboardAppearance: Brightness.light,
            controller: field.controller,
            style: AppFonts.medium,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            onChanged: onChanged,
            decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(left: 12.0),
                border: OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: field.controller.text.isEmpty
                        ? RunConstant.notCompleted
                        : Colors.black,
                  ),
                ),
                hintText: LocalizationsUtil.of(context).translate(field.hint),
                hintStyle: AppFonts.regular
                    .copyWith(color: Color(0xffb5b5b5)) //REGULAR_GREY_B5B5B5,
                ),
          ),
        ),
      ],
    );
  }
}
