import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:houze_super/middle/model/fee_model.dart';
import 'package:houze_super/presentation/common_widgets/stateless/button_widget.dart';
import 'package:houze_super/presentation/common_widgets/stateful/checkbox_widget.dart';
import 'package:houze_super/presentation/common_widgets/stateful/text_event_widget.dart';
import 'package:houze_super/presentation/common_widgets/stateless/widget_base_scaffold.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/presentation/screen/base/base_widget.dart';
import 'package:houze_super/presentation/screen/payment/sc_fee_gateway.dart';
import 'package:houze_super/utils/localizations_util.dart';
import 'package:houze_super/utils/settings/fee.dart';

//---SCREEN: Thanh toán hóa đơn---//

class FeeCheckoutScreenArgument {
  final List<FeeMessageModel> fees;
  final String buildingId;
  final String apartmentId;
  final Function callback;

  const FeeCheckoutScreenArgument({
    @required this.fees,
    @required this.buildingId,
    @required this.apartmentId,
    this.callback,
  });
}

class FeeCheckoutScreen extends StatefulWidget {
  final FeeCheckoutScreenArgument args;
  const FeeCheckoutScreen({
    Key key,
    this.args,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _FeeCheckoutScreenState();
}

class _FeeCheckoutScreenState extends State<FeeCheckoutScreen> {
  StreamController<CheckboxSubmitEvent> checkList =
      StreamController<CheckboxSubmitEvent>.broadcast();
  StreamController<ButtonSubmitEvent> nextPayment =
      StreamController<ButtonSubmitEvent>.broadcast();
  StreamController<TextEvent> totalPickedController =
      StreamController<TextEvent>();
  StreamController<TextEvent> totalfeePickedController =
      StreamController<TextEvent>();

  CheckboxSubmitEvent bindingValues = CheckboxSubmitEvent();
  int totalPicked = 0;
  double totalFeePicked = 0;
  int totalCanPick = 0;

  @override
  void initState() {
    super.initState();
    bindingValues.values["*"] = false;

    //Filter all fee total == 0
    widget.args.fees.removeWhere((item) {
      if (item.total > 0) {
        bindingValues.values[item.type] = false;
      }
      return item.total == 0;
    });
    totalCanPick = widget.args.fees.length;
  }

  @override
  void dispose() {
    totalPickedController.close();
    totalfeePickedController.close();
    nextPayment.close();
    checkList.close();
    super.dispose();
  }

  void checkPick() {
    double _total = 0;
    if (bindingValues.values.containsValue(true)) {
      nextPayment.sink.add(ButtonSubmitEvent(true));
    } else {
      nextPayment.sink.add(ButtonSubmitEvent(false));
    }

    widget.args.fees.forEach((item) {
      if (item.total > 0 && bindingValues.values[item.type]) {
        _total += item.total;
      }
    });
    totalFeePicked = _total;

    totalPickedController.sink.add(TextEvent(
        LocalizationsUtil.of(context).translate('selected_with_colon') +
            ' $totalPicked'));
    totalfeePickedController.sink
        .add(TextEvent("đ ${StringUtil.numberFormat(_total)}"));
  }

  void selectAll(String id) {
    var _totalPicked = 0;
    if (id == "*") {
      bindingValues.values.forEach((key, value) {
        if (key != "*") {
          bindingValues.values[key] = bindingValues.values[id];
          if (bindingValues.values[key] == true) {
            _totalPicked++;
          }
        }
        return value;
      });
      totalPicked = _totalPicked;
      checkPick();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: 'pay_for_bill',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            padding:const EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
            color: Color(0xfff5f5f5),
            child: Text(
              LocalizationsUtil.of(context).translate('chose_fee_resident_pay'),
              style: AppFonts.medium.copyWith(color: Color(0xff808080)),
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(right: 20, bottom: 0.0, top: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  CheckboxWidget(
                    id: "*",
                    label: Text(
                      LocalizationsUtil.of(context).translate('select_all'),
                    ),
                    callback: (id, isCheck) {
                      selectAll(id);
                    },
                    controller: checkList,
                    binding: bindingValues,
                    initSelected: true,
                  ),
                  TextEventWidget(
                    text: 'selected_0',
                    controller: totalPickedController,
                  ),
                ],
              )),
          Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: widget.args.fees.length,
                  itemBuilder: (_, index) {
                    final fee = widget.args.fees[index];
                    final feeInfo = FeeSettings.feeTypes.firstWhere(
                        (item) => item.type == widget.args.fees[index].type);

                    return Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: BaseWidget.containerRounderRegular(Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 5),
                            child: CheckboxWidget(
                              id: fee.type,
                              label: Row(children: <Widget>[
                                SvgPicture.asset(
                                    "assets/svg/fee/ic-fee-${fee.type}.svg"),
                                const SizedBox(width: 20),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      LocalizationsUtil.of(context)
                                          .translate(feeInfo.title),
                                      style: AppFonts.medium14
                                          .copyWith(color: Colors.black),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      "đ ${StringUtil.numberFormat(fee.total)}",
                                      style: fee.total != 0
                                          ? AppFonts.medium13.copyWith(
                                              color: Color(0xff6001d2))
                                          : AppFonts.semibold13.copyWith(
                                              color: Color(0xff808080)),
                                    )
                                  ],
                                )
                              ]),
                              callback: (id, isCheck) {
                                if (isCheck) {
                                  totalPicked++;
                                  if (totalPicked == totalCanPick) {
                                    bindingValues.values["*"] = true;
                                  }
                                } else {
                                  if (totalPicked - 1 > -1) {
                                    totalPicked--;
                                  }
                                  bindingValues.values["*"] = false;
                                }
                                checkPick();
                              },
                              controller: checkList,
                              binding: bindingValues,
                            ))));
                  })),
          bottomButtonPayment()
        ],
      ),
    );
  }

  Widget bottomButtonPayment() {
    return StreamBuilder(
      stream: nextPayment.stream,
      initialData: ButtonSubmitEvent(false),
      builder:
          (BuildContext context, AsyncSnapshot<ButtonSubmitEvent> snapshot) {
        totalfeePickedController = StreamController<TextEvent>();

        if (snapshot.data.isActive) {
          return BaseWidget.containerBodyTopShadow(
            SafeArea(
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, bottom: 20.0, top: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            LocalizationsUtil.of(context)
                                .translate("total_fee_selected_with_colon"),
                            style: AppFonts.bold15,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            LocalizationsUtil.of(context).translate(
                                "đ ${StringUtil.numberFormat(totalFeePicked)}"),
                            style: AppFonts.bold18
                                .copyWith(color: Color(0xff6001d2)),
                          ),
                        ],
                      )),
                      SizedBox(
                        width: 120.w,
                        child: ButtonWidget(
                          defaultHintText: LocalizationsUtil.of(context)
                              .translate('continue'),
                          callback: () {
                            AppRouter.push(
                              context,
                              AppRouter.PAYMENT_GATEWAY_PAGE,
                              FeeGatewayScreenArgument(
                                  fees: bindingValues.values,
                                  buildingId: widget.args.buildingId,
                                  apartmentId: widget.args.apartmentId,
                                  callback: widget.args.callback),
                            );
                          },
                          isActive: true,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
