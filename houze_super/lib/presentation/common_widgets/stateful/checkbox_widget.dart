import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

typedef void CallBackHandler(dynamic value, bool check);

class CheckboxSubmitEvent {
  Map<dynamic, bool> values = new Map<dynamic, bool>();

  CheckboxSubmitEvent({Map<dynamic, bool> values});
}

class CheckboxWidget extends StatefulWidget {
  final dynamic id;
  final Widget label;
  final StreamController<CheckboxSubmitEvent> controller;
  final CallBackHandler callback;
  final bool initSelected;
  CheckboxSubmitEvent binding = CheckboxSubmitEvent();

  CheckboxWidget({
    this.id,
    this.label,
    this.callback,
    this.initSelected,
    this.controller,
    this.binding,
  });

  ButtonWidgetState createState() => ButtonWidgetState();
}

class ButtonWidgetState extends State<CheckboxWidget> {
  ButtonWidgetState();

  void onClickHandler() {
    if (widget.binding.values.containsKey(widget.id)) {
      widget.binding.values[widget.id] = !widget.binding.values[widget.id];
      widget.callback(widget.id, widget.binding.values[widget.id] == true);
      widget.controller.sink.add(widget.binding);
    }
  }

  Widget initButton(Widget icon, Widget label, CallBackHandler callback) {
    return FlatButton(
        child: Row(children: <Widget>[
          icon,
          const SizedBox(width: 10),
          label,
        ]),
        splashColor: Colors.transparent,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onPressed: () {
          onClickHandler();
        });
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () async {
      if (widget.initSelected != null) {
        onClickHandler();
      }
    });

    return StreamBuilder(
      stream: widget.controller.stream,
      initialData: widget.binding,
      builder:
          (BuildContext context, AsyncSnapshot<CheckboxSubmitEvent> snapshot) {
        return SizedBox(
          child: initButton(
              (widget.binding.values[widget.id])
                  ? SvgPicture.asset(
                      "assets/svg/widgets/ic-checked.svg",
                    )
                  : SvgPicture.asset(
                      "assets/svg/widgets/ic-uncheck.svg",
                    ),
              widget.label ?? const SizedBox.shrink(),
              widget.callback),
        );
      },
    );
  }
}
