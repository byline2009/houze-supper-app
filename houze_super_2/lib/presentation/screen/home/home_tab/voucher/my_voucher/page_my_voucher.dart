import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:houze_super/middle/model/voucher_model.dart';
import 'package:houze_super/presentation/common_widgets/widget_no_data_display.dart';
import 'package:houze_super/presentation/custom_ui/fading_appbar/fading_stretchy.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/presentation/screen/home/home_tab/nearby_service/widget_category.dart';
import 'package:houze_super/presentation/screen/home/home_tab/voucher/qrcode/sc_qrcode_detail.dart';

class MyVoucherPage extends StatefulWidget {
  final int? status;

  const MyVoucherPage({Key? key, this.status}) : super(key: key);

  @override
  State<StatefulWidget> createState() => MyVoucherPageState();
}

class MyVoucherPageState extends State<MyVoucherPage> {
  late Size _screenSize;
  var padding;
  final _myPromotionBloc = MyVoucherBloc(PrivatePromotionList(data: []));
  final _refreshController = RefreshController();

  @override
  void initState() {
    super.initState();

    _myPromotionBloc.add(MyPromotionLoadList(
        page: 1, status: widget.status == 0 ? true : false));
  }

  @override
  Widget build(BuildContext context) {
    this._screenSize = MediaQuery.of(context).size;
    this.padding = this._screenSize.width * 5 / 100;
    double _splitPosition = this._screenSize.width * 25 / 100;

    return BlocProvider<MyVoucherBloc>(
      create: (_) => _myPromotionBloc,
      child: BlocBuilder<MyVoucherBloc, PrivatePromotionList>(builder: (
        BuildContext context,
        PrivatePromotionList? promotionList,
      ) {
        if (promotionList == null) {
          return Container(
            color: Colors.white,
            child: Text(
              LocalizationsUtil.of(context).translate('currently_empty'),
            ),
          );
        }

        if (!_myPromotionBloc.isNext && promotionList.count == 0) {
          return WidgetVoucherEmpty(padding: 100);
        }
        if (_myPromotionBloc.isNext && promotionList.count == 0) {
          return Center(child: CupertinoActivityIndicator());
        }

        _refreshController.loadComplete();
        _refreshController.refreshCompleted();

        return SmartRefresher(
            enablePullDown: true,
            enablePullUp: true,
            header: MaterialClassicHeader(),
            controller: _refreshController,
            onRefresh: () {
              _myPromotionBloc.add(MyPromotionLoadList(
                  page: -1, status: widget.status == 0 ? true : false));
            },
            onLoading: () {
              if (mounted) {
                _myPromotionBloc.add(
                  MyPromotionLoadList(
                      status: widget.status == 0 ? true : false),
                );
              }
            },
            footer:
                CustomFooter(builder: (BuildContext context, LoadStatus mode) {
              Widget body;
              if (promotionList.count == 0) {
                mode = LoadStatus.noMore;
              }

              if (mode == LoadStatus.loading) {
                body = CupertinoActivityIndicator();
              } else {
                body = NoDataBottomLine(parentContext: context);
              }

              return SizedBox(height: 80, child: Center(child: body));
            }),
            child: AnimatedOpacity(
                duration: duration,
                opacity: 1.0,
                child: ListView.builder(
                    itemExtent: 130,
                    padding: const EdgeInsets.only(top: 20),
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: promotionList.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        key: Key(promotionList.data![index].id!),
                        child: VoucherItem(
                          model: promotionList.data![index],
                          splitPosition: _splitPosition,
                          status: widget.status!,
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                      );
                    })));
      }),
    );
  }
}

class VoucherItem extends StatelessWidget {
  final int status;
  final PrivatePromotionModel model;
  final double splitPosition;
  const VoucherItem(
      {required this.status, required this.model, required this.splitPosition});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          AppRouter.pushDialog(context, AppRouter.QRCODE_VOUCHER_SCREEN,
              QRCodeDetailScreenArgument(id: model.id!));
        },
        child: TicketCard(
            decoration: TicketDecoration(shadow: [
              BoxShadow(
                offset: Offset(0.0, 0.0),
                blurRadius: 10.0,
                spreadRadius: 1.0,
                color: Colors.grey[200]!,
              )
            ]),
            lineFromPosition: splitPosition,
            lineRadius: 10,
            lineColor: Color(0xff838383).withOpacity(0.4),
            child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  color: Colors.white,
                ),
                height: 110,
                child: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                  SizedBox(
                    width: splitPosition,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: this.category(model.coupon!.shops![0].type!),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                      child: Container(
                    margin: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(model.coupon!.shops![0].name!,
                            style: TextStyle(
                              fontSize: 13,
                              fontFamily: AppFont.font_family_display,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.26,
                              color: AppColor.purple_6001d2,
                            )),
                        TextLimitWidget(model.coupon!.title!,
                            maxLines: 2, style: AppFont.BOLD_BLACK_15),
                        SizedBox(height: 4),
                        status == 1
                            ? itemStatus(context)
                            : Row(
                                children: <Widget>[
                                  Text(
                                      LocalizationsUtil.of(context)
                                          .translate('end_with_colon'),
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontFamily: AppFont.font_family_display,
                                        color: AppColor.gray_838383,
                                      )),
                                  SizedBox(width: 3),
                                  Text(
                                      DateUtil.format('HH:mm - dd/MM/yyyy',
                                          model.coupon!.endDate!),
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontFamily:
                                              AppFont.font_family_display,
                                          color: AppColor.green_00aa7d,
                                          fontWeight: FontWeight.w600)),
                                ],
                              ),
                      ],
                    ),
                  ))
                ]))));
  }

  Widget category(int id) {
    final category = CategoryWidget.getCategory(id);
    return Container(
      decoration: ShapeDecoration(
        shape: CircleBorder(),
        color: AppColor.gray_f5f5f5,
      ),
      child: SizedBox(child: category.icon, width: 32, height: 32),
      padding: const EdgeInsets.all(15),
    );
  }

  Widget itemStatus(BuildContext context) {
    if (model.isUsed!) {
      return Container(
        child: Row(
          children: <Widget>[
            Text(LocalizationsUtil.of(context).translate('used'),
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: AppFont.font_family_display,
                  color: Color(0xff838383),
                )),
          ],
        ),
      );
    }

    if (model.coupon!.isExpired!) {
      return Row(
        children: <Widget>[
          Text(LocalizationsUtil.of(context).translate('expired'),
              style: TextStyle(
                fontSize: 12,
                fontFamily: AppFont.font_family_display,
                color: Color(0xff838383),
              )),
        ],
      );
    }

    return SizedBox.shrink();
  }
}
