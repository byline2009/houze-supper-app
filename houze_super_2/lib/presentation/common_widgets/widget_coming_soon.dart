import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:houze_super/presentation/common_widgets/skeletons/src/skeleton/parking_image_card_skeleton.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/utils/index.dart';

class WidgetComingSoon extends StatelessWidget {
  const WidgetComingSoon();
  @override
  Widget build(BuildContext context) {
    double _widthImg = 300 * (ScreenUtil.defaultSize.width / 375);
    final String content =
        "our_quality_services_provided_by_houze’s_trusted_partners_is_coming_soon_to_serve_you_in_the_next_version";
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 80,
      ),
      children: [
        SizedBox(
          child: SvgPicture.asset(
            AppVectors.icComingsoonService,
            allowDrawingOutsideViewBox: true,
            placeholderBuilder: (BuildContext context) {
              return ParkingCardSkeleton(
                height: 165.0,
                width: _widthImg,
              );
            },
          ),
          height: 165.0,
          width: _widthImg,
        ),
        SizedBox(height: 20),
        Text(
          LocalizationsUtil.of(context).translate(content),
          textAlign: TextAlign.center,
          maxLines: 3,
          style: AppFonts.regular15
              .copyWith(
                color: Color(
                  0xff808080,
                ),
              )
              .copyWith(letterSpacing: 0.24),
        ),
        SizedBox(height: 20),
        GridViewBrand(),
      ],
    );
  }
}

class GridViewBrand extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final list = [
      AppImages.btaskee,
      AppImages.foodmap,
      AppImages.meete,
      AppImages.ic25Fit,
      AppImages.aharent,
    ];
    var _spacing = 22.0;
    var _width = (ScreenUtil.defaultSize.width - 40 - _spacing) / 2;
    return Wrap(
      spacing: _spacing,
      runSpacing: 10.0,
      children: list.map((item) {
        return SizedBox(
          width: list.first == item ? double.infinity : _width,
          height: 60,
          child: Center(
            child: Image(
              image: AssetImage(item),
            ),
          ),
        );
      }).toList(),
    );
  }
}
