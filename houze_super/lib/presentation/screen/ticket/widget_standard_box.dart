import 'package:flutter/material.dart';

class WidgetStandardBox extends StatelessWidget {
  final Widget title;
  final Widget actions;

  WidgetStandardBox({@required this.title, this.actions})
      : assert(title != null);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        this.title,
        //Text(this.title, style: AppFonts.medium16.copyWith(letterSpacing: 0.26),),
        this.actions != null ? this.actions : const SizedBox.shrink()
      ],
    );
  }
}
