import 'package:flutter/material.dart';
import 'package:houze_super/presentation/screen/community/run/statistic/model/chart_model.dart';

import 'package:houze_super/utils/index.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DisplayChartByWeek extends StatelessWidget {
  final List<ChartModel> datasource;
  const DisplayChartByWeek({Key? key, required this.datasource})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<ChartModel> data = [
      ChartModel(val: 'monday', day: '', totalDistance: 0.00),
      ChartModel(val: 'tuesday', day: '', totalDistance: 0.00),
      ChartModel(val: 'wednesday', day: '', totalDistance: 0.00),
      ChartModel(val: 'thursday', day: '', totalDistance: 0.00),
      ChartModel(val: 'friday', day: '', totalDistance: 0.00),
      ChartModel(val: 'saturday', day: '', totalDistance: 0.00),
      ChartModel(val: 'sunday', day: '', totalDistance: 0.00),
    ];
    data.forEach((element) {
      datasource.forEach((item) {
        if (item.valToWeekday() == element.val) {
          int index = data.indexOf(element);
          data[index] = ChartModel(
              val: item.valToWeekday(),
              day: item.day,
              totalDistance: item.totalDistance!.kilometers().decimalPoint(2));
        }
      });
    });

    return SizedBox(
      child: SfCartesianChart(
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
              String value = item.totalDistance.toString();
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
                            style: AppFonts.semibold13.copyWith(
                                color: Color(
                                    0xff9c9c9c))), //semibold13.copyWith(color: Color(0xff9c9c9c))),
                        SizedBox(
                          height: 5,
                        ),
                        Text(value + ' ' + unit, style: AppFonts.bold15)
                      ]));
            }),
        plotAreaBorderWidth: 0,
        primaryXAxis: CategoryAxis(
            maximum: 6,
            edgeLabelPlacement: EdgeLabelPlacement.none,
            minimum: 0,
            tickPosition: TickPosition.inside,
            visibleMinimum: 0,
            visibleMaximum: 6,
            arrangeByIndex: true,
            interval: 1,
            majorTickLines: MajorTickLines(width: 0),
            axisLine: AxisLine(color: Color(0xffd0d0d0)),
            majorGridLines: MajorGridLines(width: 0),
            labelStyle: AppFonts.semibold13
                .copyWith(color: Color(0xff9c9c9c))
                .copyWith(letterSpacing: 0.26)),
        primaryYAxis: NumericAxis(
          plotOffset: 0.0,
          interval: 2,
          labelFormat: '{value} km',
          decimalPlaces: 0,
          minimum: 0,
          majorTickLines: MajorTickLines(width: 0),
          majorGridLines: MajorGridLines(width: 0),
          axisLine: AxisLine(color: Color(0xffd0d0d0)),
          opposedPosition: true,
          tickPosition: TickPosition.inside,
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
            xValueMapper: (ChartModel chartItems, _) =>
                LocalizationsUtil.of(context).translate(chartItems.val),
            yValueMapper: (ChartModel chartItems, _) =>
                chartItems.totalDistance,
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
