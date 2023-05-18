import 'package:flutter/material.dart';
import 'package:houze_super/presentation/common_widgets/cupertino_model_popup_custom.dart';
import 'package:houze_super/presentation/index.dart';

typedef void HeaderDashboardPickYearCallback(int year);

class HeaderDashboardPickYear extends StatelessWidget {
  final int currentYear;
  final HeaderDashboardPickYearCallback callback;
  HeaderDashboardPickYear({
    required this.currentYear,
    required this.callback,
  });
  @override
  Widget build(BuildContext context) {
    final years = List<int>.generate(
      3,
      (i) => DateTime.now().year - i,
    );

    return Container(
      color: const Color(0xfff5f5f5),
      width: double.infinity,
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            LocalizationsUtil.of(context).translate('chart'),
            style: AppFonts.medium.copyWith(color: Color(0xff808080)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                LocalizationsUtil.of(context).translate('year'),
                style: AppFonts.medium14.copyWith(color: Color(0xff6001d2)),
              ),
              CupertinoModelPopupCustom(
                items: years,
                item: currentYear,
                setItem: (value) {
                  callback(value);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
