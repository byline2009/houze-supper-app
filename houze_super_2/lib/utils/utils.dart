import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:houze_super/middle/local/storage.dart';
import 'package:houze_super/utils/index.dart';
import 'package:url_launcher/url_launcher.dart';
import 'constant/share_keys.dart';

class Utils {
  static Future<void> makePhoneCall({required String url}) async {
    String phone = 'tel:' + url;
    if (await canLaunch(phone)) {
      await launch(phone);
    } else {
      ScaffoldMessenger.of(Storage.scaffoldKey.currentContext!).showSnackBar(
        SnackBar(
          padding: EdgeInsets.all(20),
          duration: Duration(seconds: 5),
          content: Text(
            'Số điện thoại $url không thể gọi được.',
            style: AppFonts.regular16.copyWith(
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.red[600]!,
        ),
      );
    }
  }

  static Future<void> launchURL({required String url}) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(Storage.scaffoldKey.currentContext!).showSnackBar(
        SnackBar(
          padding: EdgeInsets.all(20),
          duration: Duration(seconds: 5),
          content: Text(
            'Could not launch $url',
            style: AppFonts.regular16.copyWith(
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.red[600]!,
        ),
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
