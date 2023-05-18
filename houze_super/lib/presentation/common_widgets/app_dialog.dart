import 'package:flutter/material.dart';
import 'package:houze_super/app/bloc/index.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/utils/index.dart';
import 'package:houze_super/utils/localizations_util.dart';

typedef SubmitFunc = Future Function(BuildContext context);

class AppDialog {
  static void showAlertDialog(
      BuildContext context, String title, String message,
      {SubmitFunc submit}) {
    showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: title != null
                ? Text(
                    LocalizationsUtil.of(context).translate(title),
                    style: AppFonts.medium14.copyWith(color: Colors.black),
                  )
                : const SizedBox.shrink(),
            content: Text(
              LocalizationsUtil.of(context).translate(message) ?? message,
              style: AppFonts.medium16.copyWith(letterSpacing: 0.26),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  LocalizationsUtil.of(context).translate('ok'),
                  style: AppFonts.semibold16.copyWith(color: Color(0xff7A1DFF)),
                ),
                onPressed: () async {
                  Navigator.of(context).pop();
                  if (submit != null) {
                    await submit(context);
                  }
                },
              ),
            ],
          );
        });
  }

  static void showAlertDialogForPayment(
      BuildContext context, String title, String message,
      {SubmitFunc submit}) {
    showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
              title: title != null
                  ? Text(
                      LocalizationsUtil.of(context).translate(title),
                      style: AppFonts.medium14.copyWith(color: Colors.black),
                    )
                  : const SizedBox.shrink(),
              content: Text(
                LocalizationsUtil.of(context).translate(message),
                style: AppFonts.medium16.copyWith(letterSpacing: 0.26),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text(
                      LocalizationsUtil.of(context)
                          .translate("back_to_payment_screen"),
                      style: AppFonts.semibold16
                          .copyWith(color: Color(0xff7A1DFF))),
                  onPressed: () async {
                    // Navigator.pushReplacement(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => MainScreen(currentTab: 2)));
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    (BlocRegistry.get("overlay_bloc") as OverlayBloc)
                        .pageController
                        .jumpToPage(AppTabbar.payment);
                    if (submit != null) {
                      await submit(context);
                    }
                  },
                ),
              ],
            ),
          );
        });
  }

  static Future<String> showContentDialog(
      {@required BuildContext context,
      @required Widget child,
      String title,
      bool closeShow = true,
      bool barrierDismissible = true}) async {
    return await showDialog<String>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: AlertDialog(
              insetPadding:const EdgeInsets.symmetric(horizontal: 20),
              actionsPadding: const EdgeInsets.all(0),
              buttonPadding: const EdgeInsets.all(0),
              backgroundColor: Colors.white,
              contentPadding: const EdgeInsets.all(0),
              titlePadding: const EdgeInsets.all(0),
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
                  : const SizedBox.shrink(),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              content: child),
        );
      },
    );
  }

  static void showSimpleDialog(BuildContext context, List<Widget> widgets,
      {String title, bool barrierDismissible = true}) async {
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
