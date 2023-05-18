import 'package:flutter/material.dart';
import 'package:houze_super/middle/model/voucher_model.dart';
import 'package:houze_super/presentation/custom_ui/fading_appbar/fading_stretchy.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/utils/index.dart';
import 'package:qr_flutter/qr_flutter.dart';

class WidgetQRCodeHeader extends StatelessWidget {
  final PrivatePromotionModel data;
  const WidgetQRCodeHeader({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
              bottom: BorderSide(
                  color: AppColor.gray_f5f5f5,
                  width: 10,
                  style: BorderStyle.solid)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 20),
            _buildQRCodeCard(context),
            SizedBox(height: 23),
            Text(
                LocalizationsUtil.of(context)
                    .translate('give_your_qr_code_to_staff'),
                style: AppFont.SEMIBOLD_GRAY_F5F5F5_13),
            SizedBox(height: 30)
          ],
        ));
  }

  Widget _buildQRCodeCard(BuildContext context) {
    double size = 180.0;

    String status = "";
    if (data.isUsed!) {
      status = "used";
    }

    if (data.coupon!.isExpired!) {
      status = "expired";
    }

    return (data.isUsed! || data.coupon!.isExpired!)
        ? Stack(
            children: <Widget>[
              AnimatedOpacity(
                  duration: duration,
                  opacity: 0.2,
                  child: QrImage(
                    data: "${data.id},${data.code}",
                    version: QrVersions.auto,
                    size: size,
                    gapless: true,
                  )),
              Positioned.fill(
                child: Align(
                    alignment: Alignment.center,
                    child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                                LocalizationsUtil.of(context).translate(status),
                                textAlign: TextAlign.center,
                                style: AppFonts.bold18)
                          ],
                        ),
                        width: size,
                        height: 40,
                        color: AppColor.gray_f5f5f5)),
              )
            ],
          )
        : QrImage(
            data: "${data.id},${data.code}",
            version: QrVersions.auto,
            size: size,
            gapless: true,
          );
  }
}
