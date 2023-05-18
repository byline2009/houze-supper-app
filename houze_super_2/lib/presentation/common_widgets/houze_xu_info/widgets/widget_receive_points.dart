import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:houze_super/utils/index.dart';

class WidgetReceiveXu extends StatelessWidget {
  final int xu;
  const WidgetReceiveXu({required this.xu});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  LocalizationsUtil.of(context)
                          .translate('houze_xu_will_be_received') +
                      ':',
                  style: AppFonts.bold14
                      .copyWith(
                        color: Color(0xff838383),
                      )
                      .copyWith(letterSpacing: 0.14),
                ),
                Row(
                  children: [
                    Text(
                      StringUtil.numberFormat(xu),
                      // style: AppFonts.semibold13
                      //     .copyWith(color: Color(0xffd68100))
                      //     .copyWith(
                      //       letterSpacing: 0.14,
                      //       fontSize: 18,
                      //       color: Color(0xffe3a500),
                      //     ),
                      style: AppFont.SEMIBOLD_BLACK_13
                          .copyWith(color: Color(0xffd68100))
                          .copyWith(
                            letterSpacing: 0.14,
                            fontSize: 18,
                            color: Color(0xffe3a500),
                          ),
                    ),
                    SizedBox(width: 5),
                    SvgPicture.asset(AppVectors.icPoint),
                  ],
                ),
              ],
            )),
      ],
    );
  }
}
