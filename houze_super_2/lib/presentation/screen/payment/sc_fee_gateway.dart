import 'dart:async';
import 'dart:convert';

import 'package:encrypt/encrypt.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:houze_super/app/event.dart';
import 'package:houze_super/middle/api/payment_api.dart';
import 'package:houze_super/middle/model/fee_model.dart';
import 'package:houze_super/middle/model/payment_gateway_model.dart';
import 'package:houze_super/middle/model/payment_model.dart';
import 'package:houze_super/middle/repo/payment_repository.dart';
import 'package:houze_super/presentation/base/route_aware_state.dart';
import 'package:houze_super/presentation/common_widgets/app_dialog.dart';
import 'package:houze_super/presentation/common_widgets/button_widget.dart';
import 'package:houze_super/presentation/common_widgets/custom_refresh_indicator/index.dart';
import 'package:houze_super/presentation/common_widgets/houze_xu_info/model/point_earn_model.dart';
import 'package:houze_super/presentation/common_widgets/houze_xu_info/networking/repository/point_earn_repo.dart';
import 'package:houze_super/presentation/screen/payment/blocs/fee_filter/index.dart';
import 'package:houze_super/presentation/screen/payment/order/fee/blocs/index.dart';
import 'package:houze_super/presentation/screen/payment/sc_payment_transfer.dart';
import 'package:houze_super/presentation/screen/payment/widget_gateway_row.dart';

import 'package:houze_super/utils/fee_utils.dart';
import 'package:houze_super/utils/settings/fee.dart';
import 'package:houzepayoosdk/houzepayoosdk.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

import '../../index.dart';

class FeeGatewayScreenArgument {
  final Map<dynamic, bool> fees;
  final String buildingId;
  final String apartmentId;
  final Function callback;
  const FeeGatewayScreenArgument({
    required this.fees,
    required this.buildingId,
    required this.apartmentId,
    required this.callback,
  });
}

class FeeGatewayScreen extends StatefulWidget {
  final FeeGatewayScreenArgument args;
  const FeeGatewayScreen({
    required this.args,
  }) : super();

  @override
  State<StatefulWidget> createState() => _FeeGatewayScreenState();
}

