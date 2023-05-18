import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:houze_super/app/bloc/apartment/index.dart';

import 'package:houze_super/middle/model/apartment_model.dart';
import 'package:houze_super/middle/model/keyvalue_model.dart';
import 'package:houze_super/middle/repo/apartment_repository.dart';
import 'package:houze_super/presentation/common_widgets/stateful/dropdown_widget.dart';
import 'package:houze_super/presentation/screen/ticket/widget_mini_box.dart';
import 'package:houze_super/utils/index.dart';
import 'package:houze_super/utils/localizations_util.dart';

typedef ApartmentVoidFunc = void Function(ApartmentMessageModel);

class WidgetApartmentCodeBox extends StatefulWidget {
  final String title;
  final DropdownWidgetController controller;
  final ApartmentVoidFunc callbackResult;

  const WidgetApartmentCodeBox(
      {this.title, @required this.controller, @required this.callbackResult});

  @override
  WidgetApartmentCodeBoxState createState() =>
      new WidgetApartmentCodeBoxState();
}

class WidgetApartmentCodeBoxState extends State<WidgetApartmentCodeBox> {
  final apartmentBloc = ApartmentBloc(
    apartmentRepo: ApartmentRepository(),
  );

  @override
  void initState() {
    super.initState();
    apartmentBloc.add(
      GetAllApartment(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WidgetMiniBox(
        title: widget.title,
        child: BlocBuilder(
            cubit: apartmentBloc,
            builder:
                (BuildContext context, List<ApartmentMessageModel> apartments) {
              var _listApartment = apartments.map((f) {
                return KeyValueModel(key: f.id, value: f.name);
              }).toList();

              return DropdownWidget(
                controller: widget.controller,
                defaultHintText: 'select_an_apartment',
                dataSource: _listApartment,
                buildChild: (index) {
                  return Center(
                    child: Text(
                        LocalizationsUtil.of(context).translate('apartment') +
                            ' ' +
                            apartments[index].name,
                        style: TextStyle(
                            fontFamily: AppFonts.font_family_display)),
                  );
                },
                doneEvent: (index) async {
                  widget.callbackResult(apartments[index]);
                },
                cancelEvent: (index) async {
                  widget.callbackResult(null);
                },
              );
            }));
  }
}
