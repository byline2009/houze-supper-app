import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class WidgetSlideAnimation extends StatelessWidget {
  final int position;
  final int? milliseconds;
  final Widget child;
  WidgetSlideAnimation(
      {required this.position, this.milliseconds, required this.child});
  @override
  Widget build(BuildContext context) {
    return AnimationConfiguration.staggeredList(
        position: position,
        duration: Duration(
            milliseconds: this.milliseconds == null ? 250 : this.milliseconds!),
        child: SlideAnimation(
            verticalOffset: 50.0, child: FadeInAnimation(child: child)));
  }
}
