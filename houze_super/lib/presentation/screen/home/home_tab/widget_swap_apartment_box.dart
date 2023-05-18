import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:houze_super/middle/model/building_model.dart';
import 'package:houze_super/presentation/common_widgets/stateless/widget_cached_image.dart';
import 'package:houze_super/presentation/custom_ui/sliver_grid_delegate_fixed_height.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/presentation/screen/base/base_widget.dart';
import 'package:houze_super/presentation/screen/home/home_tab/widget_bottom_sheet_switch_building.dart';
import 'package:houze_super/utils/constants/constants.dart';
import 'package:houze_super/utils/index.dart';

import 'building_success_argument.dart';

const String swapApartmentBoxKey = 'swapApartmentBoxKey';

class FeatureItem {
  final String name;
  final String icon;
  final String routeName;
  final dynamic arguments;

  FeatureItem({
    @required this.name,
    @required this.icon,
    this.routeName,
    this.arguments,
  });
}

/*Tiện ích của tòa nhà*/
class WidgetSwapApartmentBox extends StatelessWidget {
  final BuildingSuccessArgument agrs;
  const WidgetSwapApartmentBox({this.agrs});

  void _onTapSwitchBuilding(BuildContext context) {
    SwitchBuilding.showBottomSheet(
      buildings: agrs.buildings,
      currentBuildingID: agrs.currentBuilding.id,
      contextParent: context,
    );
  }

  //Service converter
  Future<String> serviceConverter() {
    Future<String> service;
    service = ServiceConverter.convertTypeBuilding("apartment");
    return service;
  }

  @override
  Widget build(BuildContext context) {
    return headerContent(agrs.currentBuilding, context);
  }

  Widget headerContent(BuildingMessageModel building, BuildContext context) {
    String _apartment = building.convertApartments();

    final _headerBuilding = GestureDetector(
        child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xfff2f2f2), width: 2.0),
                      borderRadius: BorderRadius.all(Radius.circular(14.0)),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      child: Stack(
                        overflow: Overflow.clip,
                        children: <Widget>[
                          CachedImageWidget(
                            cacheKey: swapApartmentBoxKey,
                            imgUrl: building.company.imageThumb,
                            width: 48.0,
                            height: 48.0,
                          ),
                        ],
                      ),
                    )),
                const SizedBox(width: 15),
                Expanded(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(building.name,
                        style: AppFonts.bold.copyWith(fontSize: 18)),
                    const SizedBox(height: 8),
                    _apartment.length > 0
                        ? FutureBuilder(
                            future: serviceConverter(),
                            builder: (context, snap) {
                              if (snap.connectionState ==
                                  ConnectionState.waiting) {
                                return const SizedBox.shrink();
                              }
                              return WidgetRichText(
                                myString: LocalizationsUtil.of(context)
                                        .translate(snap.data) +
                                    ' ' +
                                    _apartment,
                                wordToStyle: _apartment,
                                style: AppFonts.semibold13
                                    .copyWith(letterSpacing: 0.26),
                              );
                            },
                          )
                        : const SizedBox.shrink(),
                  ],
                )),
                WidgetTextBase.textTopRightHasICon(
                  LocalizationsUtil.of(context).translate('change'),
                  style: AppFonts.medium14.copyWith(color: Color(0xff5b00e4)),
                  iconName: AppVectors.icSwapHoriz,
                  onPressed: () => _onTapSwitchBuilding(context),
                )
              ],
            ),
            color: Colors.white),
        onTap: () => _onTapSwitchBuilding(context));

    return SliverToBoxAdapter(
        child: Container(
            decoration: BaseWidget.decorationDividerGray,
            child: Column(
              children: <Widget>[
                const SizedBox(height: 5),
                _headerBuilding,
                CollectionFeatureWidget(
                  statusSale: agrs.currentBuilding.statusSale,
                  isMicro: agrs.currentBuilding.isMicro,
                ),
                const SizedBox(height: 5),
              ],
            ),
            padding: const EdgeInsets.only(
                left: 20, right: 20, top: 20, bottom: 0)));
  }
}

/* Collection in a building*/
class CollectionFeatureWidget extends StatelessWidget {
  final int statusSale;
  final bool isMicro;

  CollectionFeatureWidget({
    @required this.statusSale,
    @required this.isMicro,
  });

  @override
  Widget build(BuildContext context) {
    final _categories = [
      FeatureItem(
        name: 'request_0',
        icon: AppVectors.icSendissue,
        routeName: AppRouter.sendRequest,
      ),
      FeatureItem(
        name: 'parking_card',
        icon: AppVectors.icParking,
        routeName: AppRouter.parkingCardList,
      ),
      FeatureItem(
        name: 'emergency',
        icon: AppVectors.icSOS,
        routeName: AppRouter.SOS_PAGE,
      ),
      FeatureItem(
        name: 'for_sell_lease',
        icon: AppVectors.icSellRent,
        routeName: AppRouter.forSellLease,
      ),
      FeatureItem(
        name: 'voucher',
        icon: AppVectors.icVoucher,
        routeName: AppRouter.VOUCHER_LIST_PAGE,
      ),
      FeatureItem(
        name: 'handbook',
        icon: AppVectors.icNotebook,
        routeName: AppRouter.HANDBOOK,
      ),
    ];
    //Enable / Disable sell
    if (statusSale == 1)
      _categories.removeWhere(
          (element) => element.routeName == AppRouter.forSellLease);

    // if (isMicro) _categories.removeWhere((e) => e.name == 'parking_card');

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.only(top: 15, bottom: 15),
      itemCount: _categories.length,
      itemBuilder: (context, index) {
        var item = _categories[index];
        return Container(
            key: Key(item.routeName),
            padding: const EdgeInsets.all(0),
            margin: EdgeInsets.zero,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  InkWell(
                      child: SvgPicture.asset(item.icon),
                      onTap: () {
                        if (item.routeName == AppRouter.SOS_PAGE) {
                          AppRouter.pushDialog(
                              context, AppRouter.SOS_PAGE, item.arguments);
                        } else {
                          AppRouter.push(
                            context,
                            item.routeName,
                            item.arguments,
                            item.routeName == AppRouter.forSellLease
                                ? false
                                : true,
                          );
                        }
                      }),
                  const SizedBox(height: 9),
                  Text(LocalizationsUtil.of(context).translate(item.name),
                      textAlign: TextAlign.center,
                      style: AppFonts.medium14.copyWith(color: Colors.black))
                ]));
      },
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight(
          crossAxisCount: 3,
          crossAxisSpacing: 1,
          mainAxisSpacing: 1,
          height: 100),
    );
  }
}
