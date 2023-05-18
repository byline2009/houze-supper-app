import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:houze_super/app/event.dart';
import 'package:houze_super/middle/model/fee_model.dart';
import 'package:houze_super/middle/model/payment_history_model.dart';
import 'package:houze_super/presentation/common_widgets/button_widget.dart';
import 'package:houze_super/presentation/common_widgets/grouped_list.dart';
import 'package:houze_super/presentation/common_widgets/widget_home_scaffold.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/presentation/screen/base/base_widget.dart';
import 'package:houze_super/presentation/screen/handbook/widget_created_day_top.dart';

import 'package:houze_super/utils/constant/share_keys.dart';
import 'package:houze_super/utils/fee_utils.dart';
import 'package:houze_super/utils/settings/fee.dart';
import 'package:houzepayoosdk/houzepayoosdk.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:houze_super/middle/model/payment_model.dart';
import 'package:houze_super/presentation/common_widgets/app_dialog.dart';
import 'package:houze_super/presentation/screen/payment/sc_payment_transfer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import '../../base/route_aware_state.dart';
import 'blocs/payment/payment_bloc.dart';
import 'blocs/payment/payment_event.dart';
import 'blocs/payment/payment_state.dart';
import 'sc_payment_transfer.dart';

typedef CallBackHandler = Function(PaymentHistoryModel);

class PaymentDetailScreenArgument {
  final String id;
  final CallBackHandler callback;
  PaymentDetailScreenArgument({
    required this.id,
    required this.callback,
  });
}

class PaymentDetailScreen extends StatefulWidget {
  final PaymentDetailScreenArgument args;

  const PaymentDetailScreen({
    Key? key,
    required this.args,
  }) : super(key: key);

  @override
  PaymentDetailScreenState createState() => new PaymentDetailScreenState();
}

class PaymentDetailScreenState extends RouteAwareState<PaymentDetailScreen> {
  late final PaymentBloc _paymentBloc;
  Houzepayoosdk? houzepayoosdk;
  static const MethodChannel platform =
      MethodChannel('flutter.native/channelPayOrder');

  @override
  void initState() {
    _paymentBloc = context.read<PaymentBloc>();
    super.initState();
  }

