import 'package:flutter/material.dart';

import 'package:houze_super/presentation/common_widgets/widget_apartment_line_box.dart';
import 'package:houze_super/middle/model/apartment_model.dart';

import '../../../index.dart';

typedef PickApartmentBoxFunc = void Function(ApartmentMessageModel);

class PickApartmentBox extends StatelessWidget {
  final DropdownWidgetController controller;
  final PickApartmentBoxFunc callbackResult;

  const PickApartmentBox(
      {required this.controller, required this.callbackResult});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 20),
        padding: EdgeInsets.only(top: 10.0, bottom: 15, left: 15, right: 15),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          shadows: <BoxShadow>[
            BoxShadow(
              offset: Offset(0, 2.0),
              blurRadius: 10.0,
              color: Color.fromRGBO(0, 0, 0, 0.1),
            ),
          ],
        ),
        child: WidgetApartmentLineBox(
            controller: controller,
            callbackResult: (value) {
              callbackResult(value);
            }));
  }
}
