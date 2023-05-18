/*
Using for textfield single and multiline
 */

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/utils/constants/constants.dart';

typedef VoidFunc = void Function();
typedef void CallBackHandlerString(String value);

class TextFieldWidgetController {
  TextEditingController _controller = TextEditingController();
  VoidFunc _callbackRefresh;

  TextFieldWidgetController();

  void refresh() {
    if (_callbackRefresh != null) {
      _callbackRefresh();
    }
  }

  TextEditingController get controller {
    return this._controller;
  }

  set controller(TextEditingController _controller) {
    this._controller = _controller;
  }
}

class TextFieldWidget extends StatelessWidget {
  String defaultHintText;
  String label;
  bool isChanged = false;
  TextInputType keyboardType;
  TextCapitalization textCapitalization;
  CallBackHandlerString callback;
  TextFieldWidgetController controller;
  BoxDecoration decoration;
  final _textStreamController = StreamController<String>.broadcast();

  TextFieldWidget(
      {this.controller,
      this.label = '',
      this.defaultHintText,
      this.keyboardType = TextInputType.text,
      this.textCapitalization = TextCapitalization.none,
      this.callback}) {
    //Init controller
    this.controller._callbackRefresh = () {
      this.controller.controller.clear();
      _textStreamController.sink.add("");
    };
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _textStreamController.stream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                label == null
                    ? null
                    : Text(
                        this.label,
                        style: AppFonts.regular15.copyWith(
                          color: Color(0xff838383),
                        ),
                      ), //regularGray.copyWith(fontSize: 15,)),
                DecoratedBox(
                  child: TextFormField(
                    keyboardAppearance: Brightness.light,
                    scrollPadding: const EdgeInsets.all(0),
                    controller: this.controller.controller,
                    keyboardType: keyboardType,
                    textCapitalization: textCapitalization,
                    textAlign: TextAlign.left,
                    cursorColor: Color(0xff6001d1),
                    onTap: () {},
                    maxLines: keyboardType == TextInputType.multiline ? 5 : 1,
                    style: AppFonts.regular14,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: LocalizationsUtil.of(context)
                          .translate(defaultHintText),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(
                            color: this.controller.controller.text != ""
                                ? Color(0xff6001d1)
                                : Colors.transparent,
                            width: 0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide:
                            BorderSide(color: Color(0xff6001d1), width: 0),
                      ),
                      hintStyle:
                          AppFonts.regular.copyWith(color: Color(0xff838383)),
                    ),
                    onChanged: this.callback,
                  ),
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.25),
                            offset: Offset(0, 0),
                            blurRadius: 4)
                      ],
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      color: Colors.white),
                )
              ]);
        });
  }
}
