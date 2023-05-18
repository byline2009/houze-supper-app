/*
Using for textfield single and multiline
 */

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:houze_super/middle/local/storage.dart';
import 'package:houze_super/utils/localizations_util.dart';

class TextLimitWidget extends StatelessWidget {
  final TextStyle? style;
  final String text;
  final int maxLines;
  final TextOverflow overflow;
  final TextAlign textAlign;

  const TextLimitWidget(
    this.text, {
    this.maxLines = 1,
    this.style,
    this.overflow: TextOverflow.clip,
    this.textAlign: TextAlign.left,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Text(
        LocalizationsUtil.of(Storage.scaffoldKey.currentContext)
            .translate(text),
        textAlign: this.textAlign,
        overflow: TextOverflow.ellipsis,
        maxLines: this.maxLines,
        style: this.style,
      ),
    );
  }
}
