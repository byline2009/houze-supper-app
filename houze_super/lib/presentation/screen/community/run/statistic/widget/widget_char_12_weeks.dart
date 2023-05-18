import 'package:flutter/material.dart';
import 'package:houze_super/presentation/screen/community/run/statistic/model/chart_model.dart';
import 'package:houze_super/utils/index.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DisplayChartBy12Weeks extends StatelessWidget {
  final List<ChartModel> datasource;
  const DisplayChartBy12Weeks({
    Key key,
    @required this.datasource,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          child: SfCartesianChart(
            zoomPanBehavior: ZoomPanBehavior(enablePinching: true),
            tooltipBehavior: TooltipBehavior(
                enable: true,
                canShowMarker: true,
                tooltipPosition: TooltipPosition.auto,
                activationMode: ActivationMode.singleTap,
                color: Colors.black,
                builder: (dynamic data, dynamic point, dynamic series,
                    int pointIndex, int seriesIndex) {
                  ChartModel item = data;
                  String unit = 'km';
                  String value = item.totalDistanceKm().toStringAsFixed(2);
                  String day = item.day;
                  print('day' + day);
                  return Container(
                      height: 62,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 13.0, vertical: 5.0),
                      decoration: BoxDecoration(
                          color: Color(0xfff5f5f5),
                          borderRadius: BorderRadius.circular(4.0)),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(day,
                                style: AppFonts.semibold13
                                    .copyWith(color: Color(0xff9c9c9c))),
                            SizedBox(
                              height: 5,
                            ),
                            Text(value + ' ' + unit, style: AppFonts.bold15)
                          ]));
                }),
            plotAreaBorderWidth: 0,
            primaryXAxis: CategoryAxis(
              interval: 2,
              isVisible: true,
              majorTickLines: MajorTickLines(width: 0),
              majorGridLines: MajorGridLines(width: 0),
              placeLabelsNearAxisLine: false,
              tickPosition: TickPosition.outside,
              axisLine: AxisLine(
                width: 1,
                color: Color(0xffc4c4c4),
              ),
            ),
            primaryYAxis: NumericAxis(
              labelFormat: '{value} km',
              decimalPlaces: 0,
              interval: 20,
              minimum: 0,
              majorTickLines: MajorTickLines(width: 0),
              majorGridLines: MajorGridLines(width: 0),
              axisLine: AxisLine(color: Colors.transparent),
              opposedPosition: true,
              tickPosition: TickPosition.inside,
              labelStyle: AppFonts.semibold13
                  .copyWith(color: Color(0xff9c9c9c))
                  .copyWith(letterSpacing: 0.26),
              numberFormat: NumberFormat.compact(),
            ),
            series: <ColumnSeries<ChartModel, String>>[
              ColumnSeries<ChartModel, String>(
                xValueMapper: (ChartModel chartItems, _) => DateFormat('MM-dd')
                    .format(new DateFormat("yyyy-MM-dd").parse(chartItems.day)),
                yValueMapper: (ChartModel chartItems, _) =>
                    chartItems.totalDistanceKm(),
                dataSource: datasource,
                spacing: 0.5,
                borderRadius: BorderRadius.all(Radius.circular(40.0)),
                color: Color(0xffdac0ff),
                selectionBehavior: SelectionBehavior(
                  enable: true,
                  selectedColor: Color(0xff5b00e4),
                  unselectedColor: Color(0xffdac0ff),
                  unselectedOpacity: 1.0,
                ),
              ),
            ],
          ),
          height: 200,
        ),
        // Container(
        //   alignment: Alignment.topCenter,
        //   margin: EdgeInsets.only(left: 15, right: 40),
        //   height: 1,
        //   color: Color(0xffc4c4c4),
        // ),
        // SizedBox(
        //   height: 2,
        // ),
        // Container(
        //   height: 20,
        //   padding: EdgeInsets.only(left: 15, right: 40),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.start,
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
        //       Text('Th 3', style: AppFonts.semibold13.copyWith(color: Color(0xff9c9c9c))),
        //       SizedBox(width: size),
        //       Text('Th 4', style: AppFonts.semibold13.copyWith(color: Color(0xff9c9c9c))),
        //       SizedBox(width: size),
        //       Text('Th 5', style: AppFonts.semibold13.copyWith(color: Color(0xff9c9c9c))),
        //     ],
        //   ),
        // ),
      ],
    );
  }
}
