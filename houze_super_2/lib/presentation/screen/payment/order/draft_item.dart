import 'dart:convert';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:houze_super/app/event.dart';
import 'package:houze_super/middle/model/payment_history_model.dart';
import 'package:houze_super/middle/model/payment_model.dart';
import 'package:houze_super/presentation/common_widgets/app_dialog.dart';
import 'package:houze_super/presentation/common_widgets/widget_cached_image.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/presentation/screen/base/base_widget.dart';
import 'package:houze_super/presentation/screen/payment/sc_payment_transfer.dart';
import 'package:houzepayoosdk/houzepayoosdk.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

enum EnumDraftItemTemplate { history, recent }

enum EnumDraftItemSize { full, list }

const String draftItemKey = 'draftItemKey';

class DraftItem extends StatefulWidget {
  final PaymentHistoryModel order;

  final EnumDraftItemTemplate template;
  final EnumDraftItemSize size;
  // final dynamic callback;
  final dynamic callbackDetail;

  DraftItem({
    required this.order,
    this.template = EnumDraftItemTemplate.recent,
    this.size = EnumDraftItemSize.list,
    this.callbackDetail,
  }) : super();

  @override
  State<StatefulWidget> createState() => DraftItemState();
}

class DraftItemState extends State<DraftItem> {
  late Size _screenSize;
  var padding;
  final formatter = NumberFormat("#,###");
  late Future _future;
  Houzepayoosdk? houzepayoosdk;

  static const MethodChannel platform =
      MethodChannel('flutter.native/channelPayOrder');

  @override
  void initState() {
    this._future = ServiceConverter.convertTypeService(
        "apartment",
        (widget.order.service ?? "building") +
            (widget.order.building?.type.toString() ?? "0"));
    super.initState();
  }

