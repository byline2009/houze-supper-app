import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:houze_super/middle/model/fee_model.dart';
import 'package:houze_super/presentation/base/route_aware_state.dart';
import 'package:houze_super/presentation/common_widgets/cupertino_model_popup_custom.dart';
import 'package:houze_super/presentation/common_widgets/widget_home_scaffold.dart';
import 'package:houze_super/presentation/common_widgets/widget_no_data_display.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/presentation/screen/payment/blocs/fee/index.dart';
import 'package:houze_super/presentation/screen/payment/sc_fee_info.dart';
import 'package:houze_super/utils/custom_exceptions.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'extended/widget_item_fee_payment.dart';

class FeeChartScreen extends StatefulWidget {
  final String apartmentId;
  final int feeType;
  final String buildingId;

  FeeChartScreen({
    required this.buildingId,
    required this.apartmentId,
    required this.feeType,
  });

  @override
  _FeeChartScreenState createState() => _FeeChartScreenState();
}

class _FeeChartScreenState extends RouteAwareState<FeeChartScreen> {
  final FeeBloc feeBloc = FeeBloc();

  final years = List<int>.generate(3, (i) => DateTime.now().year - i);

  late int year;

  String formatNum(double number) => NumberFormat('đ #,###').format(number);

  late List<FeeByMonth> feeByMonths;

  final listTemp = <FeeDetailMessageModel>[];
  final list = <FeeDetailMessageModel>[];

  final refreshController = RefreshController();

  int page = 0;
  bool shouldLoadMore = true;

  Future<void> onRefresh() async {
    page = 0;
    listTemp.clear();
    list.clear();
    shouldLoadMore = true;

    feeBloc.add(
      FeeChart(
        building: widget.buildingId,
        apartment: widget.apartmentId,
        year: year,
        feeType: widget.feeType,
        page: page,
      ),
    );

    refreshController.refreshCompleted();
  }

  Future<void> onLoading() async {
    if (shouldLoadMore) {
      listTemp.clear();

      feeBloc.add(
        FeeChart(
          building: widget.buildingId,
          apartment: widget.apartmentId,
          year: year,
          feeType: widget.feeType,
          page: ++page,
        ),
      );

      refreshController.loadComplete();
    }
  }

  String _getAppBarTitle(int type) {
    switch (type) {
      case 0:
        return 'management_fee_history';
      case 1:
        return 'rental_fee_history';
      case 2:
        return 'water_fee_history';
      case 3:
        return 'electricity_fee_history';
      case 4:
        return 'service_fee_history';
      case 5:
        return 'others_fee_history';
      case 6:
        return 'parking_fee_history';
      case 7:
        return 'gas_fee_history';
      default:
        return '';
    }
  }

  String _getNoFeeData(int type) {
    switch (type) {
      case 0:
        return 'no_management_fee_data';
      case 1:
        return 'no_rental_fee_data';
      case 2:
        return 'no_water_fee_data';
      case 3:
        return 'no_electricity_fee_data';
      case 4:
        return 'no_service_fee_data';
      case 5:
        return 'no_others_fee_data';
      case 6:
        return 'no_parking_fee_data';
      case 7:
        return 'no_gas_fee_data';
      default:
        return '';
    }
  }

  @override
  void initState() {
    super.initState();

    year = years.first;
  }

