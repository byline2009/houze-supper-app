import 'package:flutter/material.dart';

// Widgets
import 'package:houze_super/presentation/common_widgets/skeletons/src/skeleton/parking_image_card_skeleton.dart';

class ManualTransferLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _widthImage = MediaQuery.of(context).size.width * 50 / 100 - 20;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(bottom: 20.0),
          child: ParkingCardSkeleton(
            height: 50,
            width: double.infinity,
            borderRadius: 5,
          ),
        ),
        ParkingCardSkeleton(
          height: 20,
          width: double.infinity,
        ),
        Container(
          margin: EdgeInsets.only(top: 20.0),
          child: ParkingCardSkeleton(
            height: 60,
            width: 60,
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        ParkingCardSkeleton(
          height: 20,
          width: 200,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              ParkingCardSkeleton(
                height: _widthImage,
                width: _widthImage,
              ),
              Container(
                height: 220,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: Container(
                        padding: const EdgeInsets.only(left: 4.0),
                        margin: EdgeInsets.only(left: 10.0, bottom: 20.0),
                        child: ParkingCardSkeleton(
                          height: 60,
                          width: _widthImage - 20,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
