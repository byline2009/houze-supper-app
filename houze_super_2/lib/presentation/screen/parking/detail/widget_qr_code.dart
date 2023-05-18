import 'package:flutter/material.dart';
import 'package:houze_super/middle/model/parking_vehicle_model.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../index.dart';

class SectionQRCode extends StatelessWidget {
  final ParkingVehicle item;
  const SectionQRCode({required this.item});

  @override
  Widget build(BuildContext context) {
    bool _isValidate = item.dateRegistration != null && item.cardCode != null;
    if (_isValidate) {
      return Container(
          padding: EdgeInsets.all(10.0),
          alignment: Alignment.center,
          child: Column(
            children: <Widget>[
              QrImage(
                data: item.cardCode ?? '',
                version: QrVersions.auto,
                size: 190,
                gapless: true,
              ),
              SizedBox(height: 10),
              Text(
                item.cardCode!.toUpperCase(),
                style: AppFont.BOLD_BLACK_22,
              ),
              SizedBox(height: 20)
            ],
          ));
    }
    return SizedBox.shrink();
  }
}
