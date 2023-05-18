import 'package:flutter/material.dart';
import 'package:houze_super/middle/model/page_model.dart';
import 'package:houze_super/middle/model/shop_model.dart';
import 'package:houze_super/middle/repo/merchant_repo.dart';
import 'package:houze_super/presentation/common_widgets/skeletons/src/skeleton/card_horizontal_skeleton.dart';
import 'package:houze_super/presentation/common_widgets/widget_cached_image.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/presentation/screen/home/home_tab/nearby_service/detail/sc_places_around_detail.dart';

const String nearByServiceBoxKey = 'nearByServiceBoxKey';

/*
Widget: Địa điểm dịch vụ xung quanh
 */
class WidgetNearByServiceBox extends StatefulWidget {
  final String point;

  const WidgetNearByServiceBox({required this.point});
  @override
  _WidgetNearByServiceBoxState createState() => _WidgetNearByServiceBoxState();
}

class _WidgetNearByServiceBoxState extends State<WidgetNearByServiceBox> {
  final _repo = MerchantRepository();
  late Future<PageModel> _nearByPageModel;

  @override
  void initState() {
    super.initState();
    _nearByPageModel = _repo.getLimitShops(widget.point);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: FutureBuilder<PageModel>(
          future: _nearByPageModel,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return WidgetBoxesContainer(
                  child: Container(
                    height: 240.0,
                    padding: EdgeInsets.only(left: 20, top: 10),
                    child: CardListHorizontalSkeleton(
                      length: 5,
                      config: SkeletonConfig(
                        theme: SkeletonTheme.Light,
                        radius: 10.0,
                      ),
                    ),
                  ),
                );
              default:
                if (snapshot.hasError)
                  return WidgetBoxesContainer(
                    child: snapshot.error.toString().contains('NoDataException')
                        ? SomethingWentWrong(true)
                        : SomethingWentWrong(),
                  );
                else {
                  List<ShopModel> list = (snapshot.data!.results as List)
                      .map((e) => ShopModel.fromJson(e))
                      .toList();

                  if (list.length == 0) {
                    return WidgetBoxesContainer(
                        hasLine: false, child: Container(color: Colors.white));
                  }
                  return WidgetBoxesContainer(
                    title: 'services_nearby',
                    hasLine: true,
                    action: WidgetTextBase.textTopRight(
                        LocalizationsUtil.of(context).translate(
                            LocalizationsUtil.of(context).translate('see_all')),
                        () {
                      AppRouter.pushNoParams(
                          context, AppRouter.NEAR_BY_SERVICE_PAGE);
                    }),
                    padding: EdgeInsets.only(
                        left: 20, right: 20, top: 10, bottom: 10),
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 30),
                      child: SizedBox(
                        height: StyleHomePage.containerServiceHeight,
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: list.length,
                          itemBuilder: (BuildContext context, int index) {
                            double _right =
                                (index == list.length - 1) ? 20.0 : 0.0;

                            return GestureDetector(
                                onTap: () {
                                  AppRouter.push(
                                      context,
                                      AppRouter.PLACES_DETAIL_PAGE,
                                      PlacesDetailScreenArgument(
                                          shop: list[index]));
                                },
                                child: Container(
                                    key: Key(list[index].id!),
                                    padding: EdgeInsets.only(
                                        left: 20, right: _right),
                                    child:
                                        WidgetServiceItem(model: list[index])));
                          },
                        ),
                      ),
                    ),
                  );
                }
            }
          }),
    );
  }
}

// Build each service near by item
class WidgetServiceItem extends StatelessWidget {
  final ShopModel model;
  const WidgetServiceItem({required this.model});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: StyleHomePage.serviceWidth,
        height: StyleHomePage.containerServiceHeight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                child: Stack(clipBehavior: Clip.hardEdge, children: <Widget>[
                  model.image?.imageThumb != null
                      ? CachedImageWidget(
                          width: StyleHomePage.serviceWidth,
                          height: StyleHomePage.serviceImageHeight,
                          cacheKey: nearByServiceBoxKey,
                          imgUrl: model.image!.imageThumb!)
                      : Image.asset(
                          "assets/images/default-image.png",
                          fit: BoxFit.cover,
                          width: StyleHomePage.serviceWidth,
                          height: StyleHomePage.serviceImageHeight,
                        ),
                  Positioned(
                      bottom: 5,
                      left: 5,
                      child: model.distance == null ||
                              model.distance?.ceil() == null
                          ? Center()
                          : Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              child: Center(
                                  child: Text(
                                      model.distance != null
                                          ? model.distance!.ceil().toString() +
                                              ' m'
                                          : '0',
                                      style: AppFonts.medium14)),
                              decoration: BoxDecoration(
                                  color: AppColor.gray_eff2fc,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12.0))),
                            ))
                ])),
            SizedBox(height: 10),
            Text(model.name!,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                softWrap: false,
                style: AppFont.BOLD_BLACK_15),
            SizedBox(height: 1),
            Text(model.address ?? '',
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                softWrap: false,
                style: AppFont.SEMIBOLD_GRAY_808080_13),
          ],
        ));
  }
}
