import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// widget
import 'package:houze_super/presentation/app_router.dart';
import 'package:houze_super/presentation/common_widgets/stateless/widget_boxes_container.dart';
import 'package:houze_super/presentation/screen/base/base_widget.dart';
import 'package:houze_super/presentation/screen/payment/bloc/order/fee_v1_bloc.dart';
import 'package:houze_super/presentation/screen/payment/bloc/order/fee_v1_event.dart';
import 'package:houze_super/presentation/common_widgets/skeletons/src/skeleton/parking_image_card_skeleton.dart';
import 'package:houze_super/presentation/screen/payment/sc_fee_overview.dart';

// utils
import 'package:houze_super/utils/constants/constants.dart';
import 'package:houze_super/utils/index.dart';
import 'package:houze_super/utils/localizations_util.dart';
import 'package:houze_super/utils/string_util.dart';

class WidgetProperties extends StatefulWidget {
  final feeGroupApartmentBloc;
  final Function callback;

  WidgetProperties(
      {@required this.feeGroupApartmentBloc, this.callback, Key key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _WidgetPropertiesState();
}

class _WidgetPropertiesState extends State<WidgetProperties> {
  @override
  void initState() {
    super.initState();
  }

  onGoBack(dynamic value) {
    print('callback-----------------');
    widget.callback();
    // setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FeeGroupApartmentBloc>(
      create: (_) => widget.feeGroupApartmentBloc,
      child: BlocBuilder<FeeGroupApartmentBloc, FeeV1State>(
        builder: (BuildContext context, FeeV1State feeState) {
          if (!feeState.isLoading && feeState.feeGroupByApartments == null) {
            widget.feeGroupApartmentBloc.add(GetFeeGroupApartment());
          }

          // Loading
          if (feeState.feeGroupByApartments == null)
            return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 20),
                      child: ParkingCardSkeleton(width: 120, height: 20),
                    ),
                    Container(
                        color: Colors.white,
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Row(
                          children: <Widget>[
                            ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12.0)),
                                child: Stack(
                                  overflow: Overflow.clip,
                                  children: <Widget>[
                                    ParkingCardSkeleton(width: 60, height: 60),
                                  ],
                                )),
                            const SizedBox(width: 15),
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                ParkingCardSkeleton(width: 120, height: 12),
                                const SizedBox(height: 8),
                                ParkingCardSkeleton(width: 120, height: 10),
                                const SizedBox(height: 8),
                                ParkingCardSkeleton(width: 120, height: 10),
                              ],
                            )),
                          ],
                        ))
                  ],
                ));

          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(0),
            itemCount: feeState.feeGroupByApartments.length,
            itemBuilder: (c, index) {
              final buildingModel = feeState.feeGroupByApartments[index];

              return BaseWidget.boderBottom(
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: WidgetBoxesContainer(
                    title: buildingModel.buildingName,
                    styleTitle: AppFonts.bold18,
                    child: ListView.separated(
                      itemCount: feeState
                              .feeGroupByApartments[index].apartments.length ??
                          0,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(0),
                      itemBuilder: (context, _index) {
                        final feeApartment = feeState
                            .feeGroupByApartments[index].apartments[_index];
                        return FutureBuilder(
                            future: ServiceConverter.convertTypeService(
                                "apartment",
                                buildingModel.service +
                                    buildingModel.buildingType.toString()),
                            builder: (ctx, snap) {
                              if (snap.connectionState ==
                                  ConnectionState.waiting) {
                                return ParkingCardSkeleton(
                                    width: 120, height: 60);
                              }

                              return GestureDetector(
                                  onTap: () {
                                    AppRouter.pushParamsWithCallback(
                                      context,
                                      AppRouter.FEE_OVERVIEW_PAGE,
                                      FeeOverviewScreenArgument(
                                        apartmentId: feeApartment.id,
                                        buildingId: buildingModel.buildingId,
                                        title: buildingModel.buildingName,
                                        callback: widget.callback,
                                        typeService: snap.data,
                                      ),
                                      onGoBack,
                                    );
                                  },
                                  child: Container(
                                    key: Key(feeApartment.id),
                                    color: Colors.white,
                                    padding: const EdgeInsets.only(
                                        top: 20, bottom: 20),
                                    child: BaseWidget.propertyListTile(
                                      apartmentTitle:
                                          LocalizationsUtil.of(context)
                                                  .translate(snap.data) +
                                              " " +
                                              feeApartment.name,
                                      buildingImage:
                                          buildingModel.companyImageThumb,
                                      fee: StringUtil.feesTotal(
                                        feeApartment.fees,
                                        allowFee: buildingModel.feeAvailable,
                                      ),
                                      iconSize: 60,
                                      context: context,
                                    ),
                                  ));
                            });
                      },
                      separatorBuilder: (context, index) {
                        return Divider(
                            color: Color(0xfff5f5f5), thickness: 2, height: 0);
                      },
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
