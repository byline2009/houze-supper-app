import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

typedef void CallBackHandler(dynamic value, bool check);

class CheckboxSubmitEvent {
  final Map<dynamic, bool> values;

  const CheckboxSubmitEvent({
    required this.values,
  });
}

class CheckboxWidget extends StatelessWidget {
  final dynamic id;
  final Widget label;
  final StreamController<CheckboxSubmitEvent> controller;
  final CallBackHandler callback;
  final bool? initSelected;
  final CheckboxSubmitEvent binding;

  const CheckboxWidget({
    required this.id,
    required this.label,
    required this.callback,
    this.initSelected,
    required this.controller,
    required this.binding,
  });

//   ButtonWidgetState createState() => ButtonWidgetState();
// }

// class ButtonWidgetState extends State<CheckboxWidget> {
//   ButtonWidgetState();

  void onClickHandler() {
    if (binding.values.containsKey(id)) {
      binding.values[id] = !binding.values[id]!;
      callback(id, binding.values[id] == true);
      controller.sink.add(binding);
    }
  }

  Widget initButton(Widget icon, Widget label, CallBackHandler? callback) {
    return TextButton(
        child: Row(children: <Widget>[
          icon,
          const SizedBox(width: 20),
          label,
        ]),
        style: ButtonStyle(
          overlayColor: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
            if (states.contains(MaterialState.hovered))
              return Colors.transparent;
            if (states.contains(MaterialState.pressed))
              return Colors.transparent;
            return null;
          }),
        ),
        onPressed: () {
          onClickHandler();
        });
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () async {
      if (initSelected != null) {
        onClickHandler();
      }
    });

    return StreamBuilder<CheckboxSubmitEvent>(
      stream: controller.stream,
      initialData: binding,
      builder:
          (BuildContext context, AsyncSnapshot<CheckboxSubmitEvent> snapshot) {
        if (snapshot.hasData)
          return SizedBox(
            child: initButton(
                (snapshot.hasData)
                    ? SvgPicture.asset(
                        (snapshot.data!.values[id] ?? false)
                            ? "assets/svg/widgets/ic-checked.svg"
                            : "assets/svg/widgets/ic-uncheck.svg",
                      )
                    : const SizedBox.shrink(),
                label,
                callback),
          );

        return SizedBox.shrink();
      },
    );
  }
}
