import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:houze_super/presentation/index.dart';

class TotalTeamBottom extends StatelessWidget {
  final int groupTotal;

  const TotalTeamBottom({
    Key key,
    @required this.groupTotal,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 30),
        Text(
          LocalizationsUtil.of(context).translate('k_currently_there_are'),
          textAlign: TextAlign.center,
          style: AppFonts.semibold13.copyWith(
            color: Color(0xff838383),
          ),
        ),
        const SizedBox(height: 5),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: AppFonts.bold
                .copyWith(color: Color(0xff6001d2)) //BOLD_purple6001d2
                .copyWith(fontSize: 24),
            children: <TextSpan>[
              TextSpan(text: groupTotal.toString() + ' '),
              TextSpan(
                  text: LocalizationsUtil.of(context)
                      .translate('k_participating_team'),
                  style: AppFonts.bold24)
            ],
          ),
        ),
        const SizedBox(height: 30),
        SvgPicture.asset(AppVectors.icWalkShoes),
        const SizedBox(height: 80),
      ],
    );
  }
}
