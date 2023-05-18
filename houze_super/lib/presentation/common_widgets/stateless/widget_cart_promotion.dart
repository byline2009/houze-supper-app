import 'package:flutter/material.dart';
import 'package:houze_super/middle/model/coupon_model.dart';
import 'package:houze_super/presentation/app_router.dart';
import 'package:houze_super/presentation/common_widgets/stateless/text_limit_widget.dart';
import 'package:houze_super/presentation/common_widgets/stateless/widget_cached_image.dart';
import 'package:houze_super/presentation/screen/home/home_tab/voucher/sc_voucher_detail.dart';
import 'package:houze_super/utils/constants/constants.dart';

const String cartPromotionKey = 'cartPromotionKey';

class CardPromotionWidget extends StatelessWidget {
  final CouponModel couponModel;

  CardPromotionWidget({@required this.couponModel});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          AppRouter.push(context, AppRouter.VOUCHER_DETAIL_PAGE,
              MyVoucherDetailScreenArgument(couponModel: couponModel));
        },
        child: Column(
          children: <Widget>[
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(4.0),
                  topRight: Radius.circular(4.0),
                ),
                child: Stack(
                  children: <Widget>[
                    CachedImageWidget(
                      cacheKey: cartPromotionKey,
                      imgUrl: this.couponModel.images[0].image,
                      width: double.infinity,
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                          height: 35,
                          width: double.minPositive,
                          padding: const EdgeInsets.only(left: 12, right: 12),
                          child: Row(
                            children: <Widget>[
                              TextLimitWidget(this.couponModel.shops[0].name,
                                  maxLines: 1,
                                  style: AppFonts.semibold12
                                      .copyWith(color: Colors.white))
                            ],
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.8),
                            gradient: LinearGradient(
                              colors: <Color>[
                                Colors.black12,
                                Colors.black,
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          )),
                    ),
                  ],
                ),
              ),
            ),
            Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(4.0),
                      bottomRight: Radius.circular(4.0),
                    ),
                    border: Border.all(
                        color: Color(0xffdcdcdc),
                        width: 1,
                        style: BorderStyle.solid)),
                padding:
                    EdgeInsets.only(left: 12, right: 12, top: 10, bottom: 18),
                height: 75,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextLimitWidget(this.couponModel.title,
                        maxLines: 2, style: AppFonts.bold15)
                  ],
                ))
          ],
        ));
  }
}
