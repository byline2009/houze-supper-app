import 'package:flutter/material.dart';
import 'package:houze_super/presentation/index.dart';

class DistanceAndTimeStatistic extends StatelessWidget {
  const DistanceAndTimeStatistic({
    @required this.distance,
    @required this.accumulationTime,
  });

  final double distance;
  final double accumulationTime;

  @override
  Widget build(BuildContext context) {
    final String _distanceKm = StringUtil.kilometerDisplay(distance);
    final String _hour = StringUtil.hourDisplay(accumulationTime);

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                LocalizationsUtil.of(context).translate(
                    'k_accumulated_distance'), //'Quãng đường tích luỹ',
                style: AppFonts.semibold13.copyWith(
                  color: Color(0xff838383),
                ),
              ),
              const SizedBox(height: 5),
              RichText(
                text: TextSpan(
                  style: AppFonts.bold18,
                  children: <TextSpan>[
                    TextSpan(text: _distanceKm),
                    TextSpan(text: ' km')
                  ],
                ),
              ),
            ],
          ),
        ),
        _verticalDivider(),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  LocalizationsUtil.of(context)
                      .translate('k_accumulation_time'), //'Thời gian tích luỹ',
                  style: AppFonts.semibold13.copyWith(
                    color: Color(0xff838383),
                  )),
              const SizedBox(height: 5),
              RichText(
                text: TextSpan(
                  style: AppFonts.bold18,
                  children: <TextSpan>[
                    TextSpan(text: _hour),
                    TextSpan(
                      text: ' ' +
                          LocalizationsUtil.of(context).translate('k_hour'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _verticalDivider() => Container(
        margin: EdgeInsets.only(right: 15),
        width: 1,
        height: 30,
        decoration: BoxDecoration(
          color: Color(
            0xffc4c4c4,
          ),
        ),
      );
}
