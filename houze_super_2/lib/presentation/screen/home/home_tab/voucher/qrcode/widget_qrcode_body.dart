import 'package:flutter/material.dart';
import 'package:houze_super/middle/model/voucher_model.dart';
import 'package:houze_super/presentation/common_widgets/widget_cached_image.dart';
import 'package:houze_super/presentation/index.dart';

const String qrCodeKey = 'qrCodeKey';

class WidgetQRCodeBody extends StatelessWidget {
  final PrivatePromotionModel data;
  const WidgetQRCodeBody({required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
                bottom: BorderSide(
                    color: AppColor.gray_f5f5f5,
                    width: 1,
                    style: BorderStyle.solid)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(data.coupon!.shops![0].name!, style: AppFonts.bold16),
                  SizedBox(height: 5),
                  Text(data.coupon!.shops![0].address!,
                      style: AppFont.SEMIBOLD_GRAY_838383_12),
                ],
              )),
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                child: Stack(
                  clipBehavior: Clip.hardEdge,
                  children: <Widget>[
                    CachedImageWidget(
                      cacheKey: qrCodeKey,
                      imgUrl: data.coupon!.shops![0].image!.imageThumb!,
                      width: 60.0,
                      height: 60.0,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
            child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                      bottom: BorderSide(
                          color: AppColor.gray_f5f5f5,
                          width: 2,
                          style: BorderStyle.solid)),
                ),
                child: Column(
                  children: <Widget>[
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          TextLimitWidget(data.coupon!.title!,
                              maxLines: 2, style: AppFont.BOLD_BLACK_24)
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
                                'HH:mm - dd/MM/yyyy', data.coupon!.startDate!),
                            style: AppFont.BOLD_BLACK_15)
                      ],
                    ),
                    SizedBox(
                      height: 12.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                            LocalizationsUtil.of(context)
                                .translate('end_at_with_colon'),
                            style: AppFonts.regular15
                                .copyWith(
                                  color: Color(0xff838383),
                                )
                                .copyWith(wordSpacing: 1.4)),
                        Text(
                            DateUtil.format(
                                'HH:mm - dd/MM/yyyy', data.coupon!.endDate!),
                            style: AppFont.BOLD_BLACK_15)
                      ],
                    ),
                    SizedBox(height: 20),
                  ],
                ))),
        Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
            child: Text(
                LocalizationsUtil.of(context).translate("voucher_information"),
                style: AppFonts.bold18)),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 5),
          child: Text(
            (data.coupon?.description != null) ? data.coupon!.description! : "",
            style: AppFonts.regular15.copyWith(
              color: Color(0xff838383),
            ),
          ),
        ),
        SizedBox(height: 30),
      ],
    );
  }
}
