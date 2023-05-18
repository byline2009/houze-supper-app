import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:houze_super/middle/local/storage.dart';
import 'package:houze_super/utils/index.dart';
import 'package:houze_super/utils/toast.dart';
import 'package:url_launcher/url_launcher.dart';

import 'constants/app_fonts.dart';
import 'constants/share_keys.dart';

class Utils {
  static Future<void> makePhoneCall({
    @required String phone,
  }) async {
    if (await canLaunch('tel:$phone')) {
      await launch('tel:$phone');
    } else {
      ToastUtil.show(
        ToastDecorator(
          widget: Text(
            'Số điện thoại: $phone không thể gọi được.',
            style: AppFonts.medium16.copyWith(
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.redAccent,
          borderRadius: BorderRadius.circular(5),
          padding: const EdgeInsets.all(20),
        ),
        Storage.scaffoldKey.currentContext,
        gravity: ToastPosition.center,
        duration: 5,
      );
    }
  }

  static Future<void> launchURL({@required String url}) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ToastUtil.show(
        ToastDecorator(
          widget: Text('Could not launch $url',
              style: AppFonts.medium16.copyWith(color: Colors.white)),
          backgroundColor: Colors.redAccent,
          borderRadius: BorderRadius.circular(5),
          padding: const EdgeInsets.all(20),
        ),
        Storage.scaffoldKey.currentContext,
        gravity: ToastPosition.center,
        duration: 5,
      );
    }
  }

  static String convertURL(String result) {
    String contentBase64 = base64Encode(const Utf8Encoder().convert(result));
    return AppConstant.PREFIX_URL + contentBase64;
  }

  // INTERNET, ELECTRICITY, WATER, SANITARY, CONVENIENT, COMMON_FACILITIES, ELEVATOR, CAR_PARKING, CRIMINAL, OTHER, FEEDBACK = 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
  static getIssueCategory(int category) {
    return {
      0: 'internet',
      1: 'electricity',
      2: 'water',
      3: 'sanitary',
      4: 'amenity',
      5: 'common_facility',
      6: 'elevator',
      7: 'parking',
      8: 'security',
      9: 'others',
      10: 'reply',
      11: 'facility_booking',
    }[category];
  }

  static getPaymentGatewayName(String gateway) {
    if (gateway.contains('payoo')) {
      return 'PAYOO';
    }
    if (gateway.contains(ShareKeys.kPayME)) {
      return 'k_e_wallet_payME';
    }

    if (gateway.contains('momo')) {
      return 'MOMO';
    }

    if (gateway.contains('zalo')) {
      return 'ZALO';
    }

    if (gateway.contains('bank_transfer')) {
      return 'manual_bank_transfer';
    }

    return {"n/a": 'n/a', 'vnpt': 'VNPT Pay'}[gateway];
  }
}
