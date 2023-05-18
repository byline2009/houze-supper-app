import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:houze_super/presentation/index.dart';

import 'package:houze_super/utils/index.dart';

typedef void CallBackHandler();

class ButtonRunNow extends StatelessWidget {
  const ButtonRunNow({
    required this.callback,
    required this.parentContext,
  });

  final CallBackHandler callback;
  final BuildContext parentContext;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: callback,
      child: Container(
        margin: EdgeInsets.only(
          bottom: 30,
        ),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Color(
                0xffd9beff,
              ),
              offset: Offset(
                0,
                8.0,
              ),
              blurRadius: 25,
            )
          ],
          borderRadius: BorderRadius.all(
            Radius.circular(
              24.0,
            ),
          ),
          gradient: AppColor.gradient,
        ),
        width: 160,
        height: 48,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              AppVectors.icRunActive,
            ),
            const SizedBox(width: 8),
            Text(
              LocalizationsUtil.of(parentContext).translate(
                'k_run_now',
              ), //'Chạy ngay',
              style: AppFonts.bold16.copyWith(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
