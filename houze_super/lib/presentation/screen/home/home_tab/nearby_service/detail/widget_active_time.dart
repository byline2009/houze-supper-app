import 'package:flutter/material.dart';
import 'package:houze_super/middle/model/shop_detail_model.dart';
import 'package:houze_super/presentation/screen/home/home_tab/nearby_service/detail/widget_tag.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/utils/constants/constants.dart';
import 'package:houze_super/utils/index.dart';

class WidgetActiveTime extends StatelessWidget {
  final ShopDetailModel merchant;
  const WidgetActiveTime({@required this.merchant});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: 30),
        Text(LocalizationsUtil.of(context).translate('opening_hours'),
            style: AppFonts.bold24),
        _buildCalendar(context),
      ],
    );
  }

  Widget _buildCalendar(BuildContext context) {
    if (merchant.hours.length == 0) {
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

    merchant.hours.forEach((f) {
      disableWeekday[f.weekday] = false;
    });

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: 5),
        SizedBox(
            child: ListView(
              padding: const EdgeInsets.all(0),
              scrollDirection: Axis.horizontal,
              children: <Widget>[
                WidgetTag(
                  text: 'monday',
                  isDisable: disableWeekday[0] ?? false,
                ),
                const SizedBox(width: 10),
                WidgetTag(
                  text: 'tuesday',
                  isDisable: disableWeekday[1] ?? false,
                ),
                const SizedBox(width: 10),
                WidgetTag(
                  text: 'wednesday',
                  isDisable: disableWeekday[2] ?? false,
                ),
                const SizedBox(width: 10),
                WidgetTag(
                  text: 'thursday',
                  isDisable: disableWeekday[3] ?? false,
                ),
                const SizedBox(width: 10),
                WidgetTag(
                  text: 'friday',
                  isDisable: disableWeekday[4] ?? false,
                ),
                const SizedBox(width: 10),
                WidgetTag(
                  text: 'saturday',
                  isDisable: disableWeekday[5] ?? false,
                ),
                const SizedBox(width: 10),
                WidgetTag(
                  text: 'sunday',
                  isDisable: disableWeekday[6] ?? false,
                ),
              ],
            ),
            height: 50),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
                fit: FlexFit.tight,
                child: Container(
                    padding: const EdgeInsets.only(
                        top: 15, bottom: 19, left: 10, right: 10),
                    decoration: BoxDecoration(
                      color: Color(0xfff5f5f5),
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    child: Center(
                        child: Column(
                      children: <Widget>[
                        Text(LocalizationsUtil.of(context).translate('open'),
                            style: AppFonts.semibold12),
                        const SizedBox(height: 5),
                        Text(merchant.hours.first.startTime ?? '',
                            style: AppFonts.semibold18)
                      ],
                    )))),
            const SizedBox(width: 15),
            Flexible(
                fit: FlexFit.tight,
                child: Container(
                    padding: const EdgeInsets.only(
                        top: 15, bottom: 19, left: 10, right: 10),
                    decoration: BoxDecoration(
                      color: Color(0xfff5f5f5),
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    child: Center(
                        child: Column(
                      children: <Widget>[
                        Text(LocalizationsUtil.of(context).translate('close'),
                            style: AppFonts.semibold12),
                        const SizedBox(height: 5),
                        Text(merchant.hours[0].endTime ?? '',
                            style: AppFonts.semibold18)
                      ],
                    )))),
          ],
        )
      ],
    );
  }
}
