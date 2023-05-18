import 'package:flutter/material.dart';
import 'package:houze_super/middle/model/facility/facility_model.dart';
import 'package:houze_super/presentation/common_widgets/widget_cached_image.dart';
import 'package:houze_super/presentation/index.dart';

const String facilityKey = 'facilityKey';

class WidgetFacilityItem extends StatelessWidget {
  final BuildContext? parent;
  final FacilityModel model;
  WidgetFacilityItem({required this.model, this.parent});

  @override
  Widget build(BuildContext context) {
    var _widthImg = (AppConstant.screenWidth) * (180 / 375);
    String charge = getCharge(context);
    return GestureDetector(
      onTap: () {
        AppRouter.push(
          context,
          AppRouter.FACILITY_DETAIL_PAGE,
          FacilityDetailScreenArgument(
            faciliyID: model.id!,
            charge: charge,
          ),
        );
      },
      child: Container(
          height: 100,
          margin: EdgeInsets.fromLTRB(20, 0, 20, 15),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.purple,
              gradient: LinearGradient(
                  colors: [Color(0xfff4edff), Color(0xfffbfcfc)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight)),
          child: Row(
            children: <Widget>[
              Expanded(
                  child: Padding(
                      padding: const EdgeInsets.only(
                          left: 15.0, top: 15.0, bottom: 15.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Text(model.title!,
                                      textAlign: TextAlign.left,
                                      maxLines: 1,
                                      softWrap: false,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppFont.BOLD_BLACK_15),
                                  SizedBox(height: 2),
                                  Text(model.getTime(context),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.left,
                                      style: AppFont.SEMIBOLD_GRAY_9c9c9c_13)
                                ]),
                            SizedBox(height: 10),
                            Text(
                              charge,
                              maxLines: 1,
                              overflow: TextOverflow.fade,
                              softWrap: true,
                              style: AppFont.SEMIBOLD_BLACK_12.copyWith(
                                  letterSpacing: 0.26,
                                  wordSpacing: 1.23,
                                  fontWeight: FontWeight.w600),
                            ),
                          ]))),
              ClipPath(
                  clipBehavior: Clip.antiAlias,
                  clipper: MyCustomClipper(),
                  child: Stack(clipBehavior: Clip.hardEdge, children: <Widget>[
                    model.image != null
                        ? CachedImageWidget(
                            cacheKey: facilityKey,
                            imgUrl: model.image!.imageThumb!,
                            width: _widthImg,
                            height: 100.0,
                          )
                        : Container(
                            child: Icon(Icons.satellite,
                                color: Colors.white, size: 20.0),
                            width: _widthImg,
                            height: 100,
                            color: Colors.grey,
                          ),
                  ]))
            ],
          )),
    );
  }

  String getCharge(BuildContext ctx) {
    var value = '';
    if (model.typeCharge == 0) {
      value = LocalizationsUtil.of(ctx).translate('free');
    } else {
      value =
          "đ ${StringUtil.numberFormat(double.parse(model.priceMin!))} - đ ${StringUtil.numberFormat(double.parse(model.priceMax!))}";
    }
    return value;
  }
}

class MyCustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height);
    path.lineTo(size.width - 10.0, size.height);
    path.quadraticBezierTo(
        size.width, size.height, size.width, size.height - 10);
    path.lineTo(size.width, 10.0);
    path.quadraticBezierTo(size.width, 0.0, size.width - 10.0, 0.0);
    path.lineTo(30.0, 0.0);
    path.lineTo(0.0, size.height);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return false;
  }
}
