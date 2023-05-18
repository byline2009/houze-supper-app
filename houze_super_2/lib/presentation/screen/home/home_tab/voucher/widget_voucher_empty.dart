import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/utils/index.dart';

class WidgetVoucherEmpty extends StatelessWidget {
  final double? padding;
  const WidgetVoucherEmpty({this.padding});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: padding),
              SvgPicture.asset(AppVectors.graphic_voucher_empty),
              SizedBox(height: 15),
              Text(
                  LocalizationsUtil.of(context)
                      .translate("currently_there_are_no_vouchers"),
                  style: AppFont.MEDIUM_GRAY_808080.copyWith(fontSize: 16))
            ]));
  }
}