  Widget statusButton() {
    var statusText = 'payment_status_pending';
    var statusColor = AppColor.orange_d68100;

    switch (widget.order.status) {
      case 1:
        statusText = 'payment_status_successful';
        statusColor = AppColor.green_00aa7d;
        break;
      case 2:
        statusText = 'payment_status_failed';
        statusColor = AppColor.red_c50000;
        break;
    }

    return Padding(
        padding: EdgeInsets.only(bottom: 15),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: AppColor.gray_f5f7f8,
              ),
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
                    style:
                        AppFont.SEMIBOLD_BLACK_13.copyWith(color: statusColor),
                  ),
                  Container(
                      child: Row(
                    children: [
                      Text(LocalizationsUtil.of(context).translate('detail'),
                          style: AppFont.SEMIBOLD_BLACK_13
                              .copyWith(color: statusColor)),
                      SizedBox(width: 6),
                      Icon(
                        Icons.arrow_forward,
                        size: 18,
                        color: statusColor,
                      )
                    ],
                  ))
                ],
              ),
            )));
  }

  @override
  void dispose() {
    houzepayoosdk?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    this._screenSize = MediaQuery.of(context).size;
    this.padding = this._screenSize.width * 5 / 100;

    return Padding(
      padding: EdgeInsets.only(
          right: widget.size == EnumDraftItemSize.list ? 20 : 0),
      child: BaseWidget.containerRounderRegular(
        Container(
          width: widget.size == EnumDraftItemSize.list
              ? this._screenSize.width * 75 / 100
              : this._screenSize.width,
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
                          clipBehavior: Clip.hardEdge,
                          children: <Widget>[
                            CachedImageWidget(
                              cacheKey: draftItemKey,
                              imgUrl: widget.order.company?.imageThumb ?? '',
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
                        Text(widget.order.building?.name ?? '',
                            style: AppFonts.regular14),
                        const SizedBox(height: 5),
                        FutureBuilder(
                          future: _future,
                          builder: (ctx, snap) {
                            if (snap.connectionState ==
                                ConnectionState.waiting) {
                              return const SizedBox.shrink();
                            }
                            return WidgetRichText(
                              myString: LocalizationsUtil.of(context)
                                      .translate(snap.data) +
                                  ' ' +
                                  (widget.order.apartmentName ?? 'n/a'),
                              wordToStyle:
                                  (widget.order.apartmentName ?? 'n/a'),
                              style: AppFont.SEMIBOLD_BLACK_13,
                            );
                          },
                        )
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              BaseWidget.makeRowData(
                LocalizationsUtil.of(context)
                    .translate("payment_created_with_colon"),
                DateUtil.format("dd/MM/yyyy - HH:mm", widget.order.created!),
                leadingColor: AppColor.grey,
              ),
              const SizedBox(height: 8),
              BaseWidget.makeRowData(
                LocalizationsUtil.of(context)
                    .translate("payment_total_fee_with_colon"),
                "đ ${formatter.format(
                  double.parse(widget.order.amount!),
                )}",
                leadingColor: AppColor.grey,
              ),
              const SizedBox(height: 8),
              BaseWidget.makeRowData(
                LocalizationsUtil.of(context)
                    .translate("payment_created_by_with_colon"),
                widget.order.createdBy?.fullname ?? '----',
                leadingColor: AppColor.grey,
              ),
              const SizedBox(height: 15),
              if (widget.template == EnumDraftItemTemplate.recent)
                Expanded(
                  child: BaseWidget.note(Text(
                    LocalizationsUtil.of(context)
                        .translate("warning_transaction_expired"),
                    style: AppFonts.regular14,
                    textAlign: TextAlign.justify,
                  )),
                ),
              widget.template == EnumDraftItemTemplate.recent
                  ? TextButton(
                      onPressed: () async {
                        if (widget.order.gatewayName == 'bank_transfer') {
                          AppRouter.push(
                              context,
                              AppRouter.PAYMENT_BANK_TRANSFER_SCREEN,
                              PaymentBankTransferArguments(
                                id: widget.order.id!,
                                buildingId: widget.order.building!.id!,
                                createdAt: widget.order.created!,
                              ));
                        } else if (widget.order.gatewayName == kPayooEncrypt) {
                          try {
                            final key =
                                encrypt.Key.fromUtf8(Toolset.paymentPrivateKey);
                            final iv = IV.fromLength(16);

                            final encrypter = encrypt.Encrypter(
                              encrypt.AES(key, mode: encrypt.AESMode.ecb),
                            );
                            final decrypted = encrypter.decrypt64(
                              widget.order.urlPayment!,
                              iv: iv,
                            );
                            final payooDecode =
                                PaymentPayooEncryptModel.fromJson(
                                    json.decode(decrypted));

                            houzepayoosdk = new Houzepayoosdk(
                                clientId: payooDecode.clientId.toString(),
                                secretKey: payooDecode.secretKey!,
                                isTestMode: widget.order.isTestMode!);
                            houzepayoosdk!.payWithOrder(
                                widget.order.info!, payooDecode.checksum!);
                            houzepayoosdk!.onPaymentStateChanged.listen((s) {
                              print("trang thai thanh toan: ${s.toString()}");

                              if (s == kFailed) {
                                EventController.showFailurePayooPopup(
                                  isShowButtonBackToRoot: false,
                                );
                                return;
                              }
                              if (s == kSuccess) {
                                EventController.showPaidSuccessfullyPopup(
                                  isShowButtonBackToRoot: false,
                                );
                                return;
                              }
                            });
                          } catch (e) {
                            print(e);
                          } finally {
                            AppController().updateOrderPage();
                          }
                        } else if (widget.order.gatewayName == "zalo") {
                          final info = json.decode(widget.order.info!);
                          //ZaloPay Demo
                          try {
                            final String result =
                                await platform.invokeMethod('payOrder', {
                              "zptoken": info["zp_trans_token"],
                              "appId": info["app_id"],
                              "isTestMode": widget.order.isTestMode == true,
                            });
                            print("payOrder Result: '$result'.");
                          } on PlatformException catch (e) {
                            print("Failed to Invoke: '${e.message}'.");
                            AppDialog.showAlertDialog(context, "announcement",
                                "failed_to_find_the_proper_app_please_install_the_payment_app");
                          } finally {
                            AppController().updateOrderPage();
                          }
                          // End ZaloPay
                        } else {
                          if (await canLaunch(widget.order.urlPayment!)) {
                            await launch(widget.order.urlPayment!,
                                forceSafariVC: false);
                          } else {
                            AppDialog.showAlertDialog(
                              context,
                              "announcement",
                              "failed_to_find_the_proper_app_please_install_the_payment_app",
                            );
                          }
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            LocalizationsUtil.of(context)
                                .translate('continue_to_payment'),
                            style: AppFont.SEMIBOLD_BLACK_13.copyWith(
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
}
