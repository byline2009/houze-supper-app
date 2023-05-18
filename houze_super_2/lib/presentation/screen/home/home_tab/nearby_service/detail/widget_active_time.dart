import 'package:flutter/material.dart';
import 'package:houze_super/middle/model/shop_detail_model.dart';
import 'package:houze_super/presentation/common_widgets/widget_tag.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/utils/index.dart';

class WidgetActiveTime extends StatelessWidget {
  final ShopDetailModel merchant;
  const WidgetActiveTime({required this.merchant});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 30),
        Text(LocalizationsUtil.of(context).translate('opening_hours'),
            style: AppFont.BOLD_BLACK_24),
        _buildCalendar(context),
      ],
    );
  }

  Widget _buildCalendar(BuildContext context) {
    if (merchant.hours!.length == 0) {
      return Padding(
        child: Center(
          child: Text(
            LocalizationsUtil.of(context).translate('no_working_hours_yet'),
          ),
        ),
        padding: const EdgeInsets.only(top: 15),
      );
    }

    final disableWeekday = <int, bool>{
      0: true,
      1: true,
      2: true,
      3: true,
      4: true,
      5: true,
      6: true,
    };

    merchant.hours!.forEach((f) {
      disableWeekday[f.weekday!] = false;
    });

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 5),
        SizedBox(
            child: ListView(
              padding: const EdgeInsets.all(0),
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                WidgetTag(
                  text: 'monday',
                  isDisable: disableWeekday[0] ?? false,
                ),
                SizedBox(width: 10),
                WidgetTag(
                  text: 'tuesday',
                  isDisable: disableWeekday[1] ?? false,
                ),
                SizedBox(width: 10),
                WidgetTag(
                  text: 'wednesday',
                  isDisable: disableWeekday[2] ?? false,
                ),
                SizedBox(width: 10),
                WidgetTag(
                  text: 'thursday',
                  isDisable: disableWeekday[3] ?? false,
                ),
                SizedBox(width: 10),
                WidgetTag(
                  text: 'friday',
                  isDisable: disableWeekday[4] ?? false,
                ),
                SizedBox(width: 10),
                WidgetTag(
                  text: 'saturday',
                  isDisable: disableWeekday[5] ?? false,
                ),
                SizedBox(width: 10),
                WidgetTag(
                  text: 'sunday',
                  isDisable: disableWeekday[6] ?? false,
                ),
              ],
            ),
            height: 50),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
                fit: FlexFit.tight,
                child: Container(
                    padding: const EdgeInsets.only(
                        top: 15, bottom: 19, left: 10, right: 10),
                    decoration: BoxDecoration(
                      color: AppColor.gray_f5f5f5,
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    child: Center(
                        child: Column(
                      children: <Widget>[
                        Text(LocalizationsUtil.of(context).translate('open'),
                            style: AppFont.SEMIBOLD_BLACK_12),
                        SizedBox(height: 5),
                        Text(merchant.hours!.first.startTime ?? '',
                            style: AppFont.SEMIBOLD_BLACK_18)
                      ],
                    )))),
            SizedBox(width: 15),
            Flexible(
                fit: FlexFit.tight,
                child: Container(
                    padding: const EdgeInsets.only(
                        top: 15, bottom: 19, left: 10, right: 10),
                    decoration: BoxDecoration(
                      color: AppColor.gray_f5f5f5,
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    child: Center(
                        child: Column(
                      children: <Widget>[
                        Text(LocalizationsUtil.of(context).translate('close'),
                            style: AppFont.SEMIBOLD_BLACK_12),
                        SizedBox(height: 5),
                        Text(merchant.hours![0].endTime ?? '',
                            style: AppFont.SEMIBOLD_BLACK_18)
                      ],
                    )))),
          ],
        )
      ],
    );
  }
}
