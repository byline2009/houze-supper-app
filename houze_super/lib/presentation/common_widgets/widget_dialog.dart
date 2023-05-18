import 'package:flutter/material.dart';
import 'package:houze_super/presentation/index.dart';

typedef SubmitFunc = Future Function(BuildContext context);

class WidgetDialog {
  static Future<String> show(
    BuildContext context,
    double circular,
    List<Widget> widgets, {
    String title,
    bool closeShow = true,
    bool barrierDismissible = true,
  }) async {
    return await showDialog<String>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) {
        return AlertDialog(
            contentPadding: const EdgeInsets.all(0),
            titlePadding: const EdgeInsets.all(0),
            title: closeShow == true
                ? Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      icon: Icon(
                        Icons.close,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  )
                : const SizedBox.shrink(),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(circular))),
            content: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: widgets)));
      },
    );
  }

  static Future<String> showContentDialog(
      BuildContext context, List<Widget> widgets,
      {String title,
      bool closeShow = true,
      bool barrierDismissible = true}) async {
    return await showDialog<String>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) {
        return AlertDialog(
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
            content: Container(
                padding: const EdgeInsets.all(0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: widgets)));
      },
    );
  }

  static void showAlert(BuildContext context, String title, String message,
      {SubmitFunc submit}) {
    showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: title != null
                ? Text(LocalizationsUtil.of(context).translate(title))
                : const SizedBox.shrink(),
            content: Text(LocalizationsUtil.of(context).translate(message)),
            actions: <Widget>[
              FlatButton(
                padding: const EdgeInsets.all(0),
                child: Text(LocalizationsUtil.of(context).translate('ok')),
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
}
