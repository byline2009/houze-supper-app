import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:houze_super/middle/model/coupon_model.dart';
import 'package:houze_super/middle/model/shop_detail_model.dart';
import 'package:houze_super/presentation/common_widgets/skeletons/flutter_skeleton.dart';
import 'package:houze_super/presentation/common_widgets/skeletons/src/skeleton/card_horizontal_skeleton.dart';
import 'package:houze_super/presentation/common_widgets/stateless/widget_cart_promotion.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/presentation/screen/home/home_tab/nearby_service/bloc/coupon/index.dart';
import 'package:houze_super/utils/constants/constants.dart';
import 'package:houze_super/utils/localizations_util.dart';

class WidgetPromotionList extends StatelessWidget {
  final ShopDetailModel merchant;
  WidgetPromotionList({@required this.merchant});

  @override
  Widget build(BuildContext context) {
    final _couponBloc = CouponBloc(CouponInitial());
    List<CouponModel> list = [];
    List<CouponModel> _listTemp = [];
    return BlocBuilder(
      cubit: _couponBloc,
      builder: (BuildContext context, CouponState couponState) {
        if (couponState is CouponInitial) {
          _couponBloc
              .add(MerchantLoadCouponsByShop(shopId: merchant.id, page: 0));
        }
        if (couponState is CouponsLoading) {
          return Container(
              height: 180,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CardListHorizontalSkeleton(
                length: 3,
                config: SkeletonConfig(
                  theme: SkeletonTheme.Light,
                  radius: 4.0,
                ),
              ));
        }

        if (couponState is MerchantLoadCouponsShopFailure)
          return SomethingWentWrong();

        if (couponState is MerchantLoadCouponsByShopSuccessful) {
          List<CouponModel> test = (couponState.result.results).map((i) {
            return i;
          }).toList();
          _listTemp.addAll(test);
          list.addAll(test.toList());
        }
        String title = LocalizationsUtil.of(context).translate('voucher_code') +
            ((list != null) ? " (" + list.length.toString() + ")" : "");
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(title, style: AppFonts.bold24),
            SizedBox(height: 15),
            AnimationLimiter(
              child: GridView.count(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                childAspectRatio: 1.0,
                mainAxisSpacing: 15,
                crossAxisSpacing: 15,
                crossAxisCount: 2,
                children: List.generate(
                  list.length,
                  (int index) {
                    return AnimationConfiguration.staggeredGrid(
                      columnCount: 2,
                      position: index,
                      duration: const Duration(milliseconds: 200),
                      child: SlideAnimation(
                        verticalOffset: 50.0,
                        duration: const Duration(milliseconds: 300),
                        child: CardPromotionWidget(couponModel: list[index]),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
