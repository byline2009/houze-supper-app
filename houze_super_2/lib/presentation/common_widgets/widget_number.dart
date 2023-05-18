import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:houze_super/utils/index.dart';

typedef Int2VoidFunc = void Function(int);

class WidgetNumber extends StatefulWidget {
  final TextEditingController? controller;
  final int? maxNumber;
  final int? value;
  final Int2VoidFunc doneEvent;

  WidgetNumber({
    this.controller,
    this.value,
    this.maxNumber,
    required this.doneEvent,
  });

  WidgetNumberState createState() => WidgetNumberState();
}

class WidgetNumberState extends State<WidgetNumber> {
  int _value = 0;
  late int _maxNumber;

  // WidgetNumberState({_value, this.maxNumber});
  @override
  void initState() {
    super.initState();

    _value = widget.value ?? 0;
    _maxNumber = widget.maxNumber ?? 99;
  }

  @override
  Widget build(BuildContext context) {
    if (_value == 0) {
      widget.controller!.clear();
    }

    return Row(
      children: <Widget>[
        ElevatedButton(
            style: ElevatedButton.styleFrom(
                tapTargetSize: MaterialTapTargetSize.padded,
                primary: Colors.white,
                elevation: 0,
                padding: EdgeInsets.all(0)),
            child: SvgPicture.asset(
              "assets/svg/icon/ic-circle-minus.svg",
              width: 31,
              height: 31,
              color: _value > 0 ? Colors.black87 : null,
            ),
            onPressed: () {
              setState(() {
                if (_value > 0) {
                  HapticFeedback.lightImpact();
                  _value--;
                  widget.controller!.text = _value.toString();
                  widget.doneEvent(_value);
                }
              });
            }),
        Container(
            width: 60,
            decoration: BoxDecoration(
                boxShadow: [
                  new BoxShadow(
                    color: Color(0xffd2d4d6),
                    offset: Offset(0, 2.0),
                    blurRadius: 0.5,
                  )
                ],
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                color: Colors.white,
                border: Border.all(
                    color: widget.controller!.text != ""
                        ? AppColor.black
                        : Color(0xffebeef2),
                    width: 0.7,
                    style: BorderStyle.solid)),
            child: TextField(
              keyboardAppearance: Brightness.light,
              controller: widget.controller,
              enabled: false,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xff333333),
                fontFamily: AppFont.font_family_display,
                fontSize: 14,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "0",
                hintStyle: TextStyle(
                    color: AppColor.gray_808080,
                    fontFamily: AppFont.font_family_display,
                    fontSize: 14), //Text olor
              ),
            )),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              tapTargetSize: MaterialTapTargetSize.padded,
              primary: Colors.white,
              elevation: 0,
              padding: EdgeInsets.all(0)),
          child: SvgPicture.asset(
            "assets/svg/icon/ic-circle-add.svg",
            width: 31,
            height: 31,
            color: _value < _maxNumber && _value >= 0 ? Colors.black87 : null,
          ),
          onPressed: () {
            setState(() {
              if (_value < _maxNumber) {
                HapticFeedback.lightImpact();
                _value++;
                widget.controller!.text = _value.toString();
                widget.doneEvent(_value);
              }
            });
          },
        ),
      ],
    );
  }
}
