import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:houze_super/app/bloc/apartment/index.dart';
import 'package:houze_super/middle/model/apartment_model.dart';
import 'package:houze_super/middle/model/keyvalue_model.dart';
import 'package:houze_super/middle/repo/apartment_repository.dart';
import 'package:houze_super/presentation/screen/ticket/widget_mini_box.dart';
import 'package:houze_super/utils/constants/constants.dart';
import 'package:houze_super/utils/localizations_util.dart';

import 'dropdown_widget.dart';

typedef ApartmentVoidFunc = void Function(ApartmentMessageModel);

class WidgetApartmentLineBox extends StatefulWidget {
  final DropdownWidgetController controller;
  final ApartmentVoidFunc callbackResult;
  final String title;

  const WidgetApartmentLineBox(
      {@required this.controller, @required this.callbackResult, this.title});

  @override
  WidgetApartmentLineBoxState createState() =>
      new WidgetApartmentLineBoxState();
}

class WidgetApartmentLineBoxState extends State<WidgetApartmentLineBox> {
  final apartmentBloc = ApartmentBloc(
    apartmentRepo: ApartmentRepository(),
  );
  int _initApartmentIndex = 0;

  @override
  void initState() {
    super.initState();
    apartmentBloc.add(GetAllApartment());
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.wait([
          ServiceConverter.getTextToConvert("apartment_with_colon"),
          ServiceConverter.getTextToConvert("select_an_apartment")
        ]),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const SizedBox.shrink();
          }
          return WidgetMiniBox(
            title: LocalizationsUtil.of(context).translate(snap.data[0]),
            height: 0,
            child: BlocBuilder(
              cubit: apartmentBloc,
              builder: (BuildContext context,
                  List<ApartmentMessageModel> apartments) {
                var _listApartment = apartments.map((f) {
                  return KeyValueModel(key: f.id, value: f.name);
                }).toList();

                return DropdownWidget(
                  controller: widget.controller,
                  defaultHintText:
                      LocalizationsUtil.of(context).translate(snap.data[1]),
                  dataSource: _listApartment,
                  boxStyle: DropDownStyle.line,
                  buildChild: (index) {
                    return Center(
                      child: Text(apartments[index].name,
                          style: TextStyle(
                              fontFamily: AppFonts.font_family_display)),
                    );
                  },
                  doneEvent: (index) async {
                    _initApartmentIndex = index;
                    widget.callbackResult(apartments[index]);
                  },
                  initIndex: _initApartmentIndex,
                );
              },
            ),
          );
        });
  }
}
