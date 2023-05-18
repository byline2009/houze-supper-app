import 'package:dotted_border/dotted_border.dart';

import 'package:flutter/material.dart';
import 'package:houze_super/middle/model/keyvalue_model.dart';
import 'package:houze_super/presentation/common_widgets/stateless/text_limit_widget.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/utils/constants/constants.dart';

typedef void CancelCallBackHandler();
typedef void CallBackHandlerToggle(ResponseCallback response);
typedef void ResponseCallback(KeyValueModel keyValueModel);

// ignore: must_be_immutable
class ToggleFilterWidget extends StatefulWidget {
  final defaultText;
  dynamic defaultValue;
  dynamic except;
  CallBackHandlerToggle callback;
  CancelCallBackHandler cancelCallback;

  ToggleFilterWidget(
      {@required this.defaultText,
      this.defaultValue,
      this.except,
      this.callback,
      this.cancelCallback});

  @override
  ToggleFilterWidgetState createState() => ToggleFilterWidgetState();
}

class ToggleFilterWidgetState extends State<ToggleFilterWidget> {
  KeyValueModel pickedModel;

  responseCallback(KeyValueModel keyValueModel) {
    if (keyValueModel.key != widget.except) {
      setState(() {
        pickedModel = keyValueModel;
      });
    } else {
      if (pickedModel != null) {
        setState(() {
          pickedModel = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          if (widget.callback != null) {
            widget.callback(responseCallback);
          }
        },
        child: pickedModel == null
            ? DottedBorder(
                padding: const EdgeInsets.all(0),
                borderType: BorderType.RRect,
                dashPattern: [4, 4],
                color: Color(0xff737373),
                radius: Radius.circular(5),
                child: SizedBox(
                    height: 38,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.add,
                          color: Color(0xff838383),
                          size: 18.0,
                        ),
                        const SizedBox(width: 8),
                        Text(
                            LocalizationsUtil.of(context)
                                .translate(widget.defaultText),
                            style: AppFonts.semibold13
                                .copyWith(color: Color(0xff838383))),
                      ],
                    )))
            : Container(
                height: 38,
                decoration: BoxDecoration(
                  color: Color(0xff6001d2),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Expanded(
                        child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                            right: BorderSide(
                                color: Colors.white,
                                width: 1,
                                style: BorderStyle.solid)),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 17),
                      child: Row(
                        children: <Widget>[
                          TextLimitWidget(pickedModel.value,
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              style: AppFonts.semibold13
                                  .copyWith(color: Colors.white))
                        ],
                      ),
                      //child: Center(child: Text(pickedModel.value, style: AppFonts.semibold13.copyWith(color: Colors.white), softWrap: false,),)
                    )),
                    IconButton(
                      constraints: BoxConstraints(
                        maxWidth: 40,
                      ),
                      icon: Icon(
                        Icons.clear,
                        size: 18,
                      ),
                      color: Colors.white,
                      onPressed: () {
                        setState(() {
                          if (widget.cancelCallback != null) {
                            widget.cancelCallback();
                          }
                          pickedModel = null;
                        });
                      },
                      //other properties
                    )
                  ],
                )));
  }
}
