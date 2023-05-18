import 'package:flutter/material.dart';
import 'package:houze_super/presentation/common_widgets/stateless/widget_cached_image.dart';
import 'package:houze_super/utils/constants/constants.dart';
import 'package:houze_super/utils/index.dart';
import 'package:houze_super/utils/localizations_util.dart';

const double horizontalPadding = 20.0;

typedef void CallBackHandler();

const String propertyListTileKey = 'propertyListTileKey';

const String avatarKey = 'avatarKey';

const String avatarHomeKey = 'avatarHomeKey';

class BaseWidget {
  static Widget makeContentWrapper({Widget child}) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(
        left: horizontalPadding,
        right: horizontalPadding,
        top: 15,
        bottom: 30,
      ),
      child: child,
    );
  }

  static Widget note(Widget text, {Color color}) {
    return Container(
      width: double.infinity,
      padding: new EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: color == null ? Color(0xfff5f7f8) : color,
        borderRadius: new BorderRadius.all(Radius.circular(5.0)),
      ),
      child: text,
    );
  }

  static BoxDecoration decorationBorderFull = BoxDecoration(
    border: Border.all(
      color: Colors.black,
      width: 1,
      style: BorderStyle.solid,
    ),
    borderRadius: BorderRadius.all(
      Radius.circular(
        4.0,
      ),
    ),
  );

  static BoxDecoration decorationStickIntro = BoxDecoration(
    gradient: LinearGradient(
      colors: <Color>[
        Colors.black12.withOpacity(0),
        Colors.black.withOpacity(0.5),
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ),
  );

  static BoxDecoration decorationDividerGray = BoxDecoration(
    border: Border(
      bottom: BorderSide(
        color: Color(0xfff5f5f5),
        width: 5,
        style: BorderStyle.solid,
      ),
    ),
  );
  static BoxDecoration dividerBottom({double height, Color color}) {
    return BoxDecoration(
      border: Border(
          bottom: BorderSide(
              color: color ?? Color(0xfff5f5f5),
              width: height,
              style: BorderStyle.solid)),
    );
  }

  static BoxDecoration dividerTop({double height, Color color}) {
    return BoxDecoration(
      color: Colors.white,
      border: Border(
          top: BorderSide(
              color: color ?? Color(0xfff5f5f5),
              width: height ?? 1,
              style: BorderStyle.solid)),
    );
  }

  static Widget listTagWidget(String type, double distance) {
    String text = "";
    if (type != null) {
      text = type;
    }

    if (distance != null) {
      text =
          "${distance > 1000 ? (distance / 1000).floor() : distance.floor()} ${distance > 1000 ? "km" : "m"}";
    }

    return text != ""
        ? Padding(
            padding: EdgeInsets.only(right: 10),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 2, horizontal: 10),
              decoration: BoxDecoration(
                  color: Color(0xfff5f5f5),
                  borderRadius: BorderRadius.all(Radius.circular(2.0))),
              child: Text(
                text,
                style: AppFonts.medium14.copyWith(color: Colors.black),
              ),
            ),
          )
        : const SizedBox.shrink();
  }

  static Widget icon404(Widget icon, Widget text) {
    return Padding(
        padding: const EdgeInsets.only(top: 60, bottom: 30),
        child: Center(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            icon,
            SizedBox(height: 15),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Center(child: text))
          ],
        )));
  }

  static Widget containerRounder(Widget widget) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xfff5f5f5),
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      child: widget,
    );
  }

  static Widget containerRounderRegular(Widget widget) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        border: Border.all(
          color: Color(0xfff5f5f5),
          width: 2.0,
        ),
      ),
      child: widget,
    );
  }

  static Widget propertyListTile(
      {String buildingImage,
      @required String apartmentTitle,
      @required String fee,
      double iconSize = 48,
      BuildContext context}) {
    return Row(
      children: <Widget>[
        if (buildingImage != null)
          Container(
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xfff2f2f2), width: 2.0),
                borderRadius: BorderRadius.all(Radius.circular(14.0)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
                child: Stack(
                  overflow: Overflow.clip,
                  children: <Widget>[
                    CachedImageWidget(
                      cacheKey: propertyListTileKey,
                      imgUrl: buildingImage,
                      width: iconSize,
                      height: iconSize,
                    )
                  ],
                ),
              )),
        if (buildingImage != null) SizedBox(width: 15),
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(apartmentTitle, style: AppFonts.bold15),
            SizedBox(height: 5),
            Text(
                LocalizationsUtil.of(context)
                    .translate('need_to_pay_with_colon'),
                style: AppFonts.regular13.copyWith(
                  color: Color(0xff838383),
                )),
            SizedBox(height: 5),
            Text('đ $fee',
                style: (fee == '0'
                    ? AppFonts.regular13.copyWith(
                        color: Color(0xff838383),
                      )
                    : AppFonts.semibold13.copyWith(color: Color(0xff6001d2)))),
          ],
        )),
        Icon(Icons.arrow_forward, color: Color(0xffd1d6de), size: 20.0)
      ],
    );
  }

  static Widget avatar({
    String imageUrl = '',
    String fullname = '',
    double size = 60.0,
  }) {
    double ratio = size / 2;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Color(0xffc4c4c4),
        borderRadius: BorderRadius.all(Radius.circular(ratio)),
        border: Border.all(
          color: Color(0xfff2f2f2),
          width: 1.0,
        ),
      ),
      child: StringUtil.isEmpty(imageUrl) && StringUtil.isEmpty(fullname)
          ? Center(
              child: Icon(
                Icons.person_outline,
              ),
            )
          : Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: Color(0xffc4c4c4),
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    ratio,
                  ),
                ),
                border: Border.all(
                  color: Color(0xfff2f2f2),
                  width: 1.0,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                  ratio,
                ),
                child: !StringUtil.isEmpty(imageUrl)
                    ? CachedImageWidget(
                        cacheKey: avatarHomeKey,
                        imgUrl: imageUrl,
                        width: 48.0,
                        height: 48.0,
                      )
                    : Center(
                        child: Text(
                          fullname[0].toUpperCase(),
                          style: AppFonts.bold.copyWith(
                            fontSize: ratio,
                            color: Colors.white,
                          ),
                        ),
                      ),
              ),
            ),
    );
  }

  static Widget makeRowData(String label, String value,
      {Color leadingColor, Color traillingColor}) {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(label,
              textAlign: TextAlign.left,
              style: AppFonts.regular
                  .copyWith(color: leadingColor ?? Color(0xff808080))),
          Text(
            value,
            textAlign: TextAlign.right,
            style: AppFonts.medium14
                .copyWith(color: Colors.black)
                .copyWith(color: traillingColor ?? Colors.black),
          )
        ],
      ),
    );
  }

  static Widget containerBody(Widget content, {double height}) {
    return Container(
        height: height ?? null,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
              bottom: BorderSide(
                  color: Color(0xfff5f5f5),
                  width: 5,
                  style: BorderStyle.solid)),
        ),
        child: content);
  }

  static Widget containerBodyTopShadow(Widget content, {double height}) {
    return Container(
        height: height ?? null,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Color(0xffd2d4d6),
              offset: Offset(0, 0.0),
              blurRadius: 12,
            )
          ],
          color: Colors.white,
        ),
        child: content);
  }

  static Widget boderBottom(Widget box) {
    return Container(
      decoration: BaseWidget.decorationDividerGray,
      child: box,
    );
  }

  static Widget paymentStatusTag(BuildContext context, int status) {
    switch (status) {
      case 0:
        return Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xffff9b00),
            borderRadius: new BorderRadius.all(Radius.circular(20.0)),
          ),
          child: Row(
            children: <Widget>[
              Icon(
                Icons.brightness_1,
                color: Colors.white,
                size: 7.0,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                LocalizationsUtil.of(context)
                    .translate('payment_status_pending'),
                style: AppFonts.medium16.copyWith(color: Colors.white),
              ),
            ],
          ),
        );
        break;
      case 1:
        return Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xff38d6ac),
            borderRadius: new BorderRadius.all(Radius.circular(20.0)),
          ),
          child: Row(
            children: <Widget>[
              Icon(
                Icons.brightness_1,
                color: Colors.white,
                size: 7.0,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                LocalizationsUtil.of(context)
                    .translate('payment_status_successful'),
                style: AppFonts.medium16.copyWith(color: Colors.white),
              ),
            ],
          ),
        );
        break;
      case 2:
        return Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xffff6666),
            borderRadius: new BorderRadius.all(Radius.circular(20.0)),
          ),
          child: Row(
            children: <Widget>[
              Icon(
                Icons.brightness_1,
                color: Colors.white,
                size: 7.0,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                LocalizationsUtil.of(context)
                    .translate('payment_status_failed'),
                style: AppFonts.medium16.copyWith(color: Colors.white),
              ),
            ],
          ),
        );
        break;
      case 3:
        return Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xffd0d0d0),
            borderRadius: new BorderRadius.all(Radius.circular(20.0)),
          ),
          child: Row(
            children: <Widget>[
              Icon(
                Icons.brightness_1,
                color: Colors.white,
                size: 7.0,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                LocalizationsUtil.of(context).translate('canceled'),
                style: AppFonts.medium16.copyWith(color: Colors.white),
              ),
            ],
          ),
        );
        break;
      default:
        return Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xffd0d0d0),
            borderRadius: new BorderRadius.all(Radius.circular(20.0)),
          ),
          child: Row(
            children: <Widget>[
              Icon(
                Icons.brightness_1,
                color: Colors.white,
                size: 7.0,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                LocalizationsUtil.of(context).translate('unknown'),
                style: AppFonts.medium16.copyWith(color: Colors.white),
              ),
            ],
          ),
        );
        break;
    }
  }
}
