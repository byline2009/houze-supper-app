import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/utils/index.dart';

typedef void ButtonStartRunningCallBack();

class ButtonStartRunning extends StatelessWidget {
  final ButtonStartRunningCallBack callback;
  final bool isActive;
  ButtonStartRunning({@required this.callback, @required this.isActive});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isActive ? callback : null,
      child: Container(
          decoration: isActive
              ? BoxDecoration(
                  boxShadow: [
                      BoxShadow(
                          color: Color(0xffd9beff),
                          offset: Offset(0, 8.0),
                          blurRadius: 25)
                    ],
                  borderRadius: BorderRadius.all(Radius.circular(100.0)),
                  gradient: AppColors.gradient)
              : BoxDecoration(
                  color: Color(0xffc4c4c4),
                  borderRadius: BorderRadius.circular(100)),
          width: 160,
          height: 48,
          padding: const EdgeInsets.all(0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                LocalizationsUtil.of(context).translate('start'),
                style: AppFonts.bold18.copyWith(color: Colors.white),
              )
            ],
          )),
    );
  }
}
