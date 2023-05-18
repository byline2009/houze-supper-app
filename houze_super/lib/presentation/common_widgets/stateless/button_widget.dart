import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:houze_super/utils/constants/constants.dart';

typedef void CallBackHandlerButton();

class ButtonSubmitEvent {
  bool isActive;

  ButtonSubmitEvent(bool value) {
    this.isActive = value;
  }
}

class ButtonWidget extends StatelessWidget {
  final String defaultHintText;
  bool isActive;
  StreamController<ButtonSubmitEvent> controller;
  final CallBackHandlerButton callback;

  ButtonWidget({
    this.defaultHintText,
    this.isActive = false,
    this.callback,
    this.controller,
  });

  Widget initButton() {
    return Container(
        height: 48,
        width: double.infinity,
        decoration: this.isActive == true
            ? BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                gradient: AppColors.gradient,
              )
            : BoxDecoration(
                color: Color(0xffdcdcdc),
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
              ),
        child: Padding(
            padding: const EdgeInsets.only(right: 5.0, left: 5.0),
            child: FlatButton(
                padding: const EdgeInsets.all(0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
                onPressed: !this.isActive ? null : this.callback,
                child: Text(defaultHintText,
                    style: AppFonts.bold16.copyWith(color: Colors.white)))));
  }

  @override
  Widget build(BuildContext context) {
    if (this.isActive == true && this.controller == null) return initButton();

    if (this.controller == null)
      controller = StreamController<ButtonSubmitEvent>();

    return StreamBuilder(
        stream: this.controller.stream,
        initialData: ButtonSubmitEvent(this.isActive),
        builder:
            (BuildContext context, AsyncSnapshot<ButtonSubmitEvent> snapshot) {
          this.isActive = snapshot.data.isActive;

          return initButton();
        });
  }
}