class _FeeGatewayScreenState extends RouteAwareState<FeeGatewayScreen>
    with
        AutomaticKeepAliveClientMixin<FeeGatewayScreen>,
        TickerProviderStateMixin {
  late final PaymentRepository paymentRepository;
  final processHub = Progress.instanceCreateWithNormal();

  //Parse data
  final paymentModel = PaymentModel(feeTypes: <int>[]);

  Houzepayoosdk? houzepayoosdk;

  //Bloc

  int defaultGatewaySelected = 0;
  final StreamController<RadioSubmitEvent> gatewayController =
      StreamController<RadioSubmitEvent>.broadcast();
  final List<PaymentGatewayModel> gatewayList = <PaymentGatewayModel>[];
  final StreamController<ButtonSubmitEvent> _paymentButtonController =
      StreamController<ButtonSubmitEvent>();

  static const MethodChannel platform =
      MethodChannel('flutter.native/channelPayOrder');

  final rpXu = PointEarnRepository();
  PointEarnModel? _xuEarn;

  Future<void> getXuEarnInfo() async {
    var xu = await rpXu.getXuEarnInfo(Sqflite.currentBuildingID);
    if (!mounted) return;
    setState(() {
      _xuEarn = xu;
    });
  }

  @override
  void initState() {
    super.initState();

    paymentRepository = PaymentRepository(api: PaymentAPI());
    getXuEarnInfo();
    (widget.args.fees).forEach((key, value) {
      if (key != "*" && value == true) {
        paymentModel.feeTypes!.add(key);
      }
    });
    context.read<FeeGatewayBloc>().add(
          FeeGatewayLoadDetail(
            buildingID: widget.args.buildingId,
            apartmentID: widget.args.apartmentId,
            types: this.getFeePicked(),
          ),
        );
    _paymentButtonController.sink.add(ButtonSubmitEvent(false));
  }

  @override
  void dispose() {
    houzepayoosdk?.dispose();
    print('=======================> HouzePayooSDK dispose()');
    gatewayController.close();
    _paymentButtonController.close();
    super.dispose();
  }

  List<int> getFeePicked() {
    paymentModel.feeTypes!.sort();
    return paymentModel.feeTypes!;
  }

  double getTotal(List<FeeMessageModel> fees) {
    double total = 0;
    fees.forEach((f) {
      total += f.total!;
    });
    return total;
  }

  Widget receiveXu() {
    if (_xuEarn != null && _xuEarn!.feeBankTransferAward != 0) {
      return DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 17),
          child: Row(
            children: [
              SvgPicture.asset(AppVectors.icPoint),
              const SizedBox(width: 10),
              RichText(
                maxLines: 2,
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                        text: LocalizationsUtil.of(context)
                            .translate('get_it_now'),
                        style: AppFonts.semibold13),
                    TextSpan(
                      text:
                          ' ${StringUtil.numberFormat(_xuEarn!.feeBankTransferAward)} ${LocalizationsUtil.of(context).translate('points')} ',
                      style: AppFonts.semibold13.copyWith(
                        color: Color(0xffd68100),
                      ),
                    ),
                    TextSpan(
                        text: LocalizationsUtil.of(context)
                            .translate('when_choosing_this_method'),
                        style: AppFonts.semibold13),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildHeader() => DecoratedBox(
        decoration: BoxDecoration(color: Color(0xfff5f5f5)),
        child: Padding(
          padding:
              const EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
          child: Text(
            LocalizationsUtil.of(context).translate('bill_info'),
            style: AppFonts.medium.copyWith(color: Color(0xff808080)),
          ),
        ),
      );

  Widget buildSectionTwo({required List<PaymentGatewayModel> list}) {
    gatewayList.clear();
    gatewayList.addAll(list);
    // if (gatewayList.length == 0) {
    //   _paymentButtonController.sink.add(ButtonSubmitEvent(false));
    // } else {
    //   _paymentButtonController.sink.add(ButtonSubmitEvent(true));
    // }
    gatewayList.add(PaymentGatewayModel(
      gatewayTitle: LocalizationsUtil.of(context).translate('pay_in_cash'),
      gatewayDesc:
          LocalizationsUtil.of(context).translate('resident_pay_in_cash_desc'),
    ));

    if (gatewayList.length == 0) {
      return Align(
        alignment: Alignment.center,
        child: Text(
          LocalizationsUtil.of(context).translate('payment_method_not_yet'),
        ),
      );
    }
    return ListView.builder(
        shrinkWrap: true,
        itemCount: gatewayList.length,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(0),
        itemBuilder: (context, index) {
          final PaymentGatewayModel item = gatewayList[index];
          return Column(
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  border: (index != 0)
                      ? const Border(
                          top: BorderSide(
                            color: Color(0xfff5f5f5),
                            width: 2,
                            style: BorderStyle.solid,
                          ),
                        )
                      : const Border(
                          bottom: BorderSide.none,
                        ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                  ),
                  child: WidgetGatewayRow(
                    id: index,
                    model: item,
                    callback: (
                      id,
                    ) {
                      defaultGatewaySelected = id;
                      gatewayController.sink
                          .add(RadioSubmitEvent(defaultGatewaySelected));
                    },
                    controller: gatewayController,
                  ),
                ),
              ),
              if (item.gatewayName == 'bank_transfer') receiveXu()
            ],
          );
        });
  }

  Widget buildSectionOne({required List<FeeMessageModel> feeListModel}) {
    final totalFee = this.getTotal(feeListModel);

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: <Widget>[
            Text(LocalizationsUtil.of(context).translate('total'),
                style: AppFonts.bold18.copyWith(color: Color(0xff6001d2))),
            Text('đ ${StringUtil.numberFormat(totalFee)}',
                style: AppFonts.bold18.copyWith(color: Color(0xff6001d2))),
          ],
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Stack(
      children: <Widget>[
        BlocBuilder<FeeGatewayBloc, FeeGatewayState>(
            builder: (BuildContext context, FeeGatewayState state) {
          if (state.isInitial) {
            context.read<FeeGatewayBloc>().add(
                  FeeGatewayLoadDetail(
                    buildingID: widget.args.buildingId,
                    apartmentID: widget.args.apartmentId,
                    types: this.getFeePicked(),
                  ),
                );
          }

          List<FeeMessageModel> _feeList = [];
          List<PaymentGatewayModel> _gatewayList = [];
          if (state.hasData) {
            _feeList = state.feeList;
            _gatewayList = state.gatewayList;
            bool _isValid = _feeList.length != 0 && _gatewayList.length != 0;
            _paymentButtonController.sink.add(ButtonSubmitEvent(_isValid));
          }

          return BaseScaffold(
            title: 'payment_method',
            child: Column(
              children: [
                Expanded(
                  child: CustomRefreshIndicator(
                    leadingGlowVisible: false,
                    trailingGlowVisible: false,
                    indicatorBuilder:
                        (BuildContext context, CustomRefreshIndicatorData d) {
                      if (d.isDraging) {
                        return Positioned(
                          top: 20,
                          right: 0,
                          left: 0,
                          child: DraggingActivityIndicator(
                            percentageComplete: d.value,
                            radius: 12,
                          ),
                        );
                      }

                      if (d.isArmed) {
                        return const Positioned(
                          top: 20,
                          right: 0,
                          left: 0,
                          child: CupertinoActivityIndicator(
                            radius: 12,
                          ),
                        );
                      }

                      return const SizedBox.shrink();
                    },
                    onRefresh: () async {
                      if (_feeList.length > 0) {
                        await Future.delayed(
                          Duration.zero,
                          () {
                            context.read<FeeGatewayBloc>().add(
                                  FeeGatewayLoadDetail(
                                    buildingID: widget.args.buildingId,
                                    apartmentID: widget.args.apartmentId,
                                    types: this.getFeePicked(),
                                  ),
                                );
                          },
                        );
                      }
                    },
                    child: CustomScrollView(
                      key: const PageStorageKey<String>('sc_fee_gateway'),
                      physics: const AlwaysScrollableScrollPhysics(),
                      slivers: [
                        SliverToBoxAdapter(
                          child: _buildHeader(),
                        ),
                        if (state.hasLoading) ...[
                          SliverPadding(
                            padding: EdgeInsets.only(top: 150),
                            sliver: SliverToBoxAdapter(
                              child: Align(
                                child: CupertinoActivityIndicator(),
                              ),
                            ),
                          ),
                        ] else if (state.hasError) ...[
                          SliverPadding(
                              padding: EdgeInsets.only(top: 150),
                              sliver: SliverToBoxAdapter(
                                  child: SomethingWentWrong()))
                        ] else if (state.hasData) ...[
                          buildSectionOne(feeListModel: _feeList),
                          SliverPadding(
                            padding: EdgeInsets.only(
                              bottom: 20,
                            ),
                            sliver: SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, int index) {
                                  final FeeGateway feeGateway =
                                      state.feeGateways[index];
                                  final feeInfo = FeeSettings.feeTypes
                                      .firstWhere((item) =>
                                          item.type == feeGateway.fee.type);
                                  return Column(
                                    children: [
                                      Padding(
                                        child: Row(
                                          children: <Widget>[
                                            Text(
                                                LocalizationsUtil.of(context)
                                                    .translate(feeInfo.title),
                                                style: AppFonts.bold15),
                                            Text(
                                                '${StringUtil.numberFormat(feeGateway.fee.total)}',
                                                style: AppFonts.bold15)
                                          ],
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 10,
                                          horizontal: 20,
                                        ),
                                      ),
                                      ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount:
                                              feeGateway.feeDetailList.length,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 20,
                                          ),
                                          itemBuilder: (c, index) {
                                            final FeeDetailMessageModel
                                                feeDetail =
                                                feeGateway.feeDetailList[index];
                                            return Padding(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  TextLimitWidget(
                                                    LocalizationsUtil.of(
                                                                context)
                                                            .translate(
                                                          FeeUtils
                                                              .getFeeByMonthStr(
                                                                  feeDetail
                                                                      .type!),
                                                        ) +
                                                        '${feeDetail.month}/${feeDetail.year}',
                                                    style: AppFonts.medium14
                                                        .copyWith(
                                                            color: Color(
                                                                0xff838383)),
                                                    maxLines: 2,
                                                  ),
                                                  Text(
                                                      StringUtil.numberFormat(
                                                          double.parse(feeDetail
                                                              .totalFee!)),
                                                      style: AppFonts.medium14
                                                          .copyWith(
                                                              color: Color(
                                                                  0xff838383))),
                                                ],
                                              ),
                                              padding: const EdgeInsets.only(
                                                bottom: 10,
                                              ),
                                            );
                                          })
                                    ],
                                  );
                                },
                                childCount: state.feeGateways.length,
                              ),
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: DecoratedBox(
                              decoration: const BoxDecoration(
                                color: Color(0xfff5f5f5),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 20,
                                  right: 20,
                                  top: 15,
                                  bottom: 15,
                                ),
                                child: Text(
                                  LocalizationsUtil.of(context)
                                      .translate('payment_method_with_colon'),
                                  style: AppFonts.medium
                                      .copyWith(color: Color(0xff808080)),
                                ),
                              ),
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: buildSectionTwo(
                              list: _gatewayList,
                            ),
                          )
                        ],
                      ],
                    ),
                  ),
                ),
                buildPayButton(state),
              ],
            ),
          );
        }),
        processHub,
      ],
    );
  }

  Widget buildPayButton(FeeGatewayState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: SafeArea(
        child: ButtonWidget(
          controller: _paymentButtonController,
          defaultHintText: LocalizationsUtil.of(context).translate('pay'),
          callback: () async {
            // EventController.showPaidSuccessfullyPopup(
            //     isShowButtonBackToRoot: true);
            // return;
            if (state.hasData == false) return;

            try {
              processHub.state.show();

              paymentModel.buildingId = widget.args.buildingId;
              paymentModel.apartmentId = widget.args.apartmentId;
              paymentModel.gateway =
                  gatewayList[defaultGatewaySelected].gatewayName;
              print(json.encode(paymentModel).toString());

              final resultPayment =
                  await paymentRepository.createFeePayment(paymentModel);

              if (paymentModel.gateway == 'bank_transfer') {
                // widget.args.callback();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                AppRouter.push(
                  context,
                  AppRouter.PAYMENT_BANK_TRANSFER_SCREEN,
                  PaymentBankTransferArguments(
                    id: resultPayment.id!,
                    buildingId: resultPayment.buildingId!,
                    createdAt: null,
                  ),
                );
              } else if (paymentModel.gateway == kPayooEncrypt) {
                try {
                  final key = encrypt.Key.fromUtf8(Toolset.paymentPrivateKey);
                  final iv = IV.fromLength(16);

                  final encrypter = encrypt.Encrypter(
                      encrypt.AES(key, mode: encrypt.AESMode.ecb));
                  final decrypted =
                      encrypter.decrypt64(resultPayment.urlPayment!, iv: iv);
                  final payooDecode =
                      PaymentPayooEncryptModel.fromJson(json.decode(decrypted));
                  if (payooDecode.secretKey != null &&
                      payooDecode.secretKey!.isNotEmpty) {
                    houzepayoosdk ??= new Houzepayoosdk(
                        clientId: payooDecode.clientId.toString(),
                        secretKey: payooDecode.secretKey ?? "",
                        isTestMode: resultPayment.isTestMode!);
                    houzepayoosdk!.payWithOrder(
                        resultPayment.info!, payooDecode.checksum!);
                    houzepayoosdk!.onPaymentStateChanged.listen((s) {
                      print("trang thai thanh toan: ${s.toString()}");
                      if (s == kFailed) {
                        EventController.showFailurePayooPopup(
                          isShowButtonBackToRoot: true,
                          // callback: () {
                          //   Navigator.of(context).popUntil(
                          //     (route) {
                          //       print(route.settings.name);
                          //       if (route.settings.name == AppRouter.ROOT) {
                          //         return true;
                          //       }
                          //       return false;
                          //     },
                          //   );
                          // }
                        );
                        return;
                      }
                      if (s == kSuccess) {
                        EventController.showPaidSuccessfullyPopup(
                          isShowButtonBackToRoot: true,
                          // callback: () {
                          //   Navigator.of(context).popUntil(
                          //     (route) {
                          //       print(route.settings.name);
                          //       if (route.settings.name == AppRouter.ROOT) {
                          //         return true;
                          //       }
                          //       return false;
                          //     },
                          //   );
                          // },
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
                  print(e.toString());
                }
              } else if (paymentModel.gateway == "zalo") {
                try {
                  final info = json.decode(resultPayment.info!);
                  //ZaloPay Demo
                  String response = "";
                  try {
                    final String result =
                        await platform.invokeMethod('payOrder', {
                      "zptoken": info["zp_trans_token"],
                      "appId": info["app_id"],
                      "isTestMode": resultPayment.isTestMode! == true,
                    });
                    response = result;
                    print("payOrder Result: '$result'.");
                  } on PlatformException catch (e) {
                    print("Failed to Invoke: '${e.message}'.");
                    response = "payment_failedsd";
                    AppDialog.showAlertDialog(
                      context,
                      "announcement",
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
                      },
                    );
                  }
                } catch (e) {
                  print(e);
                }

                // End ZaloPay
              } else {
                if (await canLaunch(resultPayment.urlPayment!)) {
                  await launch(resultPayment.urlPayment!, forceSafariVC: false);
                } else {
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
                }
              }
            } catch (e) {
              AppDialog.showAlertDialogForPayment(context, "announcement",
                  'this_payment_method_is_under_maintenance');
            } finally {
              AppController().updateOrderPage();
              processHub.state.dismiss();
            }
          },
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => false;
}
