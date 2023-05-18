import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:houze_super/middle/model/coupon_model.dart';
import 'package:houze_super/middle/model/shop_model.dart';
import 'package:houze_super/middle/repo/merchant_repo.dart';
import 'package:houze_super/presentation/common_widgets/button_widget.dart';
import 'package:houze_super/presentation/common_widgets/widget_button.dart';
import 'package:houze_super/presentation/common_widgets/widget_cached_image.dart';
import 'package:houze_super/presentation/custom_ui/fading_appbar/fading_appbar.dart';
import 'package:houze_super/presentation/custom_ui/fading_appbar/fading_stretchy.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/presentation/screen/base/base_widget.dart';
import 'package:houze_super/presentation/screen/home/home_tab/nearby_service/detail/sc_places_around_detail.dart';

import 'package:houze_super/utils/custom_exceptions.dart';

import '../../../../base/route_aware_state.dart';

const String promotionDetailImageKey = 'promotionDetailImageKey';

class MyVoucherDetailScreenArgument {
  final CouponModel? couponModel;
  MyVoucherDetailScreenArgument({this.couponModel});
}

class MyVoucherDetailScreen extends StatefulWidget {
  final MyVoucherDetailScreenArgument args;

  MyVoucherDetailScreen({Key? key, required this.args}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MyVoucherDetailScreenState();
}

class _MyVoucherDetailScreenState extends RouteAwareState<MyVoucherDetailScreen> {
  final _promotionBloc = BaseBloc();
  final _merchantRepository = MerchantRepository();
  late CouponModel _couponModel;
  late Size _screenSize;
  var padding;
  ProgressHUD progressToolkit = Progress.instanceCreateWithNormal();

  @override
  void initState() {
    super.initState();
    _couponModel = widget.args.couponModel!;
    _promotionBloc.resultFunc = (dynamic args) async {
      return _merchantRepository.getCouponById(_couponModel.id!);
    };
  }

