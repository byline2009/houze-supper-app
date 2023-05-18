import 'package:flutter/material.dart';
import 'package:houze_super/utils/constants/constants.dart';
import 'package:houze_super/utils/localizations_util.dart';

class HomeScaffold extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final String title;
  final List<Widget> actions;
  final Widget child;
  final Widget floatingActionButton;
  final FloatingActionButtonLocation floatingActionButtonLocation;
  final TabBar tabBar;
  final Widget bottomSheet;
  final Function onPressLeading;

  HomeScaffold(
      {@required this.title,
      this.actions,
      this.child,
      this.floatingActionButton,
      this.floatingActionButtonLocation,
      this.tabBar,
      this.bottomSheet,
      this.scaffoldKey,
      this.onPressLeading})
      : assert(title != null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
          title: Text(
            LocalizationsUtil.of(context).translate(title),
            style: AppFonts.semibold18,
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0.0,
          actions: actions,
          bottom: tabBar,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: onPressLeading == null
                ? () {
                    Navigator.of(context).pop();
                  }
                : onPressLeading,
          )),
      body: SafeArea(child: child),
      bottomSheet: bottomSheet != null
          ? Container(
              height: 88.0,
              width: double.infinity,
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    offset: Offset(0, 2.0),
                    blurRadius: 10.0,
                    color: Color.fromRGBO(0, 0, 0, 0.15),
                  ),
                ],
              ),
              child: bottomSheet,
            )
          : null,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
    );
  }
}
