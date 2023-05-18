import 'package:carousel_slider/carousel_slider.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:houze_super/middle/model/shop_detail_model.dart';
import 'package:houze_super/middle/model/shop_model.dart';
import 'package:houze_super/presentation/common_widgets/widget_button.dart';
import 'package:houze_super/presentation/common_widgets/stateless/widget_cached_image.dart';
import 'package:houze_super/presentation/common_widgets/stateless/widget_scaffold_presentation.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/presentation/screen/base/base_widget.dart';
import 'package:houze_super/presentation/screen/home/home_tab/bloc/merchant/index.dart';
import 'package:houze_super/presentation/screen/home/home_tab/nearby_service/detail/widget_active_time.dart';
import 'package:houze_super/presentation/screen/home/home_tab/voucher/info/widget_voucher_collection.dart';
import 'package:houze_super/utils/index.dart';
import 'package:houze_super/utils/localizations_util.dart';

const String shopInfoKey = 'shopInfoKey';

class ShopInfomationScreenArgument {
  final ShopModel shop;
  ShopInfomationScreenArgument({@required this.shop});
}

class ShopInfomationScreen extends StatefulWidget {
  final ShopInfomationScreenArgument agrs;
  ShopInfomationScreen({@required this.agrs});

  @override
  State<StatefulWidget> createState() => _ShopInfomationScreenState();
}

class _ShopInfomationScreenState extends State<ShopInfomationScreen> {
  final _merchantBloc = MerchantBloc(MerchantInitial());
  CarouselSlider basicSlider;
  final CarouselController _controller = CarouselController();

  @override
  void initState() {
    super.initState();

    _merchantBloc.add(MerchantGetShopDetailByID(id: widget.agrs.shop.id));
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
        cubit: _merchantBloc,
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
              items: _shop.images.map((i) {
                return Builder(
                  builder: (BuildContext context) {
                    return CachedImageWidget(
                      cacheKey: shopInfoKey,
                      imgUrl: i.image,
                      width: double.infinity,
                    );
                  },
                );
              }).toList(),
            );

            return _shop.images.length > 0
                ? Stack(
                    children: <Widget>[
                      basicSlider,
                      Positioned(
                          child: Container(
                            decoration: BaseWidget.decorationStickIntro,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: Text(_shop.name,
                                style: AppFonts.bold24.copyWith(
                                    color: Colors.white, letterSpacing: 0.34)),
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
                : const SizedBox.shrink();
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
      cubit: this._merchantBloc,
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
                  LocalizationsUtil.of(context).translate('address_with_colon'),
                  style: AppFonts.medium.copyWith(color: Color(0xff808080)),
                ),
                const SizedBox(height: 5),
                Text(_shop.address,
                    style: AppFonts.medium14.copyWith(color: Colors.black)),
                const SizedBox(height: 22),
                (_shop.description != null)
                    ? Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            color: Color(0xfff5f5f5),
                            borderRadius:
                                BorderRadius.all(Radius.circular(4.0))),
                        child: Text(_shop.description))
                    : const SizedBox.shrink(),
                WidgetActiveTime(merchant: _shop),
                const SizedBox(height: 15),
                WidgetVoucherCollection(merchant: _shop)
              ],
            ),
          );
        }

        if (merchantState is MerchantShopFailure) {
          return SomethingWentWrong();
        }
        return const SizedBox.shrink();
      },
    );
  }
}
