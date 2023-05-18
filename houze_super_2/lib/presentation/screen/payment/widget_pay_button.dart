import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:houze_super/middle/model/payment_history_model.dart';
import 'package:houze_super/presentation/app_router.dart';
import 'package:houze_super/presentation/common_widgets/app_dialog.dart';
import 'package:houze_super/presentation/common_widgets/button_widget.dart';
import 'package:houze_super/presentation/screen/payment/sc_payment_transfer.dart';
import 'package:houze_super/utils/index.dart';
import 'package:url_launcher/url_launcher.dart';

class WidgetTransactionButton extends StatelessWidget {
  final PaymentHistoryModel transactionDetail;
  const WidgetTransactionButton({required this.transactionDetail});

  static const MethodChannel platform =
      MethodChannel('flutter.native/channelPayOrder');

  @override
  Widget build(BuildContext context) {
    if (transactionDetail.status == 0) {
      return Padding(
          padding: const EdgeInsets.all(20),
          child: ButtonWidget(
            isActive: true,
            callback: () async {
              if (transactionDetail.gatewayName == 'bank_transfer') {
                AppRouter.push(
                    context,
                    AppRouter.PAYMENT_BANK_TRANSFER_SCREEN,
                    PaymentBankTransferArguments(
                      id: transactionDetail.id!,
                      buildingId: transactionDetail.building!.id!,
                      createdAt: transactionDetail.created,
                    ));
              } else if (transactionDetail.gatewayName == "zalo") {
                final info = json.decode(transactionDetail.info!);
                //ZaloPay Demo
                // String response = "";
                try {
                  final String result =
                      await platform.invokeMethod('payOrder', {
                    "zptoken": info["zp_trans_token"],
                    "appId": info["app_id"],
                    "isTestMode": transactionDetail.isTestMode == true,
                  });
                  // response = result;
                  print("payOrder Result: '$result'.");
                } on PlatformException catch (e) {
                  print("Failed to Invoke: '${e.message}'.");
                  // response = "payment_failedsd";
                  AppDialog.showAlertDialog(context, "announcement",
                      "failed_to_find_the_proper_app_please_install_the_payment_app",
                      submit: () {
                    Navigator.of(context).popUntil(
                      (route) {
                        if (route.settings.name == AppRouter.ROOT) {
                          return true;
                        }
                        return false;
                      },
                    );
                  });
                } finally {
                  AppController().updateOrderPage();
                }
                // End ZaloPay
              } else {
                if (await canLaunch(transactionDetail.urlPayment!)) {
                  await launch(transactionDetail.urlPayment!,
                      forceSafariVC: false);
                } else {
                  AppDialog.showAlertDialog(context, "announcement",
                      "failed_to_find_the_proper_app_please_install_the_payment_app",
                      submit: () {
                    AppController().updateOrderPage();

                    Navigator.of(context).popUntil(
                      (route) {
                        if (route.settings.name == AppRouter.ROOT) {
                          return true;
                        }
                        return false;
                      },
                    );
                  });
                }
              }
            },
            defaultHintText: LocalizationsUtil.of(context).translate('payment'),
          ));
    }
    return SizedBox.shrink();
  }
}
