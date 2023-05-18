import 'dart:async';

import 'package:flutter/material.dart';
import 'package:houze_super/presentation/common_widgets/button_widget.dart';
import 'package:houze_super/presentation/index.dart';

//WidgetGradientButton

class WidgetGradientButton extends StatefulWidget {
  final String title;
  final double radius;
  final StreamController<ButtonSubmitEvent> controller;
  final CallBackHandlerVoid? callback;

  WidgetGradientButton({
    required this.title,
    this.radius = 5.0,
    this.callback,
    required this.controller,
  });

  WidgetGradientButtonState createState() => WidgetGradientButtonState();
}

class WidgetGradientButtonState extends State<WidgetGradientButton> {
  bool isActive = false;

  double get radius => widget.radius;

  Widget initButton() {
    return Container(
      height: 48,
      decoration: this.isActive == true
          ? BoxDecoration(
              gradient: AppColor.gradient,
              borderRadius: BorderRadius.circular(radius))
          : BoxDecoration(
              color: AppColor.gray_dcdcdc,
              borderRadius: BorderRadius.circular(radius)),
      child: TextButton(
        style: TextButton.styleFrom(
          primary: Colors.transparent,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius)),
        ),
        child: Align(
          alignment: Alignment.center,
          child: Text(
            widget.title,
            textAlign: TextAlign.center,
            style: AppFont.BOLD.copyWith(color: Colors.white, fontSize: 16),
          ),
        ),
        onPressed: !this.isActive ? null : widget.callback,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: widget.controller.stream,
        initialData: ButtonSubmitEvent(this.isActive),
        builder:
            (BuildContext context, AsyncSnapshot<ButtonSubmitEvent> snapshot) {
          this.isActive = snapshot.data!.isActive!;

          return initButton();
        });
  }
}
