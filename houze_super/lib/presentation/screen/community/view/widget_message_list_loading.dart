import 'package:flutter/material.dart';

import '../../../index.dart';

class MessageListLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListSkeleton(
      length: 4,
      shrinkWrap: true,
      config: SkeletonConfig(
        bottomLinesCount: 0,
        isCircleAvatar: true,
        isShowAvatar: true,
        theme: SkeletonTheme.Light,
      ),
    );
  }
}
