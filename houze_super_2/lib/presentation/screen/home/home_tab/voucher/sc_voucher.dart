import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:houze_super/middle/local/storage.dart';
import 'package:houze_super/middle/model/coupon_model.dart';
import 'package:houze_super/presentation/common_widgets/widget_cart_promotion.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/presentation/screen/home/home_tab/nearby_service/bloc/coupon/coupon_list_bloc.dart';
import 'package:houze_super/presentation/screen/home/home_tab/nearby_service/bloc/coupon/index.dart';
import 'package:houze_super/presentation/screen/home/home_tab/nearby_service/widget_category.dart';
import 'package:houze_super/utils/firebase_analytic/firebase_analytics.dart';

import '../../../../base/route_aware_state.dart';

class VouchersScreen extends StatefulWidget {
  @override
  _VoucherScreenState createState() => _VoucherScreenState();
}

class _VoucherScreenState extends RouteAwareState<VouchersScreen> {
  int typePick = -1;
  int typeFirst = -1;
  int defaultTypeIndex = 0;
  var _couponListBloc = CouponListBloc(CouponListModel());
  RefreshController _refreshController =
      RefreshController(initialRefresh: true);

  @override
  void initState() {
    super.initState();
    //Firebase Analytics
    GetIt.instance<FBAnalytics>()
        .sendEventViewVoucher(userID: Storage.getUserID() ?? "");
    _couponListBloc.add(CouponLoadList(page: -1, type: typePick));
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
        title: 'voucher',
        actions: <Widget>[_buildAction()],
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

  _buildAction() => Stack(
        children: <Widget>[
          TextButton(
            style: ButtonStyle(
              shape: MaterialStateProperty.all<CircleBorder>(CircleBorder()),
              padding: MaterialStateProperty.all<EdgeInsets>(
                  const EdgeInsets.only(right: 10.0)),
              overlayColor: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed))
                  return AppColor.purple_f2e8ff;
                return null;
              }),
            ),
            child: SvgPicture.asset(
                "assets/svg/icon/service/graphic-my-voucher.svg"),
            onPressed: () {
              AppRouter.pushDialogNoParams(
                context,
                AppRouter.MY_VOUCHER_SCREEN,
              );
            },
          ),
          Positioned(
              left: 9,
              top: 7,
              child: Container(
                height: 15,
                width: 15,
                decoration: BoxDecoration(
                    color: Colors.red,
                    border: Border.all(
                        width: 1,
                        color: Colors.white,
                        style: BorderStyle.solid),
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
              )),
        ],
      );

  _buildCategoryHeader() => CategoryWidget(
        datasource: Voucher.categories,
        callback: (int index, dynamic value) {
          if (typePick == value) {
            return;
          }
          typePick = value;
          defaultTypeIndex = index;
          _couponListBloc.add(CouponLoadList(page: -1, type: typePick));
        },
        defaultIndex: defaultTypeIndex,
      );

  _buildTotalShopLine() {
    return BlocBuilder(
        bloc: _couponListBloc,
        builder: (BuildContext context, CouponListModel couponList) {
          return Padding(
            child: RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: LocalizationsUtil.of(context)
                        .translate('there_are_with_space')
                        .replaceFirst(
                            "{0}", couponList.count == 1 ? "is " : "are "),
                    style: AppFonts.regular15,
                  ),
                  TextSpan(
                    text: (couponList.count != null)
                        ? '${couponList.count.toString()} '
                        : "",
                    style: AppFont.BOLD_BLACK_15,
                  ),
                  TextSpan(
                    text: LocalizationsUtil.of(context)
                        .translate('voucher_with_lower_case')
                        .replaceFirst("{0}", couponList.count == 1 ? "" : "s"),
                    style: AppFonts.regular15,
                  ),
                ],
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          );
        });
  }

  _buildShopListByType() {
    return Expanded(
        child: BlocBuilder(
            bloc: _couponListBloc,
            builder: (BuildContext context, CouponListModel? couponList) {
              if (couponList!.data == null) {
                return WidgetVoucherEmpty(padding: 60);
              }

              if (!_couponListBloc.isNext && couponList.count == 0) {
                return WidgetVoucherEmpty(padding: 60);
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
                      ._couponListBloc
                      .add(CouponLoadList(page: -1, type: typePick));
                },
                onLoading: () {
                  if (mounted) {
                    this._couponListBloc.add(
                          CouponLoadList(type: typePick),
                        );
                  }
                },
                footer: CustomFooter(
                  builder: (BuildContext context, LoadStatus mode) {
                    Widget body = SizedBox.shrink();
                    if (couponList.count == 0) {
                      mode = LoadStatus.noMore;
                    }

                    if (mode == LoadStatus.loading) {
                      body = CupertinoActivityIndicator();
                    } else {
                      body = Text(
                        LocalizationsUtil.of(context)
                            .translate("no_more_information"),
                        style: AppFonts.regular14,
                      );
                    }

                    return SizedBox(height: 80, child: Center(child: body));
                  },
                ),
                child: AnimationLimiter(
                    child: GridView.count(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        childAspectRatio: 1.0,
                        mainAxisSpacing: 15,
                        crossAxisSpacing: 15,
                        crossAxisCount: 2,
                        children: List.generate(couponList.count!, (int index) {
                          return AnimationConfiguration.staggeredGrid(
                            columnCount: 2,
                            position: index,
                            duration: const Duration(milliseconds: 200),
                            child: SlideAnimation(
                              verticalOffset: 50.0,
                              duration: const Duration(milliseconds: 300),
                              child: SlideAnimation(
                                child: CardPromotionWidget(
                                    couponModel: couponList.data![index]),
                              ),
                            ),
                          );
                        }))),
              );
            }));
  }
}
