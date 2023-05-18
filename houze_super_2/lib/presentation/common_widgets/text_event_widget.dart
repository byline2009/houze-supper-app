import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:houze_super/utils/localizations_util.dart';

typedef void CallBackHandler();

class TextEvent {
  String? text;

  TextEvent(String text) {
    this.text = text;
  }
}

class TextEventWidget extends StatefulWidget {
  final TextStyle? style;
  late String text;
  late StreamController<TextEvent>? controller;
  final CallBackHandler? callback;

  TextEventWidget({
    this.text = '',
    this.style,
    this.callback,
    this.controller,
  });

  TextEventWidgetState createState() => TextEventWidgetState();
}

class TextEventWidgetState extends State<TextEventWidget> {
  TextEventWidgetState();

  @override
  Widget build(BuildContext context) {
    if (widget.controller == null)
      widget.controller = new StreamController<TextEvent>();

    return StreamBuilder(
        stream: widget.controller!.stream,
        initialData: TextEvent(widget.text),
        builder: (BuildContext context, AsyncSnapshot<TextEvent> snapshot) {
          if (snapshot.data!.text != null) {
            widget.text = snapshot.data!.text!;
          }

          return Text(
            LocalizationsUtil.of(context).translate(widget.text),
            style: widget.style,
          );
        });
  }
}
