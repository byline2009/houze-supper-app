import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:houze_super/middle/model/building_model.dart';
import 'package:houze_super/presentation/common_widgets/skeletons/src/skeleton/parking_image_card_skeleton.dart';
import 'package:houze_super/presentation/index.dart';

typedef void CallBackHandler();

class FirstBrandDialog extends StatelessWidget {
  final BuildingMessageModel building;
  final CallBackHandler callback;
  const FirstBrandDialog({
    required this.building,
    required this.callback,
  });
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(0),
      titlePadding: const EdgeInsets.all(0),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0))),
      content: Container(
        height: 370,
        color: Colors.transparent,
        padding: const EdgeInsets.only(bottom: 20),
        child: DecoratedBox(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8.0))),
          child: Align(
            alignment: Alignment.topCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    SizedBox(
                        height: 190,
                        width: double.infinity,
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8.0),
                            topRight: Radius.circular(8.0),
                          ),
                          child: CachedNetworkImage(
                            imageUrl: building.company!.coverThumb!,
                            placeholder: (context, url) => ParkingCardSkeleton(
                              width: double.infinity,
                              height: 190,
                            ),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                            fit: BoxFit.cover,
                            height: 190.0,
                          ),
                        )),
                    Positioned(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.transparent,
                              elevation: 0,
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.all(0)),
                          onPressed: () => callback(),
                          child: SizedBox(
                            height: 30,
                            width: 30,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15.0),
                                ),
                              ),
                              child: Center(
                                  child: SvgPicture.asset(AppVectors.icClose,
                                      height: 14, width: 14)),
                            ),
                          ),
                        ),
                        top: 15,
                        left: 20)
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TextLimitWidget(building.company!.welcome.toString(),
                          maxLines: 3,
                          textAlign: TextAlign.center,
                          style: AppFonts.regular15)
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                        color: AppColor.gray_f5f5f5,
                        borderRadius: BorderRadius.all(
                          Radius.circular(5.0),
                        )),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                              LocalizationsUtil.of(context).translate(
                                  'automatically_close_after_with_space'),
                              style: AppFonts.regular15),
                          StreamBuilder(
                              stream: Ticker().tick(ticks: 5),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  return Text(LocalizationsUtil.of(context)
                                      .translate(
                                          "there_is_an_issue_please_try_again_later_0"));
                                } else if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Text(
                                      "5" +
                                          LocalizationsUtil.of(context).translate(
                                              "seconds_with_space_and_lower_case"),
                                      style: AppFonts.bold16);
                                } else if (snapshot.hasData &&
                                    snapshot.data == 0) {
                                  callback();
                                }
                                return Text(
                                    "${snapshot.data}" +
                                        LocalizationsUtil.of(context).translate(
                                            "seconds_with_space_and_lower_case"),
                                    style: AppFonts.bold16);
                              })
                        ]),
                    height: 48.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Ticker {
  Stream<int> tick({required int ticks}) {
    return Stream<int>.periodic(
        const Duration(seconds: 1), (x) => ticks - x % (ticks + 1));
  }
}
