import 'package:flutter/material.dart';

import '../skeleton_config.dart';
import './list_tile_skeleton.dart';

class ListSkeleton extends StatelessWidget {
  final SkeletonConfig config;
  final int length;
  final bool shrinkWrap;

  ListSkeleton({
    Key? key,
    this.config: const SkeletonConfig.origin(),
    this.length: 10,
    this.shrinkWrap = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: this.shrinkWrap,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: length,
      padding: const EdgeInsets.all(0),
      separatorBuilder: (BuildContext context, int index) {
        return Divider(color: Theme.of(context).dividerColor, height: 1.0);
      },
      itemBuilder: (BuildContext context, int index) {
        return Container(child: ListTileSkeleton(config: config));
      },
    );
  }
}
