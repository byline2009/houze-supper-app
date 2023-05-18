import 'package:flutter/material.dart';
import 'package:houze_super/middle/local/storage.dart';
import 'package:houze_super/middle/model/apartment_model.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/presentation/screen/ticket/widget_apartment_box.dart';

typedef ApartmentVoidFunc = void Function(ApartmentMessageModel?);

class SectionPersonalInfomation extends StatefulWidget {
  final DropdownWidgetController controller;
  final ApartmentVoidFunc callback;
  const SectionPersonalInfomation({
    required this.callback,
    required this.controller,
  });

  @override
  _SectionPersonalInfomationState createState() =>
      _SectionPersonalInfomationState();
}

class _SectionPersonalInfomationState extends State<SectionPersonalInfomation> {
  //Service converter
  late Future<String?> service;

  @override
  void initState() {
    service = ServiceConverter.convertTypeBuilding("apartment_id_with_colon");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WidgetBoxesContainer(
        title: 'personal_information',
        styleTitle: AppFonts.bold16,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: <Widget>[
              FutureBuilder(
                future: service,
                builder: (context, dynamic snap) {
                  if (snap.connectionState == ConnectionState.waiting) {
                    return SizedBox.shrink();
                  }
                  return WidgetApartmentBox(
                    title: snap.data,
                    titleStyle: AppFonts.regular14.copyWith(
                      color: Color(
                        0xff808080,
                      ),
                    ),
                    controller: widget.controller,
                    callbackResult: (value) {
                      widget.callback(value);
                    },
                  );
                },
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                      LocalizationsUtil.of(context).translate(
                        'full_name_0',
                      ),
                      style: AppFont.REGULAR_GREY),
                  Text(
                    Storage.getUserName() ?? '',
                    style: AppFonts.medium14,
                  )
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                      LocalizationsUtil.of(context).translate(
                        'phone_number_1',
                      ),
                      style: AppFont.REGULAR_GREY),
                  Text(Storage.getPhoneNumber().toString(),
                      style: AppFonts.medium14)
                ],
              ),
              SizedBox(height: 20)
            ],
          ),
        ));
  }
}
