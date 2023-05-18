import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:houze_super/utils/constants/constants.dart';
import 'package:houze_super/utils/index.dart';

typedef void CallBackHandler();

class BaseScaffoldNoFocus extends StatelessWidget {
  final Widget child;
  final String title;
  final IconData icon;
  final List<Widget> actions;
  final Widget bottomAppBar;
  final Widget bottom;

  final Widget leading;
  final CallBackHandler callback;

  BaseScaffoldNoFocus(
      {this.title,
      this.leading,
      @required this.child,
      this.bottom,
      this.icon = Icons.arrow_back,
      this.actions,
      this.bottomAppBar,
      this.callback});

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
      context,
      width: DesignUtil.widthScreenDevice,
      height: DesignUtil.heightScreenDevice,
      allowFontScaling: false,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          this.title,
          style: AppFonts.medium18.copyWith(
            letterSpacing: 0.29,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.0,
        bottom: PreferredSize(
          preferredSize: Size(ScreenUtil.screenWidth, 5),
          child: bottom ?? const SizedBox.shrink(),
        ),
        leading: leading ??
            IconButton(
              icon: Icon(
                this.icon,
                color: Colors.black,
              ),
              onPressed: () {
                callback == null ? Navigator.pop(context) : callback();
              },
            ),
        actions: actions,
      ),
      body: SafeArea(
        child: this.child,
      ),
      backgroundColor: Colors.white,
      bottomNavigationBar: this.bottomAppBar,
    );
  }
}
