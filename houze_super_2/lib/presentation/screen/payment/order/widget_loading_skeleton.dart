import 'package:flutter/material.dart';
import 'package:houze_super/presentation/common_widgets/skeletons/src/skeleton/parking_image_card_skeleton.dart';
import 'package:houze_super/presentation/screen/base/base_widget.dart';

class PaymentLoadingSkeleton extends StatelessWidget {
  final BuildContext parentContext;
  const PaymentLoadingSkeleton({Key? key, required this.parentContext})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size _screenSize = MediaQuery.of(parentContext).size;
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 20, right: 20, bottom: 0, top: 30),
            child: Row(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(100.0)),
                  child: ParkingCardSkeleton(width: 20, height: 20),
                ),
                SizedBox(width: 10),
                ParkingCardSkeleton(width: 150, height: 10),
              ],
            ),
          ),
          Container(
            height: 330,
            padding: const EdgeInsets.only(top: 15, bottom: 20),
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Padding(
                padding: EdgeInsets.only(right: 20),
                child: BaseWidget.containerRounderRegular(
                  Container(
                    width: _screenSize.width,
                    padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Color(0xfff2f2f2), width: 2.0),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(14.0)),
                                  ),
                                  child: ClipRRect(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12.0)),
                                    child: Stack(
                                      clipBehavior: Clip.hardEdge,
                                      children: <Widget>[
                                        ParkingCardSkeleton(
                                            width: 40, height: 40),
                                      ],
                                    ),
                                  )),
                              SizedBox(width: 15),
                              Expanded(
                                  child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ParkingCardSkeleton(width: 60, height: 10),
                                  SizedBox(height: 5),
                                  ParkingCardSkeleton(width: 60, height: 10),
                                ],
                              ))
                            ]),
                        SizedBox(height: 25),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ParkingCardSkeleton(width: 50, height: 10),
                            ParkingCardSkeleton(width: 120, height: 10),
                          ],
                        ),
                        SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ParkingCardSkeleton(width: 50, height: 10),
                            ParkingCardSkeleton(width: 100, height: 10),
                          ],
                        ),
                        SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ParkingCardSkeleton(width: 50, height: 10),
                            ParkingCardSkeleton(width: 120, height: 10),
                          ],
                        ),
                        SizedBox(height: 20),
                        Expanded(
                          child: ParkingCardSkeleton(width: 100, height: 10),
                        ),
                        SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