  @override
  void dispose() {
    _promotionBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    this._screenSize = MediaQuery.of(context).size;
    this.padding = this._screenSize.width * 5 / 100;
    double _heightImage = _screenSize.height * 30 / 100;
    return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(children: <Widget>[
          BlocProvider<BaseBloc>(
            create: (_) => _promotionBloc,
            child: BlocBuilder<BaseBloc, BaseState>(
                builder: (BuildContext context, BaseState promotionState) {
              if (promotionState is BaseInitial) {
                _promotionBloc.add(BaseLoadList(params: {}));
              }

              if (promotionState is BaseFailure) {
                if (promotionState.error.error is NoDataException)
                  return Scaffold(
                    appBar: AppBar(
                      centerTitle: true,
                      leading: IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                    body: SomethingWentWrong(true),
                  );
                else
                  return Scaffold(
                    appBar: AppBar(
                      centerTitle: true,
                      leading: IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                    body: SomethingWentWrong(),
                  );
              }

              if (promotionState is BaseListSuccessful) {
                final promotionDetail = promotionState.result as CouponModel;
                final introElement = promotionDetail.images!.length != 0
                    ? CachedImageWidget(
                        cacheKey: promotionDetailImageKey,
                        imgUrl: promotionDetail.images![0].image!,
                      )
                    : Icon(Icons.category);

                return Column(children: <Widget>[
                  Expanded(
                      child: FadingStretchy(
                          headerHeight: _heightImage,
                          blurContent: false,
                          header: introElement,
                          backgroundColor: Colors.white,
                          appbarHandler: (double opacity) {
                            return FadingAppbar(
                                backgroundColor:
                                    Colors.white.withOpacity(opacity),
                                leading: opacity < 0.5
                                    ? WidgetButton.backCircleButton(context)
                                    : IconButton(
                                        icon: Icon(
                                          Icons.arrow_back_ios,
                                          color: Colors.black,
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                title: Flexible(
                                    child: AnimatedOpacity(
                                  duration: duration,
                                  opacity: opacity,
                                  child: Text(
                                      promotionDetail.shops!.first.name!,
                                      textAlign: TextAlign.left,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500)),
                                )));
                          },
                          highlightHeader: Container(
                              height: 60,
                              width: double.minPositive,
                              padding: EdgeInsets.symmetric(
                                  horizontal: this.padding),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                        child: Text(
                                            promotionDetail.shops![0].name!,
                                            style: AppFont.BOLD_BLACK_24
                                                .copyWith(
                                                    color: Colors.white,
                                                    letterSpacing: 0.38)),
                                        width: _screenSize.width - 160,
                                        padding: EdgeInsets.only(bottom: 6.0)),
                                    GestureDetector(
                                        onTap: () {
                                          if (promotionDetail.shops![0].id !=
                                              null)
                                            AppRouter.push(
                                                context,
                                                AppRouter.PLACES_DETAIL_PAGE,
                                                PlacesDetailScreenArgument(
                                                    shop: ShopModel(
                                                        id: promotionDetail
                                                            .shops![0].id)));
                                        },
                                        child: Container(
                                          height: 28,
                                          decoration: BoxDecoration(
                                              gradient: AppColor.gradient,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(50.0))),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 15, vertical: 0),
                                          child: Center(
                                              child: Text(
                                                  LocalizationsUtil.of(context)
                                                      .translate(
                                                    'information',
                                                  ),
                                                  style: AppFont
                                                      .SEMIBOLD_BLACK_13
                                                      .copyWith(
                                                          color:
                                                              Colors.white))),
                                        ))
                                  ]),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    colors: <Color>[
                                      Colors.black12.withOpacity(0),
                                      Colors.black.withOpacity(0.5)
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter),
                              )),
                          highlightHeaderAlignment:
                              HighlightHeaderAlignment.bottom,
                          headerActionsSize: 0,
                          body: Container(
                              color: Colors.white,
                              child: ListView(
                                  padding: const EdgeInsets.only(top: 0),
                                  shrinkWrap: true,
                                  physics: const BouncingScrollPhysics(),
                                  children: <Widget>[
                                    Container(
                                        height: 10,
                                        color: AppColor.gray_f5f5f5),
                                    titlePromotion(promotionDetail),
                                    contentPromotion(promotionDetail),
                                  ])))),
                  SizedBox(
                      child: BaseWidget.containerBodyTopShadow(Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: padding, vertical: 20),
                          child: SafeArea(
                              top: false,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  ButtonWidget(
                                      defaultHintText:
                                          LocalizationsUtil.of(context)
                                              .translate('get_a_voucher'),
                                      isActive: (!promotionDetail.isPicked! &&
                                          !promotionDetail.isExpired!),
                                      callback: () async {
                                        progressToolkit.state.show();
                                        try {
                                          final rs = await _merchantRepository
                                              .createCoupon(
                                                  promotionDetail.id!);
                                          if (rs.id != "") {
                                            Navigator.of(context).pop();
                                            AppRouter.pushDialogNoParams(
                                              context,
                                              AppRouter.MY_VOUCHER_SCREEN,
                                            );
                                          }
                                        } catch (e) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              padding: EdgeInsets.all(20),
                                              duration: Duration(seconds: 5),
                                              content: Text(
                                                LocalizationsUtil.of(context)
                                                    .translate(
                                                        "voucher_has_been_received"),
                                                style:
                                                    AppFonts.regular16.copyWith(
                                                  color: Colors.white,
                                                ),
                                              ),
                                              backgroundColor: Colors.black,
                                            ),
                                          );
                                        } finally {
                                          progressToolkit.state.dismiss();
                                        }
                                      })
                                ],
                              )))),
                      width: _screenSize.width)
                ]);
              }

              return Container(
                  child: SafeArea(
                      child: Column(
                    children: [
                      SizedBox(
                        child: CupertinoActivityIndicator(),
                        height: _heightImage,
                      ),
                      CardListSkeleton(
                        shrinkWrap: true,
                        length: 2,
                        config: SkeletonConfig(
                          theme: SkeletonTheme.Light,
                          isShowAvatar: false,
                          isCircleAvatar: false,
                          bottomLinesCount: 2,
                        ),
                      ),
                    ],
                  )),
                  color: Colors.white);
            }),
          ),
          progressToolkit
        ]));
  }

  Widget titlePromotion(CouponModel promotionDetail) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: padding),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
            bottom: BorderSide(
                color: AppColor.gray_f5f5f5,
                width: 1,
                style: BorderStyle.solid)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                TextLimitWidget(promotionDetail.title!,
                    maxLines: 10,
                    style: TextStyle(
                        fontFamily: AppFont.font_family_display,
                        fontSize: 22,
                        color: Color(0xff333333),
                        fontWeight: FontWeight.bold))
              ]),
          SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                  LocalizationsUtil.of(context)
                      .translate('start_at_with_colon'),
                  style: AppFonts.regular15.copyWith(
                    color: Color(0xff838383),
                  )),
              Text(
                  DateUtil.format(
                      'HH:mm - dd/MM/yyyy', promotionDetail.startDate!),
                  style: AppFont.BOLD_BLACK_15)
            ],
          ),
          SizedBox(height: 12.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(LocalizationsUtil.of(context).translate('end_at_with_colon'),
                  style: AppFonts.regular15
                      .copyWith(
                        color: Color(0xff838383),
                      )
                      .copyWith(wordSpacing: 1.4)),
              Text(
                  DateUtil.format(
                      'HH:mm - dd/MM/yyyy', promotionDetail.endDate!),
                  style: AppFont.BOLD_BLACK_15)
            ],
          )
        ],
      ),
    );
  }

  Widget contentPromotion(CouponModel promotionDetail) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: this.padding, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                      LocalizationsUtil.of(context)
                          .translate("voucher_information"),
                      style: AppFonts.bold18)
                ]),
            SizedBox(height: 5),
            Text(
                (promotionDetail.description != null)
                    ? promotionDetail.description!
                    : "",
                style: AppFonts.regular15.copyWith(
                  color: Color(0xff838383),
                ))
          ],
        ),
      ),
    );
  }
}
