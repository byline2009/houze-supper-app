import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:houze_super/app/bloc/apartment/index.dart';

import 'package:houze_super/middle/model/apartment_model.dart';
import 'package:houze_super/middle/model/keyvalue_model.dart';
import 'package:houze_super/middle/repo/apartment_repository.dart';
import 'package:houze_super/presentation/common_widgets/stateful/dropdown_widget.dart';
import 'package:houze_super/presentation/screen/ticket/widget_mini_box.dart';
import 'package:houze_super/utils/index.dart';

typedef ApartmentVoidFunc = void Function(ApartmentMessageModel);

class WidgetApartmentBox extends StatefulWidget {
  final DropdownWidgetController controller;
  final ApartmentVoidFunc callbackResult;
  final String title;
  final TextStyle titleStyle;
  WidgetApartmentBox(
      {@required this.title,
      @required this.controller,
      @required this.callbackResult,
      this.titleStyle});

  @override
  WidgetApartmentBoxState createState() => new WidgetApartmentBoxState();
}

class WidgetApartmentBoxState extends State<WidgetApartmentBox> {
  final apartmentBloc = ApartmentBloc(
    apartmentRepo: ApartmentRepository(),
  );
  //Service converter
  Future<String> service;

  @override
  void initState() {
    //Service converter
    service = ServiceConverter.convertTypeBuilding('select_an_apartment');
    super.initState();
    apartmentBloc.add(GetAllApartment());
  }

  @override
  Widget build(BuildContext context) {
    return WidgetMiniBox(
      title: widget.title,
      titleStyle: widget.titleStyle,
      child: BlocBuilder(
        cubit: apartmentBloc,
        builder:
            (BuildContext context, List<ApartmentMessageModel> apartments) {
          var _listApartment = apartments.map((f) {
            return KeyValueModel(key: f.id, value: f.name);
          }).toList();
          return FutureBuilder(
            future: service, //Service converter
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return const SizedBox.shrink();
              }
              return DropdownWidget(
                controller: widget.controller,
                defaultHintText:
                    LocalizationsUtil.of(context).translate(snap.data),
                dataSource: _listApartment,
                buildChild: (index) {
                  return Center(
                    child: Text(apartments[index].name,
                        style: TextStyle(
                            fontFamily: AppFonts.font_family_display)),
                  );
                },
                doneEvent: (index) {
                  widget.callbackResult(apartments[index]);
                },
                cancelEvent: (index) {
                  widget.callbackResult(null);
                },
              );
            },
          );
        },
      ),
    );
  }
}
