import 'package:flutter/material.dart';
import 'package:houze_super/middle/model/parking_vehicle_model.dart';
import 'package:houze_super/presentation/common_widgets/stateless/translator_vi_to_en.dart';
import 'package:houze_super/middle/local/storage.dart';

class NoteBox extends StatelessWidget {
  final ParkingVehicle item;
  const NoteBox({this.item});

  @override
  Widget build(BuildContext context) {
    final getLanguage = Storage.getLanguage();

    if (item.status == 2) {
      return Container(
        child: item.note == null
            ? const SizedBox.shrink()
            : this.item.note == ""
                ? const SizedBox.shrink()
                : Column(
                    children: <Widget>[
                      Container(
                        width: 1000.0,
                        padding: const EdgeInsets.all(15.0),
                        margin: EdgeInsets.only(
                          top: 20.0,
                          left: 0,
                          right: 0,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xfff5f7f8),
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        child: Text(this.item.note),
                      ),
                      //Detect language to show the translate button
                      getLanguage.name != 'Tiếng Việt'
                          ? TranslatorViToEn(this.item.note, getLanguage.locale)
                          : const SizedBox.shrink(),
                    ],
                  ),
      );
    }
    return const SizedBox.shrink();
  }
}
