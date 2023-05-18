import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:houze_super/middle/local/storage.dart';
import 'package:houze_super/middle/model/parking_vehicle_model.dart';

import '../../../index.dart';
import '../parking_constant.dart';

class VehicleCardItem extends StatelessWidget {
  final ParkingVehicle item;
  const VehicleCardItem({required this.item});

  @override
  Widget build(BuildContext context) {
    final double _width = (AppConstant.screenWidth * 295) / 375;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.white,
          elevation: 0,
        ),
        onPressed: () =>
            AppRouter.push(context, AppRouter.PARKING_DETAIL, item),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            SvgPicture.asset(
              AppVectors.vehicle_card,
            ),
            Container(
              height: 180.0,
              width: _width,
              padding: EdgeInsets.only(top: 20.0, left: 16.0, bottom: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      SvgPicture.asset(
                          ParkingConstant.vehicleImages[item.typeVehicle!],
                          width: 40.0,
                          height: 40.0),
                      SizedBox(width: 15),
                      Expanded(
                          child: Text(item.licensePlate!,
                              style: AppFont.BOLD_WHITE_18,
                              textAlign: TextAlign.left)),
                      SizedBox(width: 5),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4.0),
                        decoration: BoxDecoration(
                          color: item.isExpired!
                              ? Color(0xffff6666)
                              : Color(0xff38d6ac),
                          borderRadius: BorderRadius.horizontal(
                            left: Radius.circular(4.0),
                          ),
                        ),
                        child: Text(
                          LocalizationsUtil.of(context).translate(
                              item.isExpired! ? 'expired' : 'active'),
                          style:
                              AppFonts.medium14.copyWith(color: Colors.white),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 12.0),
                  Text(Storage.getUserName()!, style: AppFont.MEDIUM_WHITE_16),
                  SizedBox(height: 8.0),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        LocalizationsUtil.of(context).translate(
                            ParkingConstant.vehicleNames[item.typeVehicle!]),
                        item.vehicleName,
                        LocalizationsUtil.of(context)
                            .translate(item.vehicleColor),
                      ]
                          .map(
                            (e) => Text(
                              e ?? '',
                              style: AppFont.MEDIUM_GRAY_808080.copyWith(
                                color: AppColor.gray_f5f5f5,
                                fontSize: 14,
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
