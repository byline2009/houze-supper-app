import 'package:flutter/material.dart';
import 'package:houze_super/utils/constants/constants.dart';
import 'package:houze_super/utils/index.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

enum WorkoutUnit { kilometer, step }

class ChartData {
  const ChartData(this.weekday, this.value, this.unit);
  final String weekday;
  final double value;
  final WorkoutUnit unit;
}

class BaseHealthChart extends StatelessWidget {
  final List<ChartData> datasources;
  const BaseHealthChart({@required this.datasources});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SfCartesianChart(
        tooltipBehavior: TooltipBehavior(
            enable: true,
            canShowMarker: true,
            tooltipPosition: TooltipPosition.auto,
            activationMode: ActivationMode.singleTap,
            color: Colors.black,
            builder: (dynamic data, dynamic point, dynamic series,
                int pointIndex, int seriesIndex) {
              ChartData item = data;
              String unit = item.unit == WorkoutUnit.kilometer ? 'km' : '';
              String value = item.unit == WorkoutUnit.kilometer
                  ? item.value.toStringAsFixed(2)
                  : item.value.toStringAsFixed(0);

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
                        Text('Hôm nay',
                            style: AppFonts.semibold13
                                .copyWith(color: Color(0xff9c9c9c))),
                        Text(value + ' ' + unit, style: AppFonts.bold15)
                      ]));
            }),
        plotAreaBorderWidth: 0,
        primaryXAxis: CategoryAxis(
            maximum: 6,
            edgeLabelPlacement: EdgeLabelPlacement.none,
            minimum: 0,
            tickPosition: TickPosition.inside,
            interval: 1,
            majorTickLines: MajorTickLines(width: 0),
            axisLine: AxisLine(color: Color(0xffd0d0d0)),
            majorGridLines: MajorGridLines(width: 0),
            labelStyle: AppFonts.semibold13
                .copyWith(color: Color(0xff9c9c9c))
                .copyWith(letterSpacing: 0.26)),
        primaryYAxis: NumericAxis(
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
        series: <ColumnSeries<ChartData, String>>[
          ColumnSeries<ChartData, String>(
            dataSource: datasources,
            spacing: 0.5,
            borderRadius: BorderRadius.all(Radius.circular(40.0)),
            color: Color(0xffdac0ff),
            xValueMapper: (ChartData chartItems, _) =>
                LocalizationsUtil.of(context)
                    .translate(chartItems.weekday.toLowerCase().toString()),
            yValueMapper: (ChartData chartItems, _) => chartItems.value,
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
