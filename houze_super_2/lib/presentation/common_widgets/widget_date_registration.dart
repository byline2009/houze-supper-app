import 'package:flutter/material.dart';
import 'package:houze_super/utils/index.dart';
import 'package:intl/intl.dart';

class DateRegistration extends StatelessWidget {
  final String date;
  final bool hasTime;

  DateRegistration({
    required this.date,
    this.hasTime: false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48.0,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      color: Color(0xFFf5f7f8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            LocalizationsUtil.of(context).translate('registration_date'),
            style: AppFont.BOLD_GRAY,
          ),
          Text(
            DateFormat(hasTime ? 'dd/MM/y - HH:mm' : 'dd/MM/y')
                .format(DateTime.parse(date)),
            style: AppFont.BOLD_GRAY,
          ),
        ],
      ),
    );
  }
}
