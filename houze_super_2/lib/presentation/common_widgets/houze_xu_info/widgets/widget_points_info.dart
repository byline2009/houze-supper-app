import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:houze_super/presentation/index.dart';
import '../sc_houze_xu_info.dart';

class WidgetXuInfo extends StatelessWidget {
  final String textContent;
  final Function? callback;
  final bool disabledChangeBuilding;
  const WidgetXuInfo(
      {required this.textContent,
      this.callback,
      this.disabledChangeBuilding = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(vertical: 17, horizontal: 20),
        color: AppColor.backgroundOrangeInfo,
        child: LayoutBuilder(builder: (context, constraint) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: constraint.maxWidth),
              child: IntrinsicWidth(
                child: Row(
                  children: [
                    SvgPicture.asset(AppVectors.icPoint),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        textContent,
                        style: AppFont.SEMIBOLD_BLACK_13
                            .copyWith(color: Color(0xffd68100))
                            .copyWith(letterSpacing: 0.14),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward,
                      color: Color(0xffd68100),
                      size: 18,
                    )
                  ],
                ),
              ),
            ),
          );
        }),
      ),
      onTap: () {
        AppRouter.push(
            context,
            AppRouter.HOUZE_XU_INFO_PAGE,
            HouzeXuInfoPageArgument(
                callback: callback ?? () {},
                disabledChangeBuilding: disabledChangeBuilding));
      },
    );
  }
}
