import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:houze_super/presentation/common_widgets/widget_cached_image.dart';
import 'package:houze_super/presentation/custom_ui/sliver_grid_delegate_fixed_height.dart';
import 'package:houze_super/presentation/index.dart';

const String swapApartmentBoxKey = 'swapApartmentBoxKey';

class FeatureItem {
  final String name;
  final String icon;
  final String routeName;
  final dynamic arguments;

  FeatureItem({
    required this.name,
    required this.icon,
    required this.routeName,
    this.arguments,
  });
}

/*Tiện ích của tòa nhà*/
class WidgetSwapApartmentBox extends StatelessWidget {
  final BuildingSuccessArgument agrs;
  const WidgetSwapApartmentBox({required this.agrs});

  void _onTapSwitchBuilding(BuildContext context) {
    SwitchBuilding.showBottomSheet(
      buildings: agrs.buildings,
      currentBuildingID: agrs.currentBuilding.id!,
      contextParent: context,
    );
  }

  Widget _headerBuilding(BuildContext context) {
    final String _apartment = agrs.currentBuilding.convertApartments();
    return GestureDetector(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xfff2f2f2), width: 2.0),
                  borderRadius: const BorderRadius.all(Radius.circular(14.0)),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                  child: Stack(
                    clipBehavior: Clip.hardEdge,
                    children: <Widget>[
                      CachedImageWidget(
                        cacheKey: swapApartmentBoxKey,
                        imgUrl: agrs.currentBuilding.company!.imageThumb!,
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
                  Text(agrs.currentBuilding.name!, style: AppFonts.bold18),
                  const SizedBox(height: 8),
                  _apartment.length > 0
                      ? FutureBuilder(
                          future: serviceConverter(),
                          builder: (context, snap) {
                            if (snap.connectionState ==
                                ConnectionState.waiting) {
                              return SizedBox.shrink();
                            }
                            return WidgetRichText(
                              myString: LocalizationsUtil.of(context)
                                      .translate(snap.data) +
                                  ' ' +
                                  _apartment,
                              wordToStyle: _apartment,
                              style: AppFont.SEMIBOLD_BLACK_13
                                  .copyWith(letterSpacing: 0.26),
                            );
                          },
                        )
                      : SizedBox.shrink(),
                ],
              ),
            ),
            WidgetTextBase.textTopRightHasICon(
              LocalizationsUtil.of(context).translate('change'),
              style: AppFonts.medium14.copyWith(
                color: Color(
                  0xff5B00E4,
                ),
              ),
              iconName: AppVectors.icSwapHoriz,
              onPressed: () => _onTapSwitchBuilding(context),
            ),
          ],
        ),
        onTap: () => _onTapSwitchBuilding(context));
  }

  //Service converter
  Future<String> serviceConverter() {
    Future<String> service;
    service = ServiceConverter.convertTypeBuilding("apartment");
    return service;
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: WidgetBoxesContainer(
        hasLine: true,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
          child: Column(
            children: <Widget>[
              _headerBuilding(context),
              CollectionFeatureWidget(
                statusSale: agrs.currentBuilding.statusSale!,
                isMicro: agrs.currentBuilding.isMicro!,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/* Collection in a building*/
class CollectionFeatureWidget extends StatelessWidget {
  final int statusSale;
  final bool isMicro;

  CollectionFeatureWidget({
    required this.statusSale,
    required this.isMicro,
  });
  final _categories = [
    FeatureItem(
      name: 'request_0',
      icon: AppVectors.icSendissue,
      routeName: AppRouter.TICKET_CREATE,
    ),
    FeatureItem(
      name: 'parking_card',
      icon: AppVectors.icParking,
      routeName: AppRouter.PARKING,
    ),
    FeatureItem(
      name: 'emergency',
      icon: AppVectors.icSOS,
      routeName: AppRouter.SOS_PAGE,
    ),
    FeatureItem(
      name: 'for_sell_lease',
      icon: AppVectors.icSellRent,
      routeName: AppRouter.SELL,
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
  @override
  Widget build(BuildContext context) {
    //Enable / Disable sell
    if (statusSale == 1)
      _categories.removeWhere((element) => element.routeName == AppRouter.SELL);

    // if (isMicro) _categories.removeWhere((e) => e.name == 'parking_card');

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.only(top: 15, bottom: 15),
      itemCount: _categories.length,
      itemBuilder: (context, index) {
        var item = _categories[index];
        return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.transparent,
                    elevation: 0,
                    tapTargetSize: MaterialTapTargetSize.padded,
                    padding: EdgeInsets.all(0),
                  ),
                  child: SvgPicture.asset(item.icon),
                  onPressed: () {
                    if (item.routeName == AppRouter.SOS_PAGE) {
                      AppRouter.pushDialog(
                          context, AppRouter.SOS_PAGE, item.arguments);
                    } else {
                      AppRouter.push(
                        context,
                        item.routeName,
                        item.arguments,
                        item.routeName == AppRouter.SELL ? false : true,
                      );
                    }
                  }),
              const SizedBox(height: 9),
              Text(
                LocalizationsUtil.of(context).translate(item.name),
                textAlign: TextAlign.center,
                style: AppFonts.medium14,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )
            ]);
      },
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight(
          crossAxisCount: 3,
          crossAxisSpacing: 1,
          mainAxisSpacing: 1,
          height: 100),
    );
  }
}