  @override
  void dispose() {
    if (houzepayoosdk != null) houzepayoosdk!.dispose();
    print('=======================> HouzePayooSDK dispose()');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return HomeScaffold(
      title: 'transaction_detail',
      child: SafeArea(
        child: BlocBuilder<PaymentBloc, PaymentState>(
          bloc: _paymentBloc,
          builder: (
            BuildContext context,
            PaymentState paymentState,
          ) {
            if (paymentState is PaymentInitial) {
              _paymentBloc.add(
                PaymentGetDetail(
                  id: widget.args.id,
                ),
              );
            }

            if (paymentState is PaymentLoading) {
              return Center(child: CupertinoActivityIndicator());
            }
            if (paymentState is PaymentFailure) {
              if (paymentState.error.contains('NoDataException'))
                return SomethingWentWrong(true);
              else
                return SomethingWentWrong();
            }

            if (paymentState is PaymentGetDetailSuccessful) {
              final transactionDetail = paymentState.result;

              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  WidgetCreateDay(
                    title: 'payment_created_with_colon',
                    createdDay: transactionDetail.created,
                  ),
                  WidgetFeeBody(transactionDetail),
                  transactionButton(
                    transactionDetail,
                  ),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  // _onCallBack(PaymentHistoryModel value) {
  //   ;
  // }

  Widget transactionButton(PaymentHistoryModel transactionDetail) {
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
                      callback: (PaymentHistoryModel data) {
                        widget.args.callback(data);
                      }),
                );
              } else if (transactionDetail.gatewayName == kPayooEncrypt) {
                try {
                  final key = encrypt.Key.fromUtf8(Toolset.paymentPrivateKey);
                  final iv = encrypt.IV.fromLength(16);
                  final encrypter = encrypt.Encrypter(
                      encrypt.AES(key, mode: encrypt.AESMode.ecb));
                  final decrypted = encrypter
                      .decrypt64(transactionDetail.urlPayment!, iv: iv);
                  final payooDecode =
                      PaymentPayooEncryptModel.fromJson(json.decode(decrypted));
                  if (payooDecode.secretKey != null &&
                      payooDecode.secretKey!.isNotEmpty) {
                    houzepayoosdk ??= new Houzepayoosdk(
                        clientId: payooDecode.clientId.toString(),
                        secretKey: payooDecode.secretKey ?? "",
                        isTestMode: transactionDetail.isTestMode!);
                    houzepayoosdk!.payWithOrder(
                        transactionDetail.info!, payooDecode.checksum!);
                    houzepayoosdk!.onPaymentStateChanged.listen((s) {
                      print("Trang thai thanh toan: ${s.toString()}");
                      if (s == kFailed) {
                        EventController.showFailurePayooPopup(
                          isShowButtonBackToRoot: true,
                        );
                        return;
                      }
                      if (s == kSuccess) {
                        EventController.showPaidSuccessfullyPopup(
                          isShowButtonBackToRoot: true,
                        );
                        return;
                      }
                    });
                  } else {
                    AppDialog.showAlertDialog(
                        context,
                        LocalizationsUtil.of(context).translate("announcement"),
                        LocalizationsUtil.of(context).translate(
                            "there_is_an_issue_please_try_again_later_0"));
                  }
                } catch (e) {
                } finally {
                  AppController().updateOrderPage();
                }
              } else if (transactionDetail.gatewayName == 'zalo') {
                final info = json.decode(transactionDetail.info ?? "");
                //ZaloPay Demo
                // String response = '';
                try {
                  final String result =
                      await platform.invokeMethod('payOrder', {
                    'zptoken': info['zp_trans_token'],
                    'appId': info['app_id'],
                    'isTestMode': transactionDetail.isTestMode == true,
                  });
                  print('payOrder Result: $result');
                } on PlatformException catch (e) {
                  print('Failed to Invoke: ${e.message}');
                  AppDialog.showAlertDialog(context, 'announcement',
                      'failed_to_find_the_proper_app_please_install_the_payment_app',
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
              } else if (transactionDetail.gatewayName == ShareKeys.kPayME) {
                return;
              } else {
                if (await canLaunch(transactionDetail.urlPayment!)) {
                  await launch(transactionDetail.urlPayment!,
                      forceSafariVC: false);
                } else {
                  AppDialog.showAlertDialog(context, 'announcement',
                      'failed_to_find_the_proper_app_please_install_the_payment_app',
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
    return const SizedBox.shrink();
  }

//   Future<void> processPayMePayment(
//     BuildContext context,
//     PaymentHistoryModel transactionDetail,
//   ) async {
//     if (Storage.getStatePayME() != ShareKeys.kKycApproved) {
//       return;
//     }
//     final key = encrypt.Key.fromUtf8(Toolset.paymentPrivateKey);
//     final encrypter =
//         encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.ecb));
//     final decrypted = encrypter.decrypt64(transactionDetail.urlPayment);
//     final paymeDecode = PayMEEncryptModel.fromJson(json.decode(decrypted));
//     try {
//       final result = await HouzePaymeSdk.pay(
//         amount: paymeDecode.amount,
//         storeId: paymeDecode.storeID,
//         orderId: paymeDecode.orderID,
//       );

//       if (result != null) {
//         AppEventBloc().emitEvent(
//           BlocEvent(
//             EventName.payMEUpdateBalance,
//             true,
//           ),
//         );

//         DialogCustom.showSuccessDialog(
//             context: Storage.scaffoldKey.currentContext,
//             title: 'announcement',
//             content: 'congratulation_you_have_paid_successfully',
//             buttonText: 'back_to_payment_screen',
//             onPressed: () {
//               Navigator.of(context).popUntil(
//                 (route) {
//                   print(route.settings.name);
//                   if (route.settings.name == AppRouter.ROOT) {
//                     return true;
//                   }
//                   return false;
//                 },
//               );
//             });
//       }
//     } on PlatformException catch (e) {
//       if (e == null || StringUtil.isEmpty(e.message)) return;

//       print('Failed to Invoke: Code: ${e.code} message: ${e.message}');

//       if (e.code == ShareKeys.kPaymentError ||
//           e.message.contains(
//               'Yêu cầu thanh toán này đã tồn tại và đã thành công.')) {
//         AppDialog.showAlertDialog(context, 'announcement',
//             'k_this_payment_request_already_exists_and_was_successful_please_try_again');
//         return;
//       }

//       AppDialog.showAlertDialog(context, 'announcement', e.message);
//     } catch (e) {
//       print(e);
//       AppDialog.showAlertDialog(context, 'announcement', e.message);
//     }
//   }
}

class WidgetFeeBody extends StatelessWidget {
  final PaymentHistoryModel transactionDetail;
  const WidgetFeeBody(
    this.transactionDetail,
  );

  @override
  Widget build(BuildContext context) {
    Size _screenSize = MediaQuery.of(context).size;
    var padding = _screenSize.width * 5 / 100;
    final formatter = new NumberFormat("#,###");

    return Expanded(
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: const EdgeInsets.all(0),
        children: <Widget>[
          Padding(
              padding: EdgeInsets.only(
                  top: 20, bottom: 10, left: padding, right: padding),
              child: Row(
                children: <Widget>[
                  BaseWidget.paymentStatusTag(
                      context, transactionDetail.status!)
                ],
              )),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: padding,
              vertical: 20,
            ),
            child: Row(
              children: <Widget>[
                Text(
                  LocalizationsUtil.of(context)
                      .translate('payment_total_fee_with_colon'),
                  style: AppFonts.bold18.copyWith(color: Color(0xff6001d2)),
                ),
                Text(
                  "đ ${formatter.format(double.parse(transactionDetail.amount!))}",
                  style: AppFonts.bold18.copyWith(color: Color(0xff6001d2)),
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            ),
          ),
          feeSection(formatter, padding, context),
          personalInfoSection(context),
        ],
      ),
    );
  }

  Widget feeSection(
    NumberFormat formatter,
    double padding,
    BuildContext context,
  ) {
    return BaseWidget.containerBody(
      Padding(
        child: GroupedListView(
          sort: false,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          elements: transactionDetail.fees!,
          groupBy: (FeeDetailMessageModel element) => element.type,
          separator: const SizedBox.shrink(),
          groupSeparatorBuilder: (dynamic groupByValue) {
            final feeInfo = FeeSettings.feeTypes
                .firstWhere((item) => item.type == groupByValue);
            final total = transactionDetail.fees!
                .where((f) => f.type == groupByValue)
                .map((f) => double.parse(f.totalFee!))
                .toList()
                .reduce((a, b) => a + b);

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    LocalizationsUtil.of(context).translate(feeInfo.title),
                    style: AppFonts.semibold15,
                  ),
                  Text(
                    formatter.format(total),
                    style: AppFonts.semibold15,
                  )
                ],
              ),
            );
          },
          itemBuilder: (context, FeeDetailMessageModel element) {
            final FeeDetailMessageModel feeDetail = element;

            return Padding(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  TextLimitWidget(
                      LocalizationsUtil.of(context).translate(
                            FeeUtils.getFeeByMonthStr(feeDetail.type!),
                          ) +
                          "${feeDetail.month}/${feeDetail.year}",
                      maxLines: 2,
                      style:
                          AppFonts.medium14.copyWith(color: Color(0xff838383))),
                  Text(
                      formatter.format(
                        double.parse(
                          feeDetail.totalFee!,
                        ),
                      ),
                      style:
                          AppFonts.medium14.copyWith(color: Color(0xff838383))),
                ],
              ),
              padding: const EdgeInsets.symmetric(
                vertical: 5,
              ),
            );
          },
        ),
        padding: EdgeInsets.only(
          left: padding,
          right: padding,
          bottom: 20,
        ),
      ),
    );
  }

  Widget personalInfoSection(BuildContext context) {
    return Padding(
      padding: new EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            LocalizationsUtil.of(context).translate("personal_information"),
            style: AppFonts.bold15,
          ),
          const SizedBox(
            height: 5.0,
          ),
          infoRow("payment_created_by_with_colon",
              transactionDetail.createdBy?.fullname ?? '', context),
          FutureBuilder<String>(
            future: ServiceConverter.convertTypeService(
                "apartment_with_colon",
                transactionDetail.service ??
                    '' + transactionDetail.building!.type.toString()),
            builder: (context, snap) {
              if (snap.hasData && snap.data != null)
                return infoRow(snap.data ?? '',
                    (transactionDetail.apartmentName ?? "n/a"), context);

              return const SizedBox.shrink();
            },
          ),
          infoRow(
              "payment_method_with_colon",
              LocalizationsUtil.of(context).translate(
                  Utils.getPaymentGatewayName(
                      (transactionDetail.gatewayName ?? "n/a"))),
              context),
        ],
      ),
    );
  }

  Widget infoRow(
      String leftContent, String rightContent, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 10.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            LocalizationsUtil.of(context).translate('$leftContent'),
            style: AppFonts.medium14,
          ),
          Text(
            rightContent,
            style: AppFonts.medium14,
          ),
        ],
      ),
    );
  }
}