  @override
  void dispose() {
    refreshController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scHeight = MediaQuery.of(context).size.height;

    return HomeScaffold(
      title: _getAppBarTitle(widget.feeType),
      child: Column(
        children: [
          buildYearPicker(years),
          Flexible(
            child: BlocProvider<FeeBloc>(
              create: (_) => feeBloc,
              child: BlocBuilder<FeeBloc, FeeState>(
                builder: (_, FeeState state) {
                  if (state is FeeInitial)
                    feeBloc
                      ..add(
                        FeeChart(
                          building: widget.buildingId,
                          apartment: widget.apartmentId,
                          year: year,
                          feeType: widget.feeType,
                          page: page,
                        ),
                      );

                  if (state is FeeFailure &&
                      state.error.error is! NoDataToLoadMoreException) {
                    if (state.error.error is NoDataException)
                      return SomethingWentWrong(true);
                    else
                      return SomethingWentWrong();
                  }

                  if (state is FeeLoadListLoading && page == 0)
                    return Padding(
                      child: ListSkeleton(
                        shrinkWrap: true,
                        length: 6,
                        config: SkeletonConfig(
                          theme: SkeletonTheme.Light,
                          isShowAvatar: true,
                          isCircleAvatar: true,
                          bottomLinesCount: 3,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                    );

                  if (state is FeeByMonthGetSuccessful && listTemp.isEmpty) {
                    feeByMonths = state.feeByMonths;

                    final List<FeeDetailMessageModel> temp =
                        (state.feeList.results as List)
                            .map((e) => FeeDetailMessageModel.fromJson(e))
                            .toList()
                          ..removeWhere((e) => e.status == 0);

                    shouldLoadMore = temp.length >= 10;
                    listTemp.addAll(temp);
                    list.addAll(temp);
                  }

                  return SmartRefresher(
                    enablePullUp: true,
                    controller: refreshController,
                    onRefresh: onRefresh,
                    onLoading: onLoading,
                    header: MaterialClassicHeader(),
                    footer: CustomFooter(
                      builder: (BuildContext context, LoadStatus mode) {
                        Widget body;
                        if (shouldLoadMore == false) {
                          mode = LoadStatus.noMore;
                        }

                        if (mode == LoadStatus.idle ||
                            mode == LoadStatus.loading) {
                          body = CupertinoActivityIndicator();
                        } else {
                          body = NoDataBottomLine(parentContext: context);
                        }
                        return SizedBox(
                          height: 80,
                          child: Align(child: body),
                        );
                      },
                    ),
                    child: list.isNotEmpty
                        ? SingleChildScrollView(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                buildFeeChart(feeByMonths),
                                SizedBox(height: 40.0),
                                buildFeeItem(
                                  height: scHeight,
                                  fees: list,
                                ),
                              ],
                            ))
                        : Align(
                            child: Text(
                              LocalizationsUtil.of(context).translate(
                                _getNoFeeData(widget.feeType),
                              ),
                            ),
                          ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Column buildFeeChart(List<FeeByMonth> fees) {
    final double averagePrice = fees
            .map((e) => e.totalFee)
            .reduce((value, element) => value! + element!)! /
        fees.length;

    final chartItems = List<_ChartItem>.generate(
      12,
      (i) {
        final FeeByMonth fee = fees.firstWhere((e) => e.month! - 1 == i,
            orElse: () => FeeByMonth());

        return _ChartItem(month: i + 1, price: fee.totalFee ?? 0);
      },
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(LocalizationsUtil.of(context).translate('average'),
            style: AppFont.BOLD_9c9c9c_15),
        RichText(
          text: TextSpan(
            style: AppFonts.bold18,
            children: <TextSpan>[
              TextSpan(text: 'đ ${StringUtil.numberFormat(averagePrice)}'),
              TextSpan(
                text: ' / ${LocalizationsUtil.of(context).translate('month')}',
                style: AppFont.SEMIBOLD_GRAY_9c9c9c_13,
              )
            ],
          ),
        ),
        SizedBox(height: 16.0),
        SfCartesianChart(
          plotAreaBorderWidth: 0,
          primaryXAxis: CategoryAxis(
            majorGridLines: MajorGridLines(width: 0),
            majorTickLines: MajorTickLines(width: 0),
            axisLine: AxisLine(color: Color(0xffc4c4c4)),
            tickPosition: TickPosition.inside,
          ),
          primaryYAxis: NumericAxis(
            majorGridLines: MajorGridLines(width: 0),
            majorTickLines: MajorTickLines(width: 0),
            opposedPosition: true,
            axisLine: AxisLine(width: 0.0),
            tickPosition: TickPosition.inside,
            numberFormat: NumberFormat.compact(),
          ),
          tooltipBehavior: TooltipBehavior(
            enable: true,
            builder: (dynamic data, dynamic point, dynamic series,
                int pointIndex, int seriesIndex) {
              return Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12.0, vertical: 10.0),
                decoration: BoxDecoration(
                  color: Color(0xfff5f5f5),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      LocalizationsUtil.of(context).translate(
                            StringUtil.getMonthStr(data.month),
                          ) +
                          '$year',
                      style: AppFont.SEMIBOLD_GRAY_9c9c9c_13,
                    ),
                    SizedBox(height: 4.0),
                    Text(formatNum(data.price), style: AppFont.BOLD_BLACK_15),
                  ],
                ),
              );
            },
          ),
          series: <ColumnSeries<_ChartItem, dynamic>>[
            ColumnSeries<_ChartItem, dynamic>(
              dataSource: chartItems,
              xValueMapper: (_ChartItem chartItems, _) => chartItems.month,
              yValueMapper: (_ChartItem chartItems, _) => chartItems.price,
              width: 1.0,
              spacing: 0.3,
              color: Color(0xffdac0ff),
              initialSelectedDataIndexes: [
                chartItems.lastIndexWhere((e) => e.price != 0)
              ],
              selectionBehavior: SelectionBehavior(
                enable: true,
                selectedColor: Color(0xff6001d2),
                unselectedColor: Color(0xffdac0ff),
                unselectedOpacity: 1.0,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildFeeItem({
    required double height,
    required List<FeeDetailMessageModel> fees,
  }) {
    return Wrap(
      runSpacing: 20.0,
      children: fees
          .map((e) => GestureDetector(
                onTap: () {
                  AppRouter.pushDialog(
                    context,
                    AppRouter.FEE_INFO_PAGE,
                    FeeInfoScreenArgument(id: e.id!),
                  );
                },
                child: Container(
                  width: double.infinity,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Color(0xfff5f5f5),
                    ),
                    borderRadius: BorderRadius.circular(4.0),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        offset: Offset(0, 2.0),
                        blurRadius: 10.0,
                        color: Color.fromRGBO(0, 0, 0, 0.1),
                      ),
                    ],
                  ),
                  child: WidgetItemFeePayment(fee: e),
                ),
              ))
          .toList(),
    );
  }

  Container buildYearPicker(List<int> years) {
    return Container(
      height: 52.0,
      color: const Color(0xfff5f5f5),
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(LocalizationsUtil.of(context).translate('fee_chart')),
          CupertinoModelPopupCustom(
            items: years,
            item: year,
            setItem: (value) {
              year = value;

              onRefresh();
            },
          ),
        ],
      ),
    );
  }
}

class _ChartItem {
  final int month;
  final double price;

  _ChartItem({required this.month, required this.price});
}
