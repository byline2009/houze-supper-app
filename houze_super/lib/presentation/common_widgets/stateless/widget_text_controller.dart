/*
Using for textfield single and multiline
 */

import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TextDynamicWidget extends StatelessWidget {
  final String defaultText;
  final TextStyle style;
  final StreamController<String> controller;

  TextDynamicWidget({this.defaultText, this.style, this.controller});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: controller.stream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          final result = snapshot.data ?? this.defaultText;
          return AutoSizeText(
            result,
            style: this.style,
            minFontSize: 14,
            overflow: TextOverflow.ellipsis,
          );
        });
  }
}
