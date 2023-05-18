import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:houze_super/app/event.dart';

import 'package:houze_super/middle/local/storage.dart';

import 'package:houze_super/middle/model/fee_model.dart';
import 'package:houze_super/middle/model/payment_gateway_model.dart';
import 'package:houze_super/middle/model/payment_model.dart';
import 'package:houze_super/middle/repo/payment_repository.dart';

import 'package:houze_super/presentation/app_router.dart';
import 'package:houze_super/presentation/common_widgets/app_dialog.dart';
import 'package:houze_super/presentation/common_widgets/stateless/button_widget.dart';
import 'package:houze_super/presentation/common_widgets/stateless/text_limit_widget.dart';
import 'package:houze_super/presentation/common_widgets/stateless/widget_base_scaffold.dart';
import 'package:houze_super/presentation/common_widgets/widget_dialog_custom.dart';
import 'package:houze_super/presentation/common_widgets/stateless/widget_something_went_wrong.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/presentation/screen/fee/bloc/fee_bloc.dart';
import 'package:houze_super/presentation/screen/fee/bloc/fee_event.dart';
import 'package:houze_super/presentation/screen/fee/bloc/fee_state.dart';
import 'package:houze_super/presentation/screen/payment/bloc/payment/payment_bloc.dart';
import 'package:houze_super/presentation/screen/payment/sc_payment_transfer.dart';
import 'package:houze_super/presentation/screen/payment/widget_gateway_row.dart';
import 'package:houze_super/utils/constants/constants.dart';
import 'package:houze_super/utils/constants/share_keys.dart';
import 'package:houze_super/utils/custom_exceptions.dart';
import 'package:houze_super/utils/fee_utils.dart';
import 'package:houze_super/utils/localizations_util.dart';
import 'package:houze_super/utils/progresshub.dart';
import 'package:houze_super/utils/settings/fee.dart';
import 'package:houze_super/utils/string_util.dart';
import 'package:url_launcher/url_launcher.dart';

import 'bloc/payment/payment_event.dart';
import 'bloc/payment/payment_state.dart';

import 'package:houze_super/middle/repo/point_earn_repo.dart';
import 'package:houze_super/middle/model/houze_point/point_earn_model.dart';
import 'package:houze_super/utils/sqflite.dart';

//---SCREEN: Phương thức thanh toán---//
import 'package:houzepayoosdk/houzepayoosdk.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class FeeGatewayScreenArgument {
  Map<dynamic, bool> fees;
  final String buildingId;
  final String apartmentId;
  final Function callback;
  FeeGatewayScreenArgument({
    @required this.fees,
    @required this.buildingId,
    @required this.apartmentId,
    this.callback,
  });
}

class PaymentGate {
  String type;
  String title;
  String subTitle;
  Widget icon;

  PaymentGate({this.type, this.title, this.subTitle, this.icon});
}

