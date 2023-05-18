import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:houze_super/middle/model/fee_model.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/presentation/screen/payment/blocs/fee/index.dart';
import 'package:houze_super/presentation/screen/payment/order/fee/extended/widget_item_fee_payment.dart';
import 'package:houze_super/presentation/screen/payment/sc_fee_info.dart';

class HistoryFeeList extends StatefulWidget {
  final FeeModel fee;
  final String buildingId;
  final String apartmentId;

  HistoryFeeList({
    Key? key,
    required this.fee,
    required this.buildingId,
    required this.apartmentId,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HistoryFeeListState();
}

class _HistoryFeeListState extends State<HistoryFeeList> {
  late FeeModel _fee;
  final FeeBloc _bloc = FeeBloc();

  @override
  void initState() {
    super.initState();
    _fee = widget.fee;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FeeBloc>(
      create: (_) => _bloc,
      child: BlocBuilder<FeeBloc, FeeState>(
        builder: (_, FeeState state) {
          if (state is FeeInitial)
            _bloc.add(
              FeeLoadLimitList(
                limit: 2,
                apartment: widget.apartmentId,
                building: widget.buildingId,
                feeType: _fee.type!,
              ),
            );

          if (state is FeeLoadDetailSuccessful) {
            final List<FeeDetailMessageModel> fees = state.results
              ..removeWhere((e) => e.status == 0);

            final int numberOfSection = fees.length >= 2 ? 3 : fees.length + 1;

            return Stack(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(bottom: 20, top: 10),
                  height: 150.0,
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: numberOfSection,
                    itemBuilder: (BuildContext context, int index) {
                      var _left = index == 0 ? 20.0 : 10.0;

                      if (index == fees.length) {
                        return Padding(
                          child: _buildHistoryChartFee(),
                          padding: EdgeInsets.only(left: _left, right: 20),
                        );
                      }

                      FeeDetailMessageModel item = fees[index];
                      return GestureDetector(
                        onTap: () {
                          AppRouter.pushDialog(context, AppRouter.FEE_INFO_PAGE,
                              FeeInfoScreenArgument(id: item.id!));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                            border: Border.all(
                              color: AppColor.gray_f5f5f5,
                              width: 2.0,
                            ),
                          ),
                          margin: EdgeInsets.only(left: _left),
                          //margin: EdgeInsets.only(right: _right),
                          child: WidgetItemFeePayment(fee: item),
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  bottom: 0,
                  child: Container(
                    width: 33,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Colors.white.withAlpha(1), Colors.white]),
                    ),
                  ),
                ),
              ],
            );
          }

          return Stack(
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 20, top: 10),
                height: 151.0,
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: 2,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      margin: EdgeInsets.only(top: 10, left: 10),
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        border: Border.all(
                          color: AppColor.gray_f5f5f5,
                          width: 2.0,
                        ),
                      ),
                      height: 130.0,
                      width: 186,
                      child: CardSkeleton(
                        config: SkeletonConfig(
                          bottomLinesCount: 3,
                          isCircleAvatar: false,
                          isShowAvatar: false,
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          );
        },
      ),
    );
  }

  Widget _buildHistoryChartFee() {
    return GestureDetector(
      onTap: () {
        AppRouter.push(
          context,
          AppRouter.PAYMENT_FEE_CHART_SCREEN,
          {
            'building_id': widget.buildingId,
            'apartment_id': widget.apartmentId,
            'fee_type': _fee.type,
          },
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColor.gray_f5f5f5,
          border: Border.all(
            color: AppColor.gray_f5f5f5,
            width: 1,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(5.0),
          ),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(AppVectors.ic_bar_chart),
              SizedBox(height: 5),
              Text(
                LocalizationsUtil.of(context)
                    .translate('view_fee_chart_history'),
                style: AppFont.SEMIBOLD_BLACK_13,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
