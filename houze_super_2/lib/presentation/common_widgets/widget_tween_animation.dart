import 'package:flutter/material.dart';

class TweenAnimationWidget extends StatelessWidget {
  final Widget widget;
  final Duration duration;
  TweenAnimationWidget({required this.widget, required this.duration});
  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      curve: Curves.easeIn,
      duration: duration,
      builder: (BuildContext context, double opacity, Widget? child) {
        return Opacity(opacity: opacity, child: widget);
      },
    );
  }
}