class FeeGatewayScreen extends StatefulWidget {
  final FeeGatewayScreenArgument args;
  FeeGatewayScreen({Key key, this.args}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _FeeGatewayScreenState();
}

class _FeeGatewayScreenState extends State<FeeGatewayScreen>
    with
        AutomaticKeepAliveClientMixin<FeeGatewayScreen>,
        TickerProviderStateMixin {
  final paymentRepository = new PaymentRepository();
  final processHub = Progress.instanceCreateWithNormal();
  //Parse data
  final paymentModel = PaymentModel(feeTypes: List<int>());
  Houzepayoosdk houzepayoosdk;
  //Model
  List<FeeMessageModel> _feeListModel;

  //Bloc
  final feeBloc = new FeeBloc();
  final paymentBloc = new PaymentBloc();

  int defaultGatewaySelected = 0;
  StreamController<RadioSubmitEvent> gatewayController =
      new StreamController<RadioSubmitEvent>.broadcast();
  List<PaymentGatewayModel> gatewayList = new List<PaymentGatewayModel>();
  StreamController<ButtonSubmitEvent> _paymentButtonController =
      new StreamController<ButtonSubmitEvent>();

  String payResult = '';
  bool showResult = false;

  static const MethodChannel platform =
      MethodChannel('flutter.native/channelPayOrder');

  final String buildingId = Sqflite.currentBuildingID;
  final rpXu = PointEarnRepository();
  PointEarnModel _xuEarn;

  Future<void> getXuEarnInfo() async {
    var xu = await rpXu.getXuEarnInfo(buildingId);

    setState(() {
      _xuEarn = xu;
    });
  }

  @override
  void initState() {
    getXuEarnInfo();
    super.initState();

    (widget.args.fees).forEach((key, value) {
      if (key != '*' && value == true) {
        paymentModel.feeTypes.add(key);
      }
      return value;
    });
  }

  @override
  void dispose() {
    if (houzepayoosdk != null) {
      houzepayoosdk.dispose();
      print('=======================> HouzePayooSDK dispose()');
    }
    gatewayController.close();
    _paymentButtonController.close();
    Future.delayed(Duration.zero);
    super.dispose();
  }

  List<int> getFeePicked() {
    paymentModel.feeTypes.sort();
    return paymentModel.feeTypes;
  }

  double getTotal(List<FeeMessageModel> fees) {
    double total = 0;
    fees.forEach((f) {
      total += f.total;
    });
    return total;
  }

  Widget receiveXu() {
    if (_xuEarn != null && _xuEarn.feeBankTransferAward != 0) {
      return Container(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 17),
        color: Colors.white,
        child: Row(
          children: [
            SvgPicture.asset(AppVectors.icPoint),
            const SizedBox(width: 10),
            RichText(
              maxLines: 2,
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: LocalizationsUtil.of(context).translate('get_it_now'),
                    style: AppFonts.semibold.copyWith(
                      fontSize: 13,
                    ),
                  ),
                  TextSpan(
                    text:
                        ' ${StringUtil.numberFormat(_xuEarn.feeBankTransferAward)} ${LocalizationsUtil.of(context).translate('points')} ',
                    style:
                        AppFonts.semibold13.copyWith(color: Color(0xffd68100)),
                  ),
                  TextSpan(
                    text: LocalizationsUtil.of(context)
                        .translate('when_choosing_this_method'),
                    style: AppFonts.semibold.copyWith(
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }

  final feeDetailBloc = FeeBloc();
  double _totalFee = 0;
  Widget bodyContent() {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: <
        Widget>[
      Container(
        padding:
            const EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
        color: Color(0xfff5f5f5),
        child: Text(
          LocalizationsUtil.of(context).translate('bill_info'),
          style: AppFonts.medium.copyWith(color: Color(0xff808080)),
        ),
      ),
      BlocProvider<FeeBloc>(
        create: (_) => feeBloc,
        child: BlocBuilder<FeeBloc, FeeState>(
          builder: (BuildContext context, FeeState feeState) {
            if (feeState is FeeInitial) {
              feeBloc.add(FeeFilter(
                  building: widget.args.buildingId,
                  apartment: widget.args.apartmentId,
                  types: this.getFeePicked()));
            }

            if (feeState is FeeLoadListSuccessful) {
              _feeListModel = feeState.result;
            }

            if (_feeListModel == null) {
              return Padding(
                padding:
                    EdgeInsets.only(top: 20, bottom: 10, left: 20, right: 20),
                child: ListSkeleton(
                  shrinkWrap: true,
                  length: 3,
                  config: SkeletonConfig(
                      theme: SkeletonTheme.Light,
                      isShowAvatar: false,
                      isCircleAvatar: false,
                      bottomLinesCount: 1),
                ),
              );
            }
            _totalFee = this.getTotal(_feeListModel);
            return Column(
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.only(
                      top: 20,
                      bottom: 10,
                      left: 20,
                      right: 20,
                    ),
                    child: Row(
                      children: <Widget>[
                        Text(LocalizationsUtil.of(context).translate('total'),
                            style: AppFonts.bold18
                                .copyWith(color: Color(0xff6001d2))),
                        Text('đ ${StringUtil.numberFormat(_totalFee)}',
                            style: AppFonts.bold18
                                .copyWith(color: Color(0xff6001d2))),
                      ],
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    )),
                Padding(
                  child: Column(
                    children: _feeListModel.map((f) {
                      final feeInfo = FeeSettings.feeTypes
                          .firstWhere((item) => item.type == f.type);

                      return Column(
                        children: [
                          Padding(
                            child: Row(
                              children: <Widget>[
                                Text(
                                    LocalizationsUtil.of(context)
                                        .translate(feeInfo.title),
                                    style: AppFonts.bold15),
                                Text('${StringUtil.numberFormat(f.total)}',
                                    style: AppFonts.bold15)
                              ],
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 20,
                            ),
                          ),
                          BlocBuilder(
                              cubit: feeDetailBloc,
                              builder:
                                  (BuildContext context, FeeState _feeState) {
                                if (_feeState is FeeInitial) {
                                  feeDetailBloc.add(
                                    FeeDetailLoad(
                                      building: widget.args.buildingId,
                                      apartment: widget.args.apartmentId,
                                      type: f.type.toString(),
                                    ),
                                  );
                                }

                                if (_feeState is FeeLoadDetailSuccessful) {
                                  var list = _feeState.result.results.map((i) {
                                    return FeeDetailMessageModel.fromJson(i);
                                  }).toList();
                                  return ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: list.length,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                      ),
                                      itemBuilder: (c, index) {
                                        final feeDetail = list[index];
                                        return Padding(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              TextLimitWidget(
                                                LocalizationsUtil.of(context)
                                                        .translate(
                                                      FeeUtils.getFeeByMonthStr(
                                                          feeDetail.type),
                                                    ) +
                                                    '${feeDetail.month}/${feeDetail.year}',
                                                style: AppFonts.medium14
                                                    .copyWith(
                                                        color:
                                                            Color(0xff838383)),
                                                maxLines: 2,
                                              ),
                                              Text(
                                                  StringUtil.numberFormat(
                                                      double.parse(
                                                          feeDetail.totalFee)),
                                                  style: AppFonts.medium14
                                                      .copyWith(
                                                          color: Color(
                                                              0xff838383))),
                                            ],
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 5,
                                          ),
                                        );
                                      });
                                }
                                return ListSkeleton(
                                  shrinkWrap: true,
                                  length: 3,
                                  config: SkeletonConfig(
                                    theme: SkeletonTheme.Light,
                                    isShowAvatar: false,
                                    isCircleAvatar: false,
                                    bottomLinesCount: 1,
                                  ),
                                );
                              })
                        ],
                      );
                    }).toList(),
                  ),
                  padding: const EdgeInsets.only(
                    bottom: 20,
                  ),
                ),
              ],
            );
          },
        ),
      ),
      Container(
        padding:
            const EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
        color: Color(0xfff5f5f5),
        child: Text(
          LocalizationsUtil.of(context).translate('payment_method_with_colon'),
          style: AppFonts.medium.copyWith(color: Color(0xff808080)),
        ),
      ),
      BlocProvider<PaymentBloc>(
        create: (_) => paymentBloc,
        child: BlocBuilder<PaymentBloc, PaymentState>(
            builder: (BuildContext context, PaymentState paymentState) {
          if (paymentState is PaymentInitial) {
            paymentBloc
                .add(PaymentLoadGateway(buildingId: widget.args.buildingId));
          }

          if (paymentState is PaymentFailure) {
            if (paymentState.error.error is NoDataException)
              return SomethingWentWrong(true);
            else
              return SomethingWentWrong();
          }

          if (paymentState is PaymentLoadGatewaySuccessful) {
            // gatewayList = paymentState.result
            //   ..add(
            //     PaymentGatewayModel(
            //       gatewayTitle:
            //           LocalizationsUtil.of(context).translate('pay_in_cash'),
            //       gatewayDesc: LocalizationsUtil.of(context)
            //           .translate('resident_pay_in_cash_desc'),
            //     ),
            //   );

            gatewayList.clear();
            gatewayList.addAll(paymentState.result);
            gatewayList.add(PaymentGatewayModel(
              gatewayTitle:
                  LocalizationsUtil.of(context).translate('pay_in_cash'),
              gatewayDesc: LocalizationsUtil.of(context)
                  .translate('resident_pay_in_cash_desc'),
            ));

            var index = 0;
            if (gatewayList.length == 0) {
              return Center(
                child: Text(
                  LocalizationsUtil.of(context)
                      .translate('payment_method_not_yet'),
                ),
              );
            }

            if (checkUnActivePaymentButton) {
              _paymentButtonController.sink.add(ButtonSubmitEvent(false));
            } else {
              _paymentButtonController.sink.add(ButtonSubmitEvent(true));
            }
            return ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(0),
              children: gatewayList.map((f) {
                Widget element = Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: (index != 0)
                            ? Border(
                                top: BorderSide(
                                  color: Color(0xfff5f5f5),
                                  width: 2,
                                  style: BorderStyle.solid,
                                ),
                              )
                            : Border(
                                bottom: BorderSide.none,
                              ),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                      ),
                      child: WidgetGatewayRow(
                        id: index,
                        progressToolkit: processHub,
                        gatewaySelected: defaultGatewaySelected,
                        model: f,
                        callback: (
                          id,
                        ) {
                          defaultGatewaySelected = id;
                          gatewayController.sink
                              .add(RadioSubmitEvent(defaultGatewaySelected));
                          if (f.gatewayName == ShareKeys.kPayME &&
                              Storage.getStatePayME() !=
                                  ShareKeys.kKycApproved) {
                            _paymentButtonController.sink
                                .add(ButtonSubmitEvent(false));
                          } else {
                            _paymentButtonController.sink
                                .add(ButtonSubmitEvent(true));
                          }
                        },
                        controller: gatewayController,
                      ),
                    ),
                    if (f.gatewayName == 'bank_transfer') receiveXu()
                  ],
                );

                index++;
                return element;
              }).toList(),
            );
          }

