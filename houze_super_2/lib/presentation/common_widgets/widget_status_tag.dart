import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:houze_super/middle/model/parking_vehicle_model.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/presentation/screen/parking/parking_constant.dart';

import 'package:houze_super/utils/index.dart';

enum StatusTag { pending, success, reject, canceled }

class SectionBookingStatusTag extends StatelessWidget {
  final int status;
  const SectionBookingStatusTag({required this.status});
  @override
  Widget build(BuildContext context) {
    Widget leading;
    Widget trailing;
    switch (status) {
      case 0:
        leading = Container(
          height: 30,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
          decoration: BoxDecoration(
              color: AppColor.ff9b00,
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          child: Row(
            children: <Widget>[
              SvgPicture.asset(AppVectors.icOval),
              SizedBox(width: 8),
              Text(LocalizationsUtil.of(context).translate('register_pending'),
                  style: AppFonts.medium14.copyWith(color: Colors.white) //,
                  )
            ],
          ),
        );
        break;
      case 1:
        leading = Container(
          height: 30,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
          decoration: BoxDecoration(
            color: AppColor.green_38d6ac,
            borderRadius: BorderRadius.all(
              Radius.circular(15.0),
            ),
          ),
          child: Row(
            children: <Widget>[
              SvgPicture.asset(AppVectors.icOval),
              SizedBox(width: 8),
              Text(LocalizationsUtil.of(context).translate('successful'),
                  style: AppFonts.medium14.copyWith(color: Colors.white))
            ],
          ),
        );

        break;
      case 2:
        leading = Container(
          height: 30,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
          decoration: BoxDecoration(
              color: AppColor.ff6666,
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          child: Row(
            children: <Widget>[
              SvgPicture.asset(AppVectors.icOval),
              SizedBox(width: 8),
              Text(LocalizationsUtil.of(context).translate('rejected_1'),
                  style: AppFonts.medium14.copyWith(color: Colors.white)),
            ],
          ),
        );

        break;
      case 3:
        leading = Container(
          height: 30,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
          decoration: BoxDecoration(
              color: AppColor.gray_d0d0d0,
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          child: Row(
            children: <Widget>[
              SvgPicture.asset(AppVectors.icOval),
              SizedBox(width: 8),
              Text(LocalizationsUtil.of(context).translate('canceled'),
                  style: AppFonts.medium14.copyWith(color: Colors.white)),
            ],
          ),
        );

        break;
      default:
        leading = Container(
          height: 30,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
          decoration: BoxDecoration(
              color: AppColor.gray_d0d0d0,
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          child: Row(
            children: <Widget>[
              SvgPicture.asset(AppVectors.icOval),
              SizedBox(width: 8),
              Text(LocalizationsUtil.of(context).translate('unknown'),
                  style: AppFonts.medium14.copyWith(color: Colors.white)),
            ],
          ),
        );

        break;
    }
    trailing = status == 0 || status == 1 ? CancelTag() : Center();
    return Container(
        height: 50,
        padding: const EdgeInsets.only(
          top: 15.0,
          left: 20.0,
          right: 20.0,
        ),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              leading,
              trailing,
            ]));
  }
}

class SectionVehicleStatusTag extends StatelessWidget {
  final ParkingVehicle item;
  const SectionVehicleStatusTag({required this.item});
  @override
  Widget build(BuildContext context) {
    Widget leading;
    Widget trailing;

    String status = item.status != null
        ? ParkingConstant.bookingStatusList[item.status!]
        : item.isExpired!
            ? 'expired'
            : 'active';

    Color color = item.status != null
        ? ParkingConstant.bookingStatusColors[item.status!]
        : item.isExpired!
            ? ParkingConstant.bookingStatusColors[3]
            : ParkingConstant.bookingStatusColors[1];

    leading = Container(
      height: 30,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
      decoration: BoxDecoration(
          color: color, borderRadius: BorderRadius.all(Radius.circular(15.0))),
      child: Row(
        children: <Widget>[
          SvgPicture.asset(AppVectors.icOval),
          SizedBox(width: 8),
          Text(LocalizationsUtil.of(context).translate(status),
              style: AppFonts.medium14.copyWith(color: Colors.white))
        ],
      ),
    );

    trailing =
        (item.status != null && item.status == 0) ? CancelTag() : Center();
    return Container(
        height: 50,
        padding: const EdgeInsets.only(
          top: 15.0,
          left: 20.0,
          right: 20.0,
        ),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              leading,
              trailing,
            ]));
  }
}

class CancelTag extends StatelessWidget {
  final content =
      'please_contact_to_your_pm_by_hotline_or_sending_a_request_on_houze_app_to_be_supported_in_cancelling_your_booking_thanks';
  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.all(0),
      ),
      child: Container(
        height: 30,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SvgPicture.asset(AppVectors.ic_close),
            SizedBox(width: 8),
            Text(
              LocalizationsUtil.of(context).translate('cancel_my_booking'),
              style: AppFonts.medium14
                  .copyWith(color: Colors.white)
                  .copyWith(color: AppColor.ff6666),
            ),
          ],
        ),
      ),
      onPressed: () {
        showSnackBar(context, LocalizationsUtil.of(context).translate(content));
      },
    );
  }

  void showSnackBar(BuildContext context, String content) =>
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.black,
          content: Text(
            content,
            style: AppFonts.regular15.copyWith(color: Colors.white),
          ),
        ),
      );
}
