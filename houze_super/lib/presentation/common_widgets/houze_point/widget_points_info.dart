import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/utils/constants/constants.dart';
import 'package:houze_super/utils/index.dart';
import 'package:houze_super/presentation/screen/home/home_tab/houze_xu_info/sc_houze_xu_info.dart';

class WidgetXuInfo extends StatelessWidget {
  final String textContent;
  final Function callback;
  final bool disabledChangeBuilding;
  const WidgetXuInfo(
      {@required this.textContent,
      this.callback,
      this.disabledChangeBuilding = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 17, horizontal: 20),
        color: AppColors.backgroundOrangeInfo,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: [
                SvgPicture.asset(AppVectors.icPoint),
                SizedBox(width: 10),
                Text(
                  textContent,
                  style: AppFonts.semibold13
                      .copyWith(color: Color(0xffd68100))
                      .copyWith(letterSpacing: 0.14),
                ),
              ],
            ),
            Icon(
              Icons.arrow_forward,
              color: Color(0xffd68100),
              size: 18,
            )
          ],
        ),
      ),
      onTap: () {
        AppRouter.push(
            context,
            AppRouter.HOUZE_XU_INFO_PAGE,
            HouzeXuInfoScreenArgument(
                callback: callback,
                disabledChangeBuilding: disabledChangeBuilding));
      },
    );
  }
}
