import 'package:flutter/material.dart';
import 'package:houze_super/middle/model/fee/fee_model.dart';

// widget
import 'package:houze_super/presentation/screen/base/base_widget.dart';
import 'package:houze_super/presentation/common_widgets/skeletons/src/skeleton/parking_image_card_skeleton.dart';
import 'package:houze_super/presentation/screen/payment/sc_fee_overview.dart';

import '../../../index.dart';

class WidgetProperties extends StatelessWidget {
  final Function callback;
  final List<FeeGroupByApartments>? feeGroupByApartments;

  const WidgetProperties({
    required this.callback,
    required this.feeGroupByApartments,
    Key? key,
  }) : super(key: key);

  void onGoBack(dynamic value) {
    callback();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(0),
      itemCount: feeGroupByApartments!.length,
      itemBuilder: (c, index) {
        final buildingModel = feeGroupByApartments![index];

        return BaseWidget.boderBottom(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: WidgetBoxesContainer(
              hasLine: false,
              title: buildingModel.buildingName,
              styleTitle: AppFonts.bold18,
              child: ListView.separated(
                itemCount: buildingModel.apartments?.length ?? 0,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(0),
                itemBuilder: (context, _index) {
                  final feeApartment = buildingModel.apartments![_index];
                  return FutureBuilder(
                    future: ServiceConverter.convertTypeService(
                        "apartment",
                        buildingModel.service! +
                            buildingModel.buildingType.toString()),
                    builder: (context, snap) {
                      if (snap.connectionState == ConnectionState.waiting) {
                        return ParkingCardSkeleton(width: 120, height: 60);
                      }
                      return GestureDetector(
                        onTap: () {
                          AppRouter.pushParamsWithCallback(
                            context,
                            AppRouter.PAYMENT_FEE_OVERVIEW_PAGE,
                            FeeOverviewScreenArgument(
                              apartmentId: feeApartment.id!,
                              feeGroupByApartments: buildingModel,
                              callback: callback,
                              typeService: snap.data as String,
                            ),
                            onGoBack,
                          );
                        },
                        child: DecoratedBox(
                          key: Key(feeApartment.id!),
                          decoration: BoxDecoration(
                            color: Colors.white,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20, bottom: 20),
                            child: BaseWidget.propertyListTile(
                              apartmentTitle: LocalizationsUtil.of(context)
                                      .translate(snap.data) +
                                  " " +
                                  feeApartment.name!,
                              buildingImage: buildingModel.companyImageThumb,
                              fee: StringUtil.feesTotal(
                                feeApartment.fees!,
                                allowFee: buildingModel.feeAvailable!,
                              ),
                              iconSize: 60,
                              context: context,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
                separatorBuilder: (context, index) {
                  return const Divider(
                    color: Color(0xfff5f5f5),
                    thickness: 2,
                    height: 0,
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
