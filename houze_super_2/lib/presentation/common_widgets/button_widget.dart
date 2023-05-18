import 'dart:async';

import 'package:flutter/material.dart';
import 'package:houze_super/utils/index.dart';

typedef void CallBackHandlerButton();

class ButtonSubmitEvent {
  bool? isActive;

  ButtonSubmitEvent(bool value) {
    this.isActive = value;
  }
}

class ButtonWidget extends StatelessWidget {
  final String? defaultHintText;
  bool isActive;
  StreamController<ButtonSubmitEvent>? controller;
  final CallBackHandlerButton? callback;
  final bool? isSimple;

  ButtonWidget(
      {this.defaultHintText,
      this.isActive = false,
      this.callback,
      this.controller,
      this.isSimple = false});

  Widget initButton() {
    if (isSimple ?? false) {
      return Container(
          key: Key('pay'),
          height: 48,
          width: double.infinity,
          decoration: this.isActive == true
              ? BoxDecoration(
                  border: Border.all(
                    color: AppColor.red_c50000,
                    width: 1,
                    style: BorderStyle.solid,
                  ),
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                )
              : BoxDecoration(
                  border: Border.all(
                    color: AppColor.gray_9c9c9c,
                    width: 1,
                    style: BorderStyle.solid,
                  ),
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
          child: Padding(
            padding: const EdgeInsets.only(right: 5.0, left: 5.0),
            child: TextButton(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.all(0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
              ),
              onPressed: !this.isActive ? null : this.callback,
              child: Text(defaultHintText!,
                  style: !this.isActive
                      ? AppFonts.semibold15.copyWith(
                          color: Color(
                            0xffB5B5B5,
                          ),
                        )
                      : AppFonts.semibold15.copyWith(
                          color: Color(
                            0xffC50000,
                          ),
                        )),
            ),
          ));
    } else {
      return Container(
          key: Key('pay'),
          height: 48,
          width: double.infinity,
          decoration: this.isActive == true
              ? BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  gradient: AppColor.gradient,
                )
              : BoxDecoration(
                  color: AppColor.gray_dcdcdc,
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
          child: Padding(
            padding: const EdgeInsets.only(right: 5.0, left: 5.0),
            child: TextButton(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.all(0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
              ),
              onPressed: !this.isActive ? null : this.callback,
              child: Text(
                defaultHintText!,
                style: AppFonts.bold16.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (this.isActive == true && this.controller == null) return initButton();

    if (this.controller == null)
      controller = StreamController<ButtonSubmitEvent>();

    return StreamBuilder(
        stream: this.controller!.stream,
        initialData: ButtonSubmitEvent(this.isActive),
        builder:
            (BuildContext context, AsyncSnapshot<ButtonSubmitEvent> snapshot) {
          this.isActive = snapshot.data!.isActive!;

          return initButton();
        });
  }
}
