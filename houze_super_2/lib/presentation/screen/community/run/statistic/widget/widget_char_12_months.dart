import 'package:flutter/material.dart';
import 'package:houze_super/presentation/screen/community/run/statistic/model/chart_model.dart';
import 'package:houze_super/utils/index.dart';

import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DisplayChartBy12Months extends StatelessWidget {
  final List<ChartModel> datasource;
  const DisplayChartBy12Months({Key? key, required this.datasource})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<ChartModel> data = [
      ChartModel(val: 'jan', day: '', totalDistance: 0.00),
      ChartModel(val: 'feb', day: '', totalDistance: 0.00),
      ChartModel(val: 'mar', day: '', totalDistance: 0.00),
      ChartModel(val: 'apr', day: '', totalDistance: 0.00),
      ChartModel(val: 'may', day: '', totalDistance: 0.00),
      ChartModel(val: 'jun', day: '', totalDistance: 0.00),
      ChartModel(val: 'jul', day: '', totalDistance: 0.00),
      ChartModel(val: 'aug', day: '', totalDistance: 0.00),
      ChartModel(val: 'sep', day: '', totalDistance: 0.00),
      ChartModel(val: 'oct', day: '', totalDistance: 0.00),
      ChartModel(val: 'nov', day: '', totalDistance: 0.00),
      ChartModel(val: 'dec', day: '', totalDistance: 0.00),
    ];
    if (datasource.length > 0)
      data.forEach((element) {
        datasource.forEach((item) {
          if (item.val!.toLowerCase() == element.val!.toLowerCase()) {
            int index = data.indexOf(element);
            data[index] = ChartModel(
                val: item.val!.toLowerCase(),
                day: item.day,
                totalDistance: item.totalDistance!);
          }
        });
      });

    return SizedBox(
      child: SfCartesianChart(
        zoomPanBehavior: ZoomPanBehavior(
            enablePanning: true,
            enableDoubleTapZooming: true,
            enableMouseWheelZooming: true,
            enableSelectionZooming: true),
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
              String day =
                  DateFormat('dd.MM').format(DateTime.parse(item.day!));

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
            edgeLabelPlacement: EdgeLabelPlacement.none,
            minimum: 0,
            tickPosition: TickPosition.inside,
            visibleMinimum: 0,
            visibleMaximum: 11,
            interval: 1,
            majorTickLines: MajorTickLines(width: 0),
            axisLine: AxisLine(color: Color(0xffd0d0d0)),
            majorGridLines: MajorGridLines(width: 0),
            labelStyle: AppFonts.semibold13
                .copyWith(color: Color(0xff9c9c9c))
                .copyWith(letterSpacing: 0.26)),
        primaryYAxis: NumericAxis(
          labelFormat: '{value} km',
          desiredIntervals: 1,
          decimalPlaces: 0,
          interval: 30,
          majorTickLines: MajorTickLines(width: 0),
          majorGridLines: MajorGridLines(width: 0),
          axisLine: AxisLine(color: Colors.white),
          opposedPosition: true,
          tickPosition: TickPosition.outside,
          labelStyle: AppFonts.semibold13
              .copyWith(color: Color(0xff9c9c9c))
              .copyWith(letterSpacing: 0.26),
          numberFormat: NumberFormat.compact(),
        ),
        series: <ColumnSeries<ChartModel, String>>[
          ColumnSeries<ChartModel, String>(
            dataSource: data,
            spacing: 0.5,
            borderRadius: BorderRadius.all(Radius.circular(40.0)),
            color: Color(0xffdac0ff),
            xValueMapper: (ChartModel chartItems, _) {
              return chartItems.valToMonth().toString();
            },
            yValueMapper: (ChartModel chartItems, _) =>
                chartItems.totalDistanceKm(),
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
    );
  }
}
