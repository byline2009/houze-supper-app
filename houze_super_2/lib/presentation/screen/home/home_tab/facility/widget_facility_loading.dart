import 'package:flutter/material.dart';
import 'package:houze_super/presentation/common_widgets/skeletons/src/skeleton/card_horizontal_skeleton.dart';

import '../../../../index.dart';

class FacilityIsLoadingBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FacilityItemLoading(),
        FacilityItemLoading(),
        FacilityItemLoading(),
      ],
    );
  }
}

class FacilityItemLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      padding: EdgeInsets.only(left: 20, top: 20),
      child: CardListHorizontalSkeleton(
        length: 1,
        width: MediaQuery.of(context).size.width - 40.0,
        config: SkeletonConfig(
          isCircleAvatar: true,
          isShowAvatar: true,
          theme: SkeletonTheme.Light,
          bottomLinesCount: 0,
          radius: 0.0,
        ),
      ),
    );
  }
}
