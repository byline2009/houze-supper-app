import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:houze_super/presentation/common_widgets/style/booking_style.dart';
import 'package:houze_super/presentation/index.dart';

class BookingRowData extends StatelessWidget {
  final String title;
  final int? statusCode;
  final String? date;
  final Widget? status;

  BookingRowData(
      {this.title = "", this.date, this.status, this.statusCode = 0});

  static Widget statusOrder(BuildContext? context, int? status) {
    switch (status) {
      case 0:
        return Text(LocalizationsUtil.of(context).translate('pending'),
            style: AppFonts.semibold13.copyWith(color: AppColor.ff9b00));
      case 1:
        return Text(LocalizationsUtil.of(context).translate('successful'),
            style: AppFonts.semibold13.copyWith(color: AppColor.green_38d6ac));
      case 2:
        return Text(LocalizationsUtil.of(context).translate('rejected_1'),
            style: AppFonts.semibold13.copyWith(color: AppColor.ff6666));
      case 3:
        return Text(LocalizationsUtil.of(context).translate('canceled'),
            style: AppFonts.semibold13.copyWith(color: AppColor.gray_808080));
      default:
        return Text(LocalizationsUtil.of(context).translate('unknown'),
            style: AppFonts.semibold13.copyWith(color: AppColor.ff9b00));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BookingStyle.orderBoxStyle,
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          leading: SvgPicture.asset(
              "assets/svg/icon/booking/ic-status-${this.statusCode}.svg"),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              this.title != ""
                  ? Row(
                      children: <Widget>[
                        TextLimitWidget(
                          title,
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: AppFonts.medium14,
                        ),
                      ],
                    )
                  : Center(),
              SizedBox(height: 5),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      this.date ?? '',
                      style: AppFonts.medium14.copyWith(
                        color: Color(
                          0xff808080,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5),
            ],
          ),
          trailing: Icon(
            Icons.arrow_forward,
            color: AppColor.gray_d1d6de,
            size: 20.0,
          ),
          subtitle: status,
        ),
      ),
    );
  }
}
