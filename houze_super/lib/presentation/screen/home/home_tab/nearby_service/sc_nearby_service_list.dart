import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:houze_super/middle/model/merchant_list_model.dart';
import 'package:houze_super/middle/model/shop_model.dart';
import 'package:houze_super/presentation/common_widgets/pull_to_refresh/pull_to_refresh.dart';
import 'package:houze_super/presentation/common_widgets/stateless/text_limit_widget.dart';
import 'package:houze_super/presentation/common_widgets/stateless/widget_base_scaffold.dart';
import 'package:houze_super/presentation/common_widgets/stateless/widget_cached_image.dart';
import 'package:houze_super/presentation/common_widgets/stateless/widget_slide_animation.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/presentation/screen/base/base_widget.dart';
import 'package:houze_super/presentation/screen/home/home_tab/nearby_service/bloc/services/services_bloc.dart';
import 'package:houze_super/presentation/screen/home/home_tab/nearby_service/bloc/services/services_event.dart';
import 'package:houze_super/presentation/screen/home/home_tab/nearby_service/detail/sc_places_around_detail.dart';
import 'package:houze_super/presentation/screen/home/home_tab/nearby_service/widget_category.dart';
import 'package:houze_super/presentation/screen/mailbox/ticket/widget_footer.dart';
import 'package:houze_super/utils/index.dart';
import 'package:houze_super/utils/localizations_util.dart';
import 'package:houze_super/utils/settings/places_categories.dart';
import 'package:flutter/cupertino.dart';

const String nearByServiceKey = 'nearByServiceKey';

class NearbyScreen extends StatefulWidget {
  NearbyScreen();

  @override
  State<StatefulWidget> createState() => _NearbyScreenState();
}

class _NearbyScreenState extends State<NearbyScreen> {
  int typePick = -1;
  int defaultTypeIndex = 0;
  ServicesNearByListBloc _servicesNearByListBloc =
      ServicesNearByListBloc(MerchantList(data: []));
  final _refreshController = RefreshController(initialRefresh: true);

  @override
  void initState() {
    super.initState();

    _servicesNearByListBloc
        .add(MerchantLoadShopsByType(page: -1, type: typePick));
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
        title: 'services_nearby',
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildCategoryHeader(),
            _buildTotalShopLine(),
            _buildShopListByType()
          ],
        ));
  }

  _buildCategoryHeader() => CategoryWidget(
        datasource: PlacesAround.categories,
        callback: (int index, dynamic value) {
          typePick = value;
          defaultTypeIndex = index;

          _servicesNearByListBloc
              .add(MerchantLoadShopsByType(page: -1, type: typePick));
        },
        defaultIndex: defaultTypeIndex,
      );

  _buildTotalShopLine() {
    return BlocBuilder(
      cubit: _servicesNearByListBloc,
      builder: (BuildContext context, MerchantList merchantList) {
        return Padding(
          child: RichText(
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                  text: LocalizationsUtil.of(context)
                      .translate('there_are_with_space')
                      .replaceFirst(
                          "{0}", merchantList.count == 1 ? "is" : "are"),
                  style: AppFonts.regular15,
                ),
                TextSpan(
                  text: (merchantList?.count.toString() ?? "") + " ",
                  style: AppFonts.bold15,
                ),
                TextSpan(
                  text: LocalizationsUtil.of(context)
                      .translate('location_with_lower_case')
                      .replaceFirst("{0}", merchantList.count == 1 ? "" : "s"),
                  style: AppFonts.regular15,
                ),
              ],
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        );
      },
    );
  }

  _buildShopListByType() {
    return Expanded(
        child: BlocProvider<ServicesNearByListBloc>(
      create: (_) => _servicesNearByListBloc,
      child: BlocBuilder<ServicesNearByListBloc, MerchantList>(
          builder: (BuildContext context, MerchantList merchantList) {
        if (merchantList == null) {
          return Container(
            color: Colors.white,
            child: Text(
              LocalizationsUtil.of(context).translate('currently_empty'),
            ),
          );
        }

        if (!this._servicesNearByListBloc.isNext &&
            merchantList != null &&
            merchantList.data.length == 0) {
          return Align(
            child: Column(
              children: <Widget>[
                const SizedBox(height: 60),
                SvgPicture.asset(AppVectors.ic_place_empty),
                const SizedBox(height: 15),
                Text(
                  LocalizationsUtil.of(context).translate(
                      "location_is_being_updated_currently_there_are_no_locations"),
                  style: AppFonts.medium16.copyWith(
                    color: Color(0xff808080),
                  ),
                ),
              ],
            ),
          );
        }

        _refreshController.loadComplete();
        _refreshController.refreshCompleted();

        return SmartRefresher(
            enablePullDown: true,
            enablePullUp: true,
            header: MaterialClassicHeader(),
            controller: _refreshController,
            onRefresh: () {
              this
                  ._servicesNearByListBloc
                  .add(MerchantLoadShopsByType(page: -1, type: typePick));
            },
            onLoading: () {
              if (mounted) {
                this._servicesNearByListBloc.add(
                      MerchantLoadShopsByType(type: typePick),
                    );
              }
            },
            footer: WidgetFooter(
              datasource: merchantList.data,
              shouldLoadMore:
                  merchantList != null && merchantList.data.length == 0,
            ),
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                padding: const EdgeInsets.all(0),
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: merchantList.data.length,
                itemBuilder: (BuildContext context, int index) {
                  ShopModel item = merchantList.data[index];
                  return WidgetSlideAnimation(
                      position: index, child: _buildServiceItem(item));
                }));
      }),
    ));
  }

  Widget _buildServiceItem(ShopModel shop) {
    return GestureDetector(
      onTap: () {
        AppRouter.push(context, AppRouter.PLACES_DETAIL_PAGE,
            PlacesDetailScreenArgument(shop: shop));
      },
      child: Container(
        key: Key(shop.id),
        decoration: BaseWidget.dividerTop(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(shop.name, style: AppFonts.bold.copyWith(fontSize: 16)),
                  const SizedBox(height: 5),
                  Row(children: <Widget>[
                    TextLimitWidget(
                      shop.address,
                      style: AppFonts.semibold13.copyWith(
                        color: Color(0xff838383),
                      ),
                      maxLines: 2,
                    )
                  ]),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      BaseWidget.listTagWidget(
                          LocalizationsUtil.of(context)
                              .translate(shop.getCategoryByType().title),
                          null),
                      BaseWidget.listTagWidget(null, shop.distance),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Container(
              width: 73,
              height: 73,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  color: Color(0xfff5f5f5)),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                child: Stack(
                  overflow: Overflow.clip,
                  children: <Widget>[
                    CachedImageWidget(
                      cacheKey: nearByServiceKey,
                      imgUrl: shop.image?.image ?? '',
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
