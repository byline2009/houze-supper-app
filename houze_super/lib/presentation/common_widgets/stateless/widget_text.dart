/*
Using for textfield single and multiline
 */

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TextWidget extends StatelessWidget {
  TextStyle style;
  double percent;
  String text;
  int maxLines = 1;
  bool softWrap = false;
  TextOverflow overflow = TextOverflow.clip;

  TextWidget(
    this.text, {
    this.percent = 0.6,
    this.maxLines = 1,
    this.softWrap = true,
    this.style,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
      text,
      style: this.style,
      maxLines: this.maxLines,
      minFontSize: 14,
      overflow: TextOverflow.ellipsis,
    );
  }
}
