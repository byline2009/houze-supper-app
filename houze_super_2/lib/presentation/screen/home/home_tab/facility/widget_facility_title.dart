import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:houze_super/middle/model/facility/facility_detail_model.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/presentation/screen/base/base_widget.dart';
import 'package:responsive/responsive_row.dart';

class WidgetFacilityTitle extends StatelessWidget {
  final FacilityDetailModel model;
  final String? charge;
  final BuildContext parentContext;
  const WidgetFacilityTitle(
      {required this.model, this.charge, required this.parentContext});
  @override
  Widget build(BuildContext context) {
    List<Widget> _list = [];

    if (model.workingDaysDetail!.length == 7) {
      _list.add(Container(
        margin: EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
        color: AppColor.gray_eff2fc,
        child: Text(
          LocalizationsUtil.of(parentContext).translate('everyday'),
          style: AppFonts.medium14,
        ),
      ));
    } else {
      model.workingDaysDetail!.map(
        (f) {
          _list.add(
            Container(
              margin: EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              color: AppColor.gray_eff2fc,
              child: Text(
                LocalizationsUtil.of(parentContext).translate(
                  StringUtil.getWeekDay(f.weekday!),
                ),
                style: AppFonts.medium14,
              ),
            ),
          );
        },
      ).toList();
    }

    if (model.workingDaysDetail!.length > 0) {
      _list.add(Container(
          margin: EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          color: AppColor.gray_eff2fc,
          child: Text(model.workingDaysDetail!.first.getTime(),
              textAlign: TextAlign.center, style: AppFonts.medium14)));
    }
    return Container(
      decoration: BaseWidget.dividerBottom(height: 5),
      child: Padding(
        padding:
            const EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                TextLimitWidget(
                  model.title!,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: AppFont.BOLD_BLACK_22,
                )
              ],
            ),
            SizedBox(height: 11.5),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SvgPicture.asset(AppVectors.ic_attach_money, height: 15),
                SizedBox(width: 10),
                Text(charge!, style: AppFonts.medium14),
              ],
            ),
            SizedBox(height: 18.5),
            ResponsiveRow(
                alignment: WrapAlignment.start,
                runAlignment: WrapAlignment.center,
                columnsCount: 10,
                spacing: 10.0,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: _list.map((e) {
                  return e;
                }).toList()),
          ],
        ),
      ),
    );
  }
}
