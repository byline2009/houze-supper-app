import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:houze_super/presentation/index.dart';

import '../../../index.dart';

/*
unregistered: Chưa đăng ký
registered: Đã đăng ký
expired: Giải chạy kết thúc
*/
enum RunningState { unregistered, registered, expired, none }

class RunnningStateCategory extends StatelessWidget {
  final RunningState state;
  final double fontSize;
  final EdgeInsets padding;
  const RunnningStateCategory({
    @required this.state,
    @required this.fontSize,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    if (state == RunningState.none) return const SizedBox.shrink();

    Color textColor = Colors.transparent;
    Color background = Colors.transparent;
    String title = '';
    switch (state) {
      case RunningState.registered:
        textColor = RunConstant.completed;
        background = Color(0xffd3fff3);
        title = 'k_registered'; //'Đã đăng ký';
        break;

      case RunningState.unregistered:
        textColor = Color(0xffd68100);
        background = Color(0xffffefc6);
        title = 'k_unregistered'; //'Chưa đăng ký';
        break;

      case RunningState.expired:
        textColor = Color(0xff838383);
        background = Color(0xfff5f5f5);
        title = 'k_end'; //'Kết thúc';
        break;

      default:
        break;
    }
    return DecoratedBox(
      decoration: BoxDecoration(
        color: background,
        borderRadius: const BorderRadius.all(
          Radius.circular(
            15.0,
          ),
        ),
      ),
      child: Padding(
        padding: padding ??
            const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 5,
            ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              width: 4,
              height: 5,
              child: SvgPicture.asset(
                AppVectors.icOvalPending,
                color: textColor,
                alignment: Alignment.bottomCenter,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              LocalizationsUtil.of(context).translate(title),
              textAlign: TextAlign.left,
              maxLines: 1,
              style: AppFonts.medium12.copyWith(
                color: textColor,
                letterSpacing: 0.0,
                fontSize: fontSize,
              ),
            )
          ],
        ),
      ),
    );
  }
}
