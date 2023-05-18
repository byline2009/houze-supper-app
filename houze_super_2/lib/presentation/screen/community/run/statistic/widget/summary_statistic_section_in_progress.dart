import 'package:flutter/material.dart';
import 'package:houze_super/presentation/common_widgets/skeletons/src/skeleton/parking_image_card_skeleton.dart';
import 'package:houze_super/presentation/screen/base/base_widget.dart';

class StatisticInProgress extends StatelessWidget {
  const StatisticInProgress({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BaseWidget.containerRounder(
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ParkingCardSkeleton(
                      width: 176,
                      height: 16,
                    ),
                    ParkingCardSkeleton(
                      width: 100,
                      height: 16,
                    ),
                  ],
                ),
                const SizedBox(height: 21),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ParkingCardSkeleton(
                            width: 130,
                            height: 16,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          ParkingCardSkeleton(
                            width: 83,
                            height: 16,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    DecoratedBox(
                      // margin: EdgeInsets.only(right: 15),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                      ),
                      child: const SizedBox(
                        width: 1,
                        height: 30,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ParkingCardSkeleton(width: 130, height: 16),
                          const SizedBox(height: 5),
                          ParkingCardSkeleton(width: 83, height: 16),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        ParkingCardSkeleton(width: 335, height: 16),
        const SizedBox(
          height: 10,
        ),
        ParkingCardSkeleton(width: 335, height: 16),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
