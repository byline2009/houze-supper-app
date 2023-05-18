import 'package:flutter/material.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/utils/index.dart';

class WidgetMiniBox extends StatefulWidget {
  final String title;
  final Widget child;
  final double height;
  final TextStyle titleStyle;

  WidgetMiniBox(
      {@required this.title, this.child, this.height, this.titleStyle})
      : assert(title != null);

  @override
  WidgetMiniBoxState createState() => new WidgetMiniBoxState();
}

class WidgetMiniBoxState extends State<WidgetMiniBox> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              LocalizationsUtil.of(context).translate(widget.title),
              style: widget.titleStyle ??
                  AppFonts.medium14.copyWith(color: Colors.black),
            ),
          ],
        ),
        SizedBox(height: widget.height ?? 9),
        widget.child ?? const SizedBox.shrink()
      ],
    );
  }
}
