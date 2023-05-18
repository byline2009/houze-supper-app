import 'package:flutter/material.dart';
import 'package:houze_super/middle/local/storage.dart';
import 'package:houze_super/middle/model/apartment_model.dart';
import 'package:houze_super/presentation/common_widgets/stateful/dropdown_widget.dart';
import 'package:houze_super/presentation/common_widgets/stateless/widget_boxes_container.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/presentation/screen/ticket/widget_apartment_box.dart';
import 'package:houze_super/utils/index.dart';

typedef ApartmentVoidFunc = void Function(ApartmentMessageModel);

class SectionPersonalInfomation extends StatefulWidget {
  final DropdownWidgetController controller;
  final ApartmentVoidFunc callback;
  const SectionPersonalInfomation({
    @required this.callback,
    @required this.controller,
  });

  @override
  _SectionPersonalInfomationState createState() =>
      _SectionPersonalInfomationState();
}

class _SectionPersonalInfomationState extends State<SectionPersonalInfomation> {
  //Service converter
  Future<String> service;

  @override
  void initState() {
    service = ServiceConverter.convertTypeBuilding("apartment_id_with_colon");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WidgetBoxesContainer(
        title: 'personal_information',
        styleTitle: AppFonts.bold.copyWith(fontSize: 16),
        padding:const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Padding(
          padding:const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: <Widget>[
              FutureBuilder(
                future: service,
                builder: (context, snap) {
                  if (snap.connectionState == ConnectionState.waiting) {
                    return const SizedBox.shrink();
                  }
                  return WidgetApartmentBox(
                    title: snap.data,
                    titleStyle:
                        AppFonts.regular.copyWith(color: Color(0xff808080)),
                    controller: widget.controller,
                    callbackResult: (value) {
                      widget.callback(value);
                    },
                  );
                },
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    LocalizationsUtil.of(context).translate(
                      'full_name_0',
                    ),
                    style: AppFonts.regular.copyWith(
                      color: Color(0xff838383),
                    ),
                  ),
                  Text(
                    Storage.getUserName(),
                    style: AppFonts.medium14.copyWith(color: Colors.black),
                  )
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    LocalizationsUtil.of(context).translate(
                      'phone_number_1',
                    ),
                    style: AppFonts.regular15.copyWith(
                      color: Color(0xff838383),
                    ),
                  ),
                  Text(Storage.getPhoneNumber().toString(),
                      style: AppFonts.medium14.copyWith(color: Colors.black))
                ],
              ),
              const SizedBox(height: 20)
            ],
          ),
        ));
  }
}
