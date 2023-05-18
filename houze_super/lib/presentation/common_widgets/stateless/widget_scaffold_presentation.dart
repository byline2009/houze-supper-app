import 'package:flutter/material.dart';
import 'package:houze_super/utils/index.dart';

class BaseScaffoldPresent extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget body;
  final Function onPressLeading;

  const BaseScaffoldPresent({
    @required this.title,
    this.subtitle,
    @required this.body,
    this.onPressLeading,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: Colors.white,
            centerTitle: true,
            title: Text(LocalizationsUtil.of(context).translate(title),
                style: AppFonts.medium16.copyWith(letterSpacing: 0.26)),
            elevation: 0.0,
            leading: IconButton(
              icon: Icon(
                Icons.close,
                color: Colors.black,
              ),
              onPressed: () {
                if (onPressLeading != null) {
                  onPressLeading();
                }
                Navigator.pop(context);
              },
            )),
        body: GestureDetector(
            onTap: () {
              bool isKeyboardShowing =
                  MediaQuery.of(context).viewInsets.bottom > 0;
              if (isKeyboardShowing) {
                FocusScopeNode currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
              }
            },
            child: this.body));
  }
}
