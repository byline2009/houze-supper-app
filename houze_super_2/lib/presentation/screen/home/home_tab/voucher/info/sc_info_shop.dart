import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:houze_super/middle/model/shop_detail_model.dart';
import 'package:houze_super/middle/model/shop_model.dart';
import 'package:houze_super/presentation/common_widgets/widget_button.dart';
import 'package:houze_super/presentation/common_widgets/widget_cached_image.dart';
import 'package:houze_super/presentation/custom_ui/widget_scaffold_presentation.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/presentation/screen/base/base_widget.dart';
import 'package:houze_super/presentation/screen/home/home_tab/bloc/merchant/index.dart';
import 'package:houze_super/presentation/screen/home/home_tab/nearby_service/detail/widget_active_time.dart';
import 'package:houze_super/presentation/screen/home/home_tab/voucher/info/widget_voucher_collection.dart';

import '../../../../../base/route_aware_state.dart';

const String shopInfoKey = 'shopInfoKey';

class ShopInfomationScreenArgument {
  final ShopModel shop;
  ShopInfomationScreenArgument({required this.shop});
}

class ShopInfomationScreen extends StatefulWidget {
  final ShopInfomationScreenArgument agrs;
  ShopInfomationScreen({required this.agrs});

  @override
  State<StatefulWidget> createState() => _ShopInfomationScreenState();
}

class _ShopInfomationScreenState extends RouteAwareState<ShopInfomationScreen> {
  final _merchantBloc = MerchantBloc(MerchantInitial());
  late CarouselSlider basicSlider;
  final CarouselController _controller = CarouselController();

  @override
  void initState() {
    super.initState();

    _merchantBloc.add(MerchantGetShopDetailByID(id: widget.agrs.shop.id!));
  }

  @override
  void dispose() {
    _merchantBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffoldPresent(
        title: 'location_information',
        body: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.all(0),
            children: <Widget>[_buildCoverHeader(), _buildBody()]));
  }

  _buildCoverHeader() {
    final double heightIntro = 200;

    return BlocBuilder(
        bloc: _merchantBloc,
        builder: (BuildContext context, MerchantState merchantState) {
          if (merchantState is MerchantDetailSuccessful) {
            ShopDetailModel _shop = merchantState.result;
            basicSlider = CarouselSlider(
              carouselController: _controller,
              options: CarouselOptions(
                  height: heightIntro,
                  enlargeCenterPage: true,
                  viewportFraction: 1.0,
                  enableInfiniteScroll: true),
              items: _shop.images!.map((i) {
                return Builder(
                  builder: (BuildContext context) {
                    return CachedImageWidget(
                      cacheKey: shopInfoKey,
                      imgUrl: i.image!,
                      width: double.infinity,
                    );
                  },
                );
              }).toList(),
            );

            return _shop.images!.length > 0
                ? Stack(
                    children: <Widget>[
                      basicSlider,
                      Positioned(
                          child: Container(
                            decoration: BaseWidget.decorationStickIntro,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child:
                                Text(_shop.name!, style: AppFont.BOLD_WHITE_24),
                          ),
                          bottom: 0,
                          left: 0,
                          right: 0),
                      Positioned(
                          child: WidgetButton.arrowCircle(
                              Icon(Icons.chevron_left), () {
                            _controller.previousPage(
                                duration: Duration(milliseconds: 300),
                                curve: Curves.linear);
                          }),
                          bottom: heightIntro / 2.2,
                          left: 0),
                      Positioned(
                          child: WidgetButton.arrowCircle(
                              Icon(Icons.chevron_right), () {
                            _controller.nextPage(
                                duration: Duration(milliseconds: 300),
                                curve: Curves.linear);
                          }),
                          bottom: heightIntro / 2.2,
                          right: 0),
                    ],
                  )
                : Center();
          }

          return CardListSkeleton(
            shrinkWrap: true,
            length: 1,
            config: SkeletonConfig(
              theme: SkeletonTheme.Light,
              isShowAvatar: false,
              isCircleAvatar: false,
              bottomLinesCount: 2,
              radius: 0.0,
            ),
          );
        });
  }

  _buildBody() {
    return BlocBuilder(
      bloc: this._merchantBloc,
      builder: (BuildContext context, MerchantState merchantState) {
        if (merchantState is MerchantShopLoading) {
          return CardListSkeleton(
            shrinkWrap: true,
            length: 4,
            config: SkeletonConfig(
              theme: SkeletonTheme.Light,
              isShowAvatar: false,
              isCircleAvatar: false,
              bottomLinesCount: 4,
              radius: 0.0,
            ),
          );
        }

        if (merchantState is MerchantDetailSuccessful) {
          ShopDetailModel _shop = merchantState.result;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                    LocalizationsUtil.of(context)
                        .translate('address_with_colon'),
                    style: AppFonts.medium14.copyWith(
                      color: Color(
                        0xff5B00E4,
                      ),
                    )),
                SizedBox(height: 5),
                Text(_shop.address!, style: AppFonts.medium14),
                SizedBox(height: 22),
                (_shop.description != null)
                    ? Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            color: AppColor.gray_f5f5f5,
                            borderRadius:
                                BorderRadius.all(Radius.circular(4.0))),
                        child: Text(_shop.description!))
                    : SizedBox.shrink(),
                WidgetActiveTime(merchant: _shop),
                SizedBox(height: 15),
                WidgetVoucherCollection(merchant: _shop)
              ],
            ),
          );
        }

        if (merchantState is MerchantShopFailure) {
          return SomethingWentWrong();
        }
        return SizedBox.shrink();
      },
    );
  }
}