          return Center(
              child: Padding(
            child: CupertinoActivityIndicator(),
            padding: const EdgeInsets.all(10),
          ));
        }),
      )
    ]);
  }

  bool get checkUnActivePaymentButton =>
      gatewayList[defaultGatewaySelected].gatewayName == ShareKeys.kPayME &&
      Storage.getStatePayME() != ShareKeys.kKycApproved;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Stack(
      children: [
        BaseScaffold(
          title: 'payment_method',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: <Widget>[
                    SliverToBoxAdapter(child: bodyContent()),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: SafeArea(
                  child: ButtonWidget(
                    controller: _paymentButtonController,
                    defaultHintText:
                        LocalizationsUtil.of(context).translate('pay'),
                    callback: () async {
                      try {
                        if (gatewayList[defaultGatewaySelected].gatewayName ==
                                ShareKeys.kPayME &&
                            _totalFee <= AppConstant.payMinLimit) {
                          DialogCustom.showErrorDialog(
                              context: context,
                              title: 'announcement',
                              errMsg: "k_please_pay_more_than_10000_VND",
                              callback: () {
                                Navigator.of(context).pop();
                              });
                          return;
                        }
                        processHub.state.show();

                        paymentModel.buildingId = widget.args.buildingId;
                        paymentModel.apartmentId = widget.args.apartmentId;
                        paymentModel.gateway =
                            gatewayList[defaultGatewaySelected].gatewayName;
                        print(json.encode(paymentModel).toString());

                        final resultPayment = await paymentRepository
                            .createFeePayment(paymentModel);

                        if (paymentModel.gateway == 'bank_transfer') {
                          if (widget?.args?.callback != null) {
                            widget.args.callback();
                          }
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                          AppRouter.push(
                            context,
                            AppRouter.PAYMENT_BANK_TRANSFER_PAGE,
                            PaymentBankTransferArguments(
                                id: resultPayment.id,
                                buildingId: resultPayment.buildingId,
                                createdAt: null,
                                callback: widget.args.callback),
                          );
                        } else if (paymentModel.gateway == kPayooEncrypt) {
                          final key =
                              encrypt.Key.fromUtf8(Toolset.paymentPrivateKey);
                          final encrypter = encrypt.Encrypter(
                              encrypt.AES(key, mode: encrypt.AESMode.ecb));
                          final decrypted =
                              encrypter.decrypt64(resultPayment.urlPayment);
                          final payooDecode = PaymentPayooEncryptModel.fromJson(
                              json.decode(decrypted));
                          houzepayoosdk = new Houzepayoosdk(
                              clientId: payooDecode.clientId.toString(),
                              secretKey: payooDecode.secretKey,
                              isTestMode: resultPayment.isTestMode);
                          houzepayoosdk.payWithOrder(
                              resultPayment.info, payooDecode.checksum);
                          houzepayoosdk.onPaymentStateChanged.listen((s) {
                            print("trang thai thanh toan: ${s.toString()}");
                            if (s == null || s == kFailed) {
                              EventHandler.showFailurePayooPopup(
                                  isShowButtonBackToRoot: true,
                                  callback: () {
                                    Navigator.of(context).popUntil(
                                      (route) {
                                        print(route.settings.name);
                                        if (route.settings.name ==
                                            AppRouter.ROOT) {
                                          if (widget?.args?.callback != null) {
                                            widget.args.callback();
                                          }
                                          return true;
                                        }
                                        return false;
                                      },
                                    );
                                  });
                              return;
                            }
                            if (s == kSuccess) {
                              EventHandler.showSuccessPayooPopup(
                                  isShowButtonBackToRoot: true,
                                  callback: () {
                                    Navigator.of(context).popUntil(
                                      (route) {
                                        if (route.settings.name ==
                                            AppRouter.ROOT) {
                                          if (widget?.args?.callback != null) {
                                            widget.args.callback();
                                          }
                                          return true;
                                        }
                                        return false;
                                      },
                                    );
                                  });
                              return;
                            }
                          });
                        } else if (paymentModel.gateway == 'zalo') {
                          final info = json.decode(resultPayment.info);
                          print(info);
                          //ZaloPay Demo
                          String response = '';
                          try {
                            final String result = await platform.invokeMethod(
                              'payOrder',
                              {
                                'zptoken': info['zp_trans_token'],
                                'appId': info['app_id'],
                                'isTestMode': resultPayment.isTestMode == true,
                              },
                            );
                            response = result;
                            print('payOrder Result: $result');
                          } on PlatformException catch (e) {
                            print('Failed to Invoke: ${e.message}');
                            response = 'payment_failedsd';
                            AppDialog.showAlertDialog(context, 'announcement',
                                'failed_to_find_the_proper_app_please_install_the_payment_app');
                          }
                          print(response);
                          setState(() {
                            payResult = response;
                          });
                          // End ZaloPay

                        } else if (paymentModel.gateway == ShareKeys.kPayME) {
                          // processPayMePayment(
                          //   resultPayment,
                          // );
                          return;
                          // End PayME
                        } else {
                          if (await canLaunch(resultPayment.urlPayment)) {
                            await launch(resultPayment.urlPayment,
                                forceSafariVC: false);
                          } else {
                            AppDialog.showAlertDialog(context, 'announcement',
                                'failed_to_find_the_proper_app_please_install_the_payment_app');
                          }
                        }
                      } catch (e) {
                        print(e);
                        AppDialog.showAlertDialogForPayment(
                            context,
                            'announcement',
                            'this_payment_method_is_under_maintenance');
                      } finally {
                        processHub.state.dismiss();
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        processHub
      ],
    );
  }

  // Future<void> processPayMePayment(PaymentModel resultPayment) async {
  //   if (Storage.getStatePayME() != ShareKeys.kKycApproved) {
  //     return;
  //   }
  //   final key = encrypt.Key.fromUtf8(Toolset.paymentPrivateKey);
  //   final encrypter =
  //       encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.ecb));
  //   final decrypted = encrypter.decrypt64(resultPayment.urlPayment);
  //   final paymeDecode = PayMEEncryptModel.fromJson(json.decode(decrypted));

  //   try {
  //     final result = await HouzePaymeSdk.pay(
  //       amount: paymeDecode.amount,
  //       storeId: paymeDecode.storeID,
  //       orderId: paymeDecode.orderID,
  //     );

  //     if (result != null) {
  //       AppEventBloc().emitEvent(
  //         BlocEvent(
  //           EventName.payMEUpdateBalance,
  //           true,
  //         ),
  //       );
  //       DialogCustom.showSuccessDialog(
  //         context: Storage.scaffoldKey.currentContext,
  //         title: 'announcement',
  //         content: 'congratulation_you_have_paid_successfully',
  //         buttonText: 'back_to_payment_screen',
  //         onPressed: () async {
  //           Navigator.of(context).popUntil(
  //             (route) {
  //               print(route.settings.name);
  //               if (route.settings.name == AppRouter.ROOT) {
  //                 if (widget?.args?.callback != null) {
  //                   widget.args.callback();
  //                 }

  //                 return true;
  //               }
  //               return false;
  //             },
  //           );
  //         },
  //       );
  //     }
  //   } on PlatformException catch (e) {
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
  //     AppDialog.showAlertDialogForPayment(
  //         context, 'announcement', 'this_payment_method_is_under_maintenance');
  //   }
  // }

  @override
  bool get wantKeepAlive => false;
}
