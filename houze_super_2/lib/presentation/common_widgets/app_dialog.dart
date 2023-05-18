import 'package:flutter/material.dart';
import 'package:houze_super/app/blocs/index.dart';
import 'package:houze_super/utils/index.dart';

typedef void CallBackHandler();

class AppDialog {
  static void showAlertDialog(
      BuildContext context, String? title, String message,
      {CallBackHandler? submit}) {
    showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: title != null
                ? Text(
                    LocalizationsUtil.of(context).translate(title),
                    style: AppFonts.medium14,
                  )
                : Center(),
            content: Text(
              LocalizationsUtil.of(context).translate(message),
              style: AppFonts.medium16,
            ),
            actions: <Widget>[
              TextButton(
                child: Text(
                  LocalizationsUtil.of(context).translate('ok'),
                  style: AppFonts.semibold16.copyWith(
                    color: Color(0xff7a1dff),
                  ),
                ),
                onPressed: () {
                  if (submit != null) {
                    submit();
                  } else {
                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
          );
        });
  }

  static void showAlertDialogForPayment(
      BuildContext context, String title, String message,
      {CallBackHandler? submit}) {
    showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
              title: Text(
                LocalizationsUtil.of(context).translate(title),
                style: AppFonts.medium14,
              ),
              content: Text(
                LocalizationsUtil.of(context).translate(message),
                style: AppFonts.medium16,
              ),
              actions: <Widget>[
                TextButton(
                  child: Text(
                    LocalizationsUtil.of(context)
                        .translate("back_to_payment_screen"),
                    style: AppFonts.semibold16.copyWith(
                      color: Color(0xff7a1dff),
                    ),
                  ),
                  onPressed: () async {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    (BlocRegistry.get("overlay_bloc") as OverlayBloc)
                        .pageController
                        .jumpToPage(AppTabbar.payment);
                    if (submit != null) {
                      submit();
                    }
                  },
                ),
              ],
            ),
          );
        });
  }

  static Future<String?> showContentDialog(
      {required BuildContext context,
      required Widget child,
      String? title,
      bool closeShow = true,
      bool barrierDismissible = true}) async {
    return await showDialog<String>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) {
        return AlertDialog(
            insetPadding: EdgeInsets.symmetric(horizontal: 20),
            actionsPadding: EdgeInsets.zero,
            buttonPadding: EdgeInsets.zero,
            backgroundColor: Colors.white,
            // backgroundColor: Colors.white,
            contentPadding: EdgeInsets.zero,
            titlePadding: EdgeInsets.zero,
            title: closeShow == true
                ? Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      icon: Icon(
                        Icons.close,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ))
                : SizedBox.shrink(),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            content: child);
      },
    );
  }

  static void showSimpleDialog(BuildContext context, List<Widget> widgets,
      {String? title, bool barrierDismissible = true}) async {
    showDialog<Null>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) {
        if (title != null) {
          return SimpleDialog(
            title: Text(
              LocalizationsUtil.of(context).translate(title),
            ),
            children: widgets,
          );
        }

        return SimpleDialog(
          children: widgets,
        );
      },
    );
  }
}
