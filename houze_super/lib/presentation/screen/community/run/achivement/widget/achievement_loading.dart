import 'package:flutter/material.dart';
import 'package:houze_super/presentation/common_widgets/skeletons/src/skeleton/card_horizontal_skeleton.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/presentation/screen/base/base_widget.dart';

class AchievementIsLoading extends StatelessWidget {
  const AchievementIsLoading();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BaseWidget.decorationDividerGray,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      height: 120,
      child: CardListHorizontalSkeleton(
        length: 3,
        shrinkWrap: true,
        width: 100,
        height: 100,
        config: SkeletonConfig(
          isCircleAvatar: false,
          isShowAvatar: false,
          theme: SkeletonTheme.Light,
          bottomLinesCount: 0,
          radius: 8.0,
        ),
      ),
    );
  }
}
