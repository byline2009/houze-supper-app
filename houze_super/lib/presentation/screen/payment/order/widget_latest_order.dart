import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import 'package:houze_super/presentation/screen/payment/bloc/payment/index.dart';
import 'package:houze_super/presentation/common_widgets/skeletons/src/skeleton/parking_image_card_skeleton.dart';
import 'package:houze_super/presentation/screen/base/base_widget.dart';

import 'package:houze_super/utils/constants/constants.dart';
import 'package:houze_super/utils/localizations_util.dart';

import 'draft_item.dart';

class WidgetLatestOrder extends StatefulWidget {
  final PaymentBloc paymentBloc;
  final TabController orderTabController;
  final Function callback;

  WidgetLatestOrder(
      {@required this.paymentBloc,
      this.orderTabController,
      this.callback,
      Key key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _WidgetLatestOrderState();
}

class _WidgetLatestOrderState extends State<WidgetLatestOrder> {
  Size _screenSize;
  var padding;
  final _controller = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    this._screenSize = MediaQuery.of(context).size;
    this.padding = this._screenSize.width * 5 / 100;

    return BlocProvider<PaymentBloc>(
      create: (_) => widget.paymentBloc,
      child: BlocBuilder<PaymentBloc, PaymentState>(
        builder: (BuildContext context, PaymentState paymentState) {
          if (paymentState is PaymentInitial) {
            widget.paymentBloc.add(PaymentLoadHistory(limit: 5, status: 0));
          }

          if (paymentState is PaymentLoadHistorySuccessful) {
            if (paymentState.result.length != 0) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                      bottom: 0,
                      top: 30,
                    ),
                    child: Row(
                      children: <Widget>[
                        SvgPicture.asset("assets/svg/feed/ic-0.svg"),
                        const SizedBox(width: 10),
                        Text(
                            LocalizationsUtil.of(context)
                                .translate('transaction_lasted')
                                .replaceAll(
                                    "{0}", paymentState.total.toString()),
                            style: AppFonts.regular14)
                      ],
                    ),
                  ),
                  Container(
                    height: 330,
                    padding: const EdgeInsets.only(top: 15, bottom: 20),
                    child: paymentState.result.length == 1
                        ? Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: DraftItem(
                              order: paymentState.result[0],
                              size: EnumDraftItemSize.full,
                              callback: widget.callback,
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            controller: _controller,
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            itemCount: paymentState.result.length,
                            itemBuilder: (BuildContext context, int index) {
                              //Padding left
                              if (index == 0) {
                                return Padding(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: DraftItem(
                                    order: paymentState.result[0],
                                    callback: widget.callback,
                                  ),
                                );
                              }
                              return DraftItem(
                                order: paymentState.result[index],
                                callback: widget.callback,
                              );
                            },
                          ),
                  )
                ],
              );
            }
          }

          // Loading
          if (paymentState is PaymentLoading) {
            return Column(
              children: [
                Padding(
                  padding:
                      EdgeInsets.only(left: 20, right: 20, bottom: 0, top: 30),
                  child: Row(
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(100.0)),
                        child: ParkingCardSkeleton(width: 20, height: 20),
                      ),
                      const SizedBox(width: 10),
                      ParkingCardSkeleton(width: 150, height: 10),
                    ],
                  ),
                ),
                Container(
                  height: 330,
                  padding: const EdgeInsets.only(top: 15, bottom: 20),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: BaseWidget.containerRounderRegular(
                        Container(
                          width: this._screenSize.width,
                          padding:
                              EdgeInsets.only(left: 15, right: 15, top: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    DecoratedBox(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Color(0xfff2f2f2),
                                              width: 2.0),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(14.0)),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(12.0)),
                                          child: Stack(
                                            overflow: Overflow.clip,
                                            children: <Widget>[
                                              ParkingCardSkeleton(
                                                  width: 40, height: 40),
                                            ],
                                          ),
                                        )),
                                    const SizedBox(width: 15),
                                    Expanded(
                                        child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ParkingCardSkeleton(
                                            width: 60, height: 10),
                                        SizedBox(height: 5),
                                        ParkingCardSkeleton(
                                            width: 60, height: 10),
                                      ],
                                    ))
                                  ]),
                              const SizedBox(height: 25),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ParkingCardSkeleton(width: 50, height: 10),
                                  ParkingCardSkeleton(width: 120, height: 10),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ParkingCardSkeleton(width: 50, height: 10),
                                  ParkingCardSkeleton(width: 100, height: 10),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ParkingCardSkeleton(width: 50, height: 10),
                                  ParkingCardSkeleton(width: 120, height: 10),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Expanded(
                                child:
                                    ParkingCardSkeleton(width: 100, height: 10),
                              ),
                              const SizedBox(height: 40),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
