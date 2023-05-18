import 'package:flutter/material.dart';
import 'package:houze_super/middle/local/storage.dart';
import 'package:houze_super/middle/model/falicity_working_model.dart';
import 'package:houze_super/utils/index.dart';
import 'package:houze_super/utils/localizations_util.dart';
import 'package:intl/intl.dart';

class FacilityPickerEventCard extends StatelessWidget {
  final FacilityWorkingModel facilityWorkingModel;
  final getLanguage = Storage.getLanguage();

  FacilityPickerEventCard({this.facilityWorkingModel});

  Widget slotFormat(BuildContext context, int freeSlot) {
    if (this.facilityWorkingModel.freeSlot == -1) {
      return Text(LocalizationsUtil.of(context).translate('available'),
          style: AppFonts.medium14
              .copyWith(color: Colors.black)
              .copyWith(color: Color(0xff38d6ac)));
    }

    if (this.facilityWorkingModel.freeSlot == 0) {
      return Text(LocalizationsUtil.of(context).translate('out_of_slots'),
          style: AppFonts.medium14
              .copyWith(color: Colors.black)
              .copyWith(color: Color(0xffff6666)));
    }

    if (this.facilityWorkingModel.freeSlot > 0) {
      // vi: Còn {0} chỗ
      // en: {0} slots left
      // zh: {0}  位  剩下

      String _strLocalize = LocalizationsUtil.of(context)
          .translate('slots_with_left')
          .replaceFirst("{0}", freeSlot.toString());
      String _result = Intl.plural(
        freeSlot,
        locale: Storage.getLanguage().locale,
        one: _strLocalize,
        other: _strLocalize.replaceFirst(
            LocalizationsUtil.of(context).translate("slot"),
            LocalizationsUtil.of(context).translate('slots')),
        name: LocalizationsUtil.of(context).translate("slot"),
        args: [freeSlot],
      );

      return Text(
        _result,
        style: AppFonts.medium14
            .copyWith(color: Colors.black)
            .copyWith(color: Color(0xff00aa7d)),
      );
    }
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey[200],
            blurRadius: 5.0,
            spreadRadius: 1.0,
            offset: Offset(
              0.0, //move right 10
              1.0, //move down 10
            ),
          )
        ],
        color: Colors.white,
      ),
      child: Row(
        children: <Widget>[
          Text(
              this.facilityWorkingModel.startTime +
                  " -  " +
                  this.facilityWorkingModel.endTime,
              style: AppFonts.medium14.copyWith(color: Colors.black)),
          slotFormat(context, this.facilityWorkingModel.freeSlot),
        ],
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
      ),
    );
  }
}
