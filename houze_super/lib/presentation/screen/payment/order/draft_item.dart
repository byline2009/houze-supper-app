import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:houze_super/app/event.dart';
import 'package:houze_super/middle/model/payment_history_model.dart';
import 'package:houze_super/middle/model/payment_model.dart';
import 'package:houze_super/presentation/common_widgets/app_dialog.dart';
import 'package:houze_super/presentation/common_widgets/stateless/widget_cached_image.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/presentation/screen/base/base_widget.dart';
import 'package:houze_super/presentation/screen/payment/sc_payment_transfer.dart';
import 'package:houze_super/utils/constants/constants.dart';
import 'package:houze_super/utils/constants/share_keys.dart';
import 'package:houze_super/utils/date_util.dart';
import 'package:houze_super/utils/localizations_util.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:houzepayoosdk/houzepayoosdk.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

enum EnumDraftItemTemplate { history, recent }

enum EnumDraftItemSize { full, list }

const String draftItemKey = 'draftItemKey';

class DraftItem extends StatefulWidget {
  final PaymentHistoryModel order;

  final EnumDraftItemTemplate template;
  final EnumDraftItemSize size;
  final dynamic callback;
  final dynamic callbackDetail;

  DraftItem(
      {@required this.order,
      this.template = EnumDraftItemTemplate.recent,
      this.size = EnumDraftItemSize.list,
      this.callbackDetail,
      this.callback,
      Key key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => DraftItemState();
}

class DraftItemState extends State<DraftItem> {
  //Service converter
  // Future<String> serviceConverter() async {
  //   final service = ServiceConverter.convertTypeBuilding('apartment');
  //   return service;
  // }

  Size sizeSys;
  var padding;
  final formatter = NumberFormat('#,###');
  Houzepayoosdk houzepayoosdk;
  static const MethodChannel platform =
      MethodChannel('flutter.native/channelPayOrder');

  Widget statusButton() {
    var statusText = 'payment_status_pending';
    var statusColor = Color(0xffd68100);

    switch (widget.order.status) {
      case 1:
        statusText = 'payment_status_successful';
        statusColor = Color(0xff00aa7d);
        break;
      case 2:
        statusText = 'payment_status_failed';
        statusColor = Color(0xffc50000);
        break;
    }

    return Padding(
        padding: const EdgeInsets.only(bottom: 15),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: FlatButton(
              color: Color(0xfff5f7f8),
              onPressed: () {
                if (widget.callbackDetail != null) {
                  widget.callbackDetail();
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    LocalizationsUtil.of(context).translate(statusText),
                    style: AppFonts.semibold13.copyWith(color: statusColor),
                  ),
                  Row(
                    children: [
                      Text(LocalizationsUtil.of(context).translate('detail'),
                          style:
                              AppFonts.semibold13.copyWith(color: statusColor)),
                      const SizedBox(width: 6),
                      Icon(
                        Icons.arrow_forward,
                        size: 18,
                        color: statusColor,
                      )
                    ],
                  )
                ],
              ),
            )));
  }

  // PayMERepository _payMERepository;
  @override
  void initState() {
    super.initState();
    // _payMERepository = PayMERepository();
  }

