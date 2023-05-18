import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:houze_super/middle/model/parking_vehicle_model.dart';
import 'package:houze_super/presentation/common_widgets/stateless/sc_image_view.dart';
import 'package:houze_super/presentation/screen/parking/parking_constant.dart';
import 'package:houze_super/utils/map_util.dart';
import '../../../index.dart';

class SectionVehicleInfo extends StatelessWidget {
  final ParkingVehicle item;
  const SectionVehicleInfo({@required this.item});
  @override
  Widget build(BuildContext context) {
    return WidgetBoxesContainer(
      title: 'vehicle_information',
      styleTitle: AppFonts.bold.copyWith(fontSize: 16),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Column(children: [
        titleContentLabel(
            LocalizationsUtil.of(context).translate('type_of_vehicle'),
            LocalizationsUtil.of(context)
                .translate(ParkingConstant.vehicleNames[item.typeVehicle])),
        titleContentLabel(
            LocalizationsUtil.of(context).translate('model_of_vehicle'),
            item.vehicleName),
        titleContentLabel(
          LocalizationsUtil.of(context).translate('vehicle_color'),
          item.vehicleColor,
        ),
        titleContentLabel(
          LocalizationsUtil.of(context).translate('vehicle\'s_license_plate'),
          item.licensePlate,
        ),
        photoListInformation(context),
        const SizedBox(
          height: 20,
        ),
      ]),
    );
  }

  Widget titleContentLabel(String title, String content) {
    return Container(
      padding:
          EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
      alignment: Alignment.centerLeft,
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(title + ':',
                  style: AppFonts.regular.copyWith(color: Color(0xff808080))),
              Expanded(child: Text('')),
              Text(content,
                  style: AppFonts.medium14.copyWith(color: Colors.black)),
            ],
          ),
        ],
      ),
    );
  }

  Widget photoListInformation(BuildContext context) {
    final Size _pageSize = MediaQuery.of(context).size;

    final padding = _pageSize.width * 5 / 100;
    var _imgs = <String>[];
    item.images.forEach((element) => _imgs.add(element.url));
    final double imageWidth = 60.0;
    final double imageHeight = 80.0;
    return Padding(
      padding: EdgeInsets.only(left: padding, right: padding, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: this
            .item
            .images
            .mapIndexed((index, f) => Container(
                  margin: EdgeInsets.only(left: 5, right: 5, top: padding),
                  child: ClipRRect(
                      borderRadius: new BorderRadius.circular(4.0),
                      child: Stack(
                        overflow: Overflow.clip,
                        children: <Widget>[
                          GestureDetector(
                            child: CachedNetworkImage(
                              imageUrl: f.url,
                              width: imageWidth,
                              height: imageHeight,
                              fit: BoxFit.cover,
                            ),
                            onTap: () {
                              AppRouter.pushDialog(
                                  context,
                                  AppRouter.imageViewPage,
                                  ImageViewPageArgument(
                                      images: _imgs, initImg: index));
                            },
                          )
                        ],
                      )),
                  width: 60,
                  height: 80,
                ))
            .toList(),
      ),
    );
  }
}
