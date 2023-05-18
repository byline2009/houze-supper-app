import 'package:flutter/material.dart';

import '../../../index.dart';

class TicketIsLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListView.builder(
        itemCount: 3,
        itemBuilder: (c, i) {
          return CardListSkeleton(
            shrinkWrap: true,
            length: 1,
            config: SkeletonConfig(
              theme: SkeletonTheme.Light,
              isShowAvatar: true,
              isCircleAvatar: true,
              bottomLinesCount: 2,
              radius: 0.0,
            ),
          );
        },
        padding: const EdgeInsets.symmetric(horizontal: 20),
      ),
    );
  }
}
