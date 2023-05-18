import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:houze_super/middle/model/parking_vehicle_model.dart';

import '../../../index.dart';
import '../parking_constant.dart';

class RegisterPendingVehicleCard extends StatelessWidget {
  final ParkingVehicle item;
  const RegisterPendingVehicleCard({required this.item});

  @override
  Widget build(BuildContext context) {
    String _title =
        '${LocalizationsUtil.of(context).translate(ParkingConstant.vehicleNames[item.typeVehicle!])} - ${item.licensePlate}';
    String _status = ParkingConstant.bookingStatusList[item.status!];
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey[200]!,
              blurRadius: 10.0,
              spreadRadius: 1.0,
              offset: Offset(
                0.0, //move right 10
                1.0, //move down 10
              ),
            )
          ],
          color: Colors.white),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: SvgPicture.asset(
            ParkingConstant.vehicleImages[item.typeVehicle!],
            height: 40,
            width: 40),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                TextLimitWidget(
                  _title,
                  maxLines: 1,
                  style: AppFonts.medium14,
                ),
              ],
            ),
          ],
        ),
        trailing: Icon(
          Icons.arrow_forward,
          size: 20,
          color: Color(0xFFd1d6de),
        ),
        subtitle: Text(
          LocalizationsUtil.of(context).translate(_status),
          style: AppFonts.medium14.copyWith(
              color: ParkingConstant.bookingStatusColors[item.status!]),
        ),
      ),
    );
  }
}
