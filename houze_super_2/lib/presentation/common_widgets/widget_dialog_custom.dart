import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:houze_super/presentation/common_widgets/widget_button_custom.dart';

import 'package:houze_super/utils/index.dart';

class DialogCustom {
  static Future<void> showSuccessDialog({
    required BuildContext context,
    String? svgPath,
    required String title,
    required String content,
    String? buttonText,
    Function? onPressed,
  }) async {
    return await showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 24.0,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              10.0,
            ),
          ),
          content: SingleChildScrollView(
            padding: EdgeInsets.zero,
            child: ListBody(
              children: <Widget>[
                svgPath != null
                    ? SvgPicture.asset(svgPath)
                    : const SizedBox.shrink(),
                const SizedBox(height: 16.0),
                Text(
                  LocalizationsUtil.of(context).translate(title),
                  style: AppFonts.bold18,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20.0),
                Text(
                  LocalizationsUtil.of(context).translate(content),
                  style: AppFonts.regular15.copyWith(
                    color: Color(
                      0xff808080,
                    ),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40.0),
                FlatButtonCustom(
                  buttonText:
                      LocalizationsUtil.of(context).translate(buttonText),
                  onPressed: () {
                    if (onPressed != null) onPressed();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static Future<void> show({
    required BuildContext context,
    required String title,
    required String content,
    String? buttonCancel,
    String? buttonText,
    Function? callback,
  }) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding:
              const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  LocalizationsUtil.of(context).translate(title),
                  style: AppFonts.bold18,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20.0),
                Text(
                  LocalizationsUtil.of(context).translate(content),
                  style: AppFonts.regular15.copyWith(color: Color(0xff808080)),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      fit: FlexFit.tight,
                      child: FlatButtonCustom(
                        buttonText: buttonCancel,
                        onPressed: () {
                          if (buttonCancel != null) Navigator.of(context).pop();
                        },
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Flexible(
                      fit: FlexFit.tight,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(5.0),
                          border: Border.all(
                            color: Color(
                              0xFFfb5252,
                            ),
                          ),
                        ),
                        child: SizedBox(
                          height: 48.0,
                          child: Align(
                            alignment: Alignment.center,
                            child: TextButton(
                              child: Text(
                                LocalizationsUtil.of(context).translate(
                                  buttonText,
                                ),
                                style: AppFonts.bold16.copyWith(
                                  color: Color(
                                    0xFFc50000,
                                  ),
                                ),
                              ),
                              onPressed: () {
                                if (callback != null) callback();
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static Future<void> showErrorDialog({
    required BuildContext context,
    required String title,
    required String errMsg,
    String buttonText = 'ok',
    Function? callback,
  }) async {
    return await showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding:
              const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  LocalizationsUtil.of(context).translate(title),
                  style: AppFonts.bold18,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20.0),
                Text(
                  LocalizationsUtil.of(context).translate(errMsg),
                  style: AppFonts.regular15.copyWith(color: Color(0xff808080)),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40.0),
                FlatButtonCustom(
                  buttonText: buttonText,
                  onPressed: () {
                    if (callback != null) {
                      callback();
                    } else {
                      Navigator.pop(context);
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static Future<void> showAlertDialog({
    required BuildContext context,
    required String title,
    required String content,
    required String buttonText,
    required Function onPressed,
    String buttonCancel = 'back',
  }) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            LocalizationsUtil.of(context).translate(title),
            textAlign: TextAlign.center,
          ),
          titleTextStyle: AppFonts.bold18,
          // insetPadding:
          //     const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
          contentPadding: const EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 20.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text(
                  LocalizationsUtil.of(context).translate(content),
                  style: AppFonts.regular15.copyWith(
                    color: Color(
                      0xff808080,
                    ),
                  ),
                  textAlign: TextAlign.center,
                ),
                Container(
                  margin: EdgeInsets.only(top: 40.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        fit: FlexFit.tight,
                        child: FlatButtonCustom(
                          buttonText: LocalizationsUtil.of(context)
                              .translate(buttonCancel),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                      SizedBox(width: 16.0),
                      Flexible(
                        fit: FlexFit.tight,
                        child: SizedBox(
                          height: 48.0,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.all(0),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4.0),
                                  side: BorderSide(
                                      color: const Color(0xFFfb5252))),
                            ),
                            child: Text(
                              LocalizationsUtil.of(context)
                                  .translate(buttonText),
                              style: AppFont.BOLD.copyWith(
                                fontSize: 16,
                                color: Color(0xFFc50000),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            onPressed: () {
                              onPressed();
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  static Future<void> showRunFinishDialog({
    required BuildContext context,
    required String distance,
    required double compare,
    required String runTime,
  }) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 20.0),
          contentPadding:
              EdgeInsets.symmetric(horizontal: 20.0).copyWith(bottom: 20.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Container(
                  height: 130.0,
                  margin: EdgeInsets.only(bottom: 6.0),
                  child: Stack(
                    children: [
                      SvgPicture.asset('assets/svg/community/bg-graphics.svg'),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: SvgPicture.asset(
                            'assets/svg/community/fire-cracker.svg'),
                      ),
                    ],
                  ),
                ),
                Text(
                  LocalizationsUtil.of(context)
                      .translate('great_you_have_finished_run'),
                  style: AppFonts.bold18,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 32.0),
                Text(
                  LocalizationsUtil.of(context).translate('distance'),
                  style: AppFont.SEMIBOLD_BLACK_13,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 4.0),
                Text(
                  distance + " km",
                  style: AppFont.BOLD_BLACK_27,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 4.0),
                Text(
                  LocalizationsUtil.of(context)
                      .translate('compare_with_last_time'),
                  style: AppFonts.semibold13.copyWith(
                    color: Color(
                      0xff838383,
                    ),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 4.0),
                Text(
                  "${compare >= 0.0 ? '+' : '-'} ${compare.abs().toStringAsFixed(2)} km",
                  style: compare >= 0.0
                      ? AppFont.BOLD_GREEN_00aa7d_18
                      : AppFont.BOLD_RED_C50000_18,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 40.0),
                Text(
                  LocalizationsUtil.of(context).translate('run_time'),
                  style: AppFont.SEMIBOLD_BLACK_13,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 4.0),
                Text(
                  runTime,
                  style: AppFont.BOLD_BLACK_27,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 48.0),
                FlatButtonCustom(
                  buttonText: LocalizationsUtil.of(context)
                      .translate('back_to_main_page'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