  @override
  void dispose() {
    if (houzepayoosdk != null) {
      houzepayoosdk.dispose();
      print('=======================> HouzePayooSDK dispose()');
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    this.sizeSys = MediaQuery.of(context).size;
    this.padding = this.sizeSys.width * 5 / 100;

    return Padding(
      padding: EdgeInsets.only(
        right: widget.size == EnumDraftItemSize.list ? 20 : 0,
      ),
      child: BaseWidget.containerRounderRegular(
        Container(
          width: widget.size == EnumDraftItemSize.list
              ? this.sizeSys.width * 75 / 100
              : this.sizeSys.width,
          padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    DecoratedBox(
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: Color(0xfff2f2f2), width: 2.0),
                          borderRadius: BorderRadius.all(Radius.circular(14.0)),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                          child: Stack(
                            overflow: Overflow.clip,
                            children: <Widget>[
                              CachedImageWidget(
                                cacheKey: draftItemKey,
                                imgUrl: widget.order.company?.imageThumb,
                                width: 40.0,
                                height: 40.0,
                              ),
                            ],
                          ),
                        )),
                    const SizedBox(width: 15),
                    Expanded(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.order.building?.name,
                            style: AppFonts.regular14),
                        const SizedBox(height: 5),
                        FutureBuilder(
                            future: ServiceConverter.convertTypeService(
                                "apartment",
                                widget.order.service +
                                    widget.order.building?.type.toString()),
                            builder: (ctx, snap) {
                              if (snap.connectionState ==
                                  ConnectionState.waiting) {
                                return const SizedBox.shrink();
                              }
                              return WidgetRichText(
                                myString: LocalizationsUtil.of(context)
                                        .translate(snap.data) +
                                    ' ' +
                                    (widget.order?.apartmentName ?? 'n/a'),
                                wordToStyle:
                                    (widget.order?.apartmentName ?? 'n/a'),
                                style: AppFonts.semibold.copyWith(
                                  fontSize: 13,
                                ),
                              );
                            })
                      ],
                    ))
                  ]),
              const SizedBox(
                height: 16,
              ),
              BaseWidget.makeRowData(
                LocalizationsUtil.of(context)
                    .translate('payment_created_with_colon'),
                DateUtil.format('dd/MM/yyyy - HH:mm', widget.order.created),
                leadingColor: Color(0xff808080),
              ),
              const SizedBox(height: 8),
              BaseWidget.makeRowData(
                LocalizationsUtil.of(context)
                    .translate('payment_total_fee_with_colon'),
                'đ ${formatter.format(
                  double.parse(widget.order.amount),
                )}',
                leadingColor: Color(0xff808080),
              ),
              const SizedBox(height: 8),
              BaseWidget.makeRowData(
                LocalizationsUtil.of(context)
                    .translate('payment_created_by_with_colon'),
                widget.order?.createdBy?.fullname ?? '----',
                leadingColor: Color(0xff808080),
              ),
              const SizedBox(height: 15),
              if (widget.template == EnumDraftItemTemplate.recent)
                Expanded(
                  child: BaseWidget.note(Text(
                    LocalizationsUtil.of(context)
                        .translate('warning_transaction_expired'),
                    style: AppFonts.regular14,
                    textAlign: TextAlign.justify,
                  )),
                ),
              widget.template == EnumDraftItemTemplate.recent
                  ? FlatButton(
                      onPressed: () async {
                        if (widget.order.gatewayName == 'bank_transfer') {
                          AppRouter.push(
                            context,
                            AppRouter.PAYMENT_BANK_TRANSFER_PAGE,
                            PaymentBankTransferArguments(
                              id: widget.order.id,
                              buildingId: widget.order.building.id,
                              createdAt: widget.order.created,
                              callback: widget.callback,
                            ),
                          );
                        } else if (widget.order.gatewayName == kPayooEncrypt) {
                          final key =
                              encrypt.Key.fromUtf8(Toolset.paymentPrivateKey);
                          final encrypter = encrypt.Encrypter(
                              encrypt.AES(key, mode: encrypt.AESMode.ecb));
                          final decrypted =
                              encrypter.decrypt64(widget.order.urlPayment);
                          final payooDecode = PaymentPayooEncryptModel.fromJson(
                              json.decode(decrypted));

                          houzepayoosdk = new Houzepayoosdk(
                              clientId: payooDecode.clientId.toString(),
                              secretKey: payooDecode.secretKey,
                              isTestMode: widget.order.isTestMode);
                          houzepayoosdk.payWithOrder(
                              widget.order.info, payooDecode.checksum);
                          houzepayoosdk.onPaymentStateChanged.listen((s) {
                            print("trang thai thanh toan: ${s.toString()}");
                            if (s == null || s == kFailed) {
                              EventHandler.showFailurePayooPopup(
                                isShowButtonBackToRoot: false,
                              );
                              return;
                            }
                            if (s == kSuccess) {
                              EventHandler.showSuccessPayooPopup(
                                isShowButtonBackToRoot: false,
                              );
                              return;
                            }
                          });
                        } else if (widget.order.gatewayName == 'zalo') {
                          final info = json.decode(widget.order.info);
                          //ZaloPay Demo
                          // String response = '';
                          try {
                            final String result =
                                await platform.invokeMethod('payOrder', {
                              'zptoken': info['zp_trans_token'],
                              'appId': info['app_id'],
                              'isTestMode': widget.order.isTestMode == true,
                            });
                            // response = result;
                            print('payOrder Result: $result');
                          } on PlatformException catch (e) {
                            print('Failed to Invoke: ${e.message}.');
                            AppDialog.showAlertDialog(context, 'announcement',
                                'failed_to_find_the_proper_app_please_install_the_payment_app');
                          }
                          // End ZaloPay

                        } else if (widget.order.gatewayName ==
                            ShareKeys.kPayME) {
                          // processPayMePayment(context);
                          print('Remove paymeSDK');
                          return;
                        } else {
                          if (await canLaunch(widget.order.urlPayment)) {
                            await launch(widget.order.urlPayment,
                                forceSafariVC: false);
                          } else {
                            AppDialog.showAlertDialog(context, 'announcement',
                                'failed_to_find_the_proper_app_please_install_the_payment_app');
                          }
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            LocalizationsUtil.of(context)
                                .translate('continue_to_payment'),
                            style: AppFonts.semibold13.copyWith(
                              color: Color(0xffd68100),
                            ),
                          ),
                          const SizedBox(width: 2),
                          Icon(
                            Icons.arrow_forward,
                            size: 20,
                            color: Color(0xffd68100),
                          )
                        ],
                      ),
                    )
                  : statusButton(),
            ],
          ),
        ),
      ),
    );
  }

  // Future<void> processPayMePayment(
  //   BuildContext context,
  // ) async {
  //   if (Storage.getStatePayME() != ShareKeys.kKycApproved) {
  //     return;
  //   }
  //   final key = encrypt.Key.fromUtf8(Toolset.paymentPrivateKey);
  //   final encrypter =
  //       encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.ecb));
  //   final decrypted = encrypter.decrypt64(widget.order.urlPayment);
  //   final paymeDecode = PayMEEncryptModel.fromJson(json.decode(decrypted));
  //   try {
  //     final result = await HouzePaymeSdk.pay(
  //       amount: paymeDecode.amount,
  //       storeId: paymeDecode.storeID,
  //       orderId: paymeDecode.orderID,
  //     );
  //     print('payOrder Result: $result');
  //     if (result != null) {
  //       AppEventBloc().emitEvent(
  //         BlocEvent(
  //           EventName.payMEUpdateBalance,
  //           true,
  //         ),
  //       );

  //       DialogCustom.showSuccessDialog(
  //           context: Storage.scaffoldKey.currentContext,
  //           title: 'announcement',
  //           content: 'congratulation_you_have_paid_successfully',
  //           buttonText: 'ok',
  //           onPressed: () {
  //             Navigator.of(context).popUntil(
  //               (route) {
  //                 print(route.settings.name);
  //                 if (route.settings.name == AppRouter.ROOT) {
  //                   return true;
  //                 }
  //                 return false;
  //               },
  //             );
  //           });
  //     }
  //   } on PlatformException catch (e) {
  //     if (StringUtil.isEmpty(e.message)) return;

  //     if (e == null || StringUtil.isEmpty(e.message)) return;

  //     print('Failed to Invoke: Code: ${e.code} message: ${e.message}');

  //     if (e.code == ShareKeys.kPaymentError ||
  //         e.message.contains(
  //             'Yêu cầu thanh toán này đã tồn tại và đã thành công.')) {
  //       AppDialog.showAlertDialog(context, 'announcement',
  //           'k_this_payment_request_already_exists_and_was_successful_please_try_again');
  //       return;
  //     }

  //     AppDialog.showAlertDialog(context, 'announcement', e.message);
  //   } catch (e) {
  //     print(e);
  //     AppDialog.showAlertDialog(context, 'announcement', e.message);
  //   }
  // }
}
