import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:houze_super/middle/model/fee_model.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:intl/intl.dart';

final statusText = <String>[
  'need_to_pay',
  'wait_to_pay',
  'paid',
];

final statusStyle = <TextStyle>[
  AppFont.SEMIBOLD_PURPLE_6001d2_13,
  AppFont.SEMIBOLD_d68100_13,
  AppFont.SEMIBOLD_BLACK_13,
];

class WidgetItemFeePayment extends StatelessWidget {
  final FeeDetailMessageModel fee;
  WidgetItemFeePayment({required this.fee});

  @override
  Widget build(BuildContext context) {
    final String _month = StringUtil.getMonthStr(fee.month!)!;

    return Stack(
      clipBehavior: Clip.hardEdge,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      LocalizationsUtil.of(context).translate(_month) +
                          '${fee.year}',
                      style: AppFonts.medium14,
                    ),
                    SizedBox(width: 40),
                    SvgPicture.asset(
                      AppVectors.ic_arrow_right,
                      color: AppColor.gray_d1d6de,
                    )
                  ],
                ),
              ),
              SizedBox(height: 4),
              Text(
                'đ ${StringUtil.numberFormat(fee.totalFee)}',
                style: fee.status == 3
                    ? AppFonts.semibold13.copyWith(
                        color: Color(
                          0xff838383,
                        ),
                      )
                    : statusStyle[fee.status! - 1],
              ),
              SizedBox(height: 23),
              Text(
                LocalizationsUtil.of(context)
                    .translate(statusText[fee.status! - 1]),
                style: statusStyle[fee.status! - 1],
              ),
              SizedBox(height: 6),
              Text(
                DateFormat('dd/MM/y - HH:mm').format(
                  DateTime.parse(
                          fee.status! == 3 ? fee.receiptAt! : fee.sentAt!)
                      .toLocal(),
                ),
                style: AppFont.SEMIBOLD_GRAY_B5B5B5_13,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
