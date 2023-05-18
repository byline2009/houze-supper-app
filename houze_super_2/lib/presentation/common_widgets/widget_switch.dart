import 'dart:async';

import 'package:flutter/material.dart';

typedef BoolFunc = Future<bool> Function(bool);
typedef SwitchFunc = void Function(SwitchWidgetState);

class SwitchEvent {
  late bool isEnable;

  SwitchEvent(bool value) {
    this.isEnable = value;
  }
}

class SwitchWidget extends StatefulWidget {
  BoolFunc doneEvent;
  SwitchFunc initEvent;
  bool defaultValue = false;
  StreamController<SwitchEvent>? controller;

  SwitchWidget({
    required this.doneEvent,
    required this.initEvent,
    required this.defaultValue,
    this.controller,
  });

  SwitchWidgetState createState() => SwitchWidgetState();
}

class SwitchWidgetState extends State<SwitchWidget> {
  bool _didTap = true;
  void toggle(bool value) {
    widget.defaultValue = value;
    widget.controller!.add(SwitchEvent(value));
    print('Toggle: $value');
  }

  @override
  void initState() {
    widget.initEvent(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.controller == null) {
      widget.controller = StreamController<SwitchEvent>();
    }

    return StreamBuilder(
        stream: widget.controller!.stream,
        initialData: SwitchEvent(widget.defaultValue),
        builder: (BuildContext context, AsyncSnapshot<SwitchEvent> snapshot) {
          widget.defaultValue = snapshot.data!.isEnable;

          if (widget.defaultValue) {
            widget.doneEvent(true);
          }

          return AbsorbPointer(
            absorbing: !this._didTap, //prevent multiple tapping
            child: Switch(
              value: widget.defaultValue,
              onChanged: (value) async {
                setState(() {
                  this._didTap = false;
                });
                final rs = await widget.doneEvent(value);
                widget.defaultValue = rs;
                widget.controller!.add(SwitchEvent(widget.defaultValue));
                setState(() {
                  this._didTap = true;
                });
              },
              activeTrackColor: Colors.grey[200],
              activeColor: Theme.of(context).primaryColor,
              inactiveTrackColor: Colors.grey[200],
            ),
          );
        });
  }
}
