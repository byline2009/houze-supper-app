import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:houze_super/middle/model/payment_gateway_model.dart';
import 'package:houze_super/presentation/common_widgets/widget_text.dart';
import 'package:houze_super/presentation/index.dart';

typedef void CallBackHandler(int id);

class RadioSubmitEvent {
  int? value;

  RadioSubmitEvent(int? value) {
    this.value = value;
  }
}

class WidgetGatewayRow extends StatefulWidget {
  final int? id;
  final PaymentGatewayModel? model;
  final CallBackHandler? callback;
  final StreamController<RadioSubmitEvent>? controller;

  const WidgetGatewayRow(
      {Key? key, this.id, this.model, this.callback, this.controller})
      : super(key: key);

  @override
  WidgetGatewayRowState createState() => new WidgetGatewayRowState();
}

class WidgetGatewayRowState extends State<WidgetGatewayRow> {
  void onTap() async {
    if (widget.model?.gatewayIcon == null) {
      return;
    }

    if (widget.callback != null) {
      widget.callback!(widget.id!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        children: [
          SizedBox(
              width: 30,
              child: widget.model?.gatewayIcon != null
                  ? StreamBuilder(
                      stream: widget.controller!.stream,
                      initialData: RadioSubmitEvent(0),
                      builder: (BuildContext context,
                          AsyncSnapshot<RadioSubmitEvent> snapshot) {
                        return Radio(
                          value: widget.id,
                          activeColor: AppColor.purple_6001d2,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          //groupValue: item.key,
                          groupValue:
                              int.parse(snapshot.data!.value.toString()),
                          hoverColor: AppColor.purple_6001d2,
                          focusColor: AppColor.purple_6001d2,
                          onChanged: (dynamic value) {
                            onTap();
                          },
                        );
                      })
                  : SizedBox(width: 20)),
          SizedBox(width: 20),
          (widget.model?.gatewayIcon ?? "").isNotEmpty
              ? Image.asset(
                  "assets/images/payment/ic-pay-${widget.model!.gatewayIcon}.jpg",
                  width: 40,
                  height: 40)
              : SvgPicture.asset("assets/images/payment/ic-pay-real.svg",
                  width: 40, height: 40),
          SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                    LocalizationsUtil.of(context)
                        .translate(widget.model!.gatewayTitle),
                    style: AppFonts.medium14
                        .copyWith(fontFamily: AppFont.font_family_display)),
                SizedBox(height: 4),
                TextWidget(
                  LocalizationsUtil.of(context)
                      .translate(widget.model!.gatewayDesc),
                  maxLines: 2,
                  style: AppFont.REGULAR_GRAY_838383_13,
                )
              ],
            ),
          ),
        ],
      ),
      onTap: onTap,
    );
  }
}
