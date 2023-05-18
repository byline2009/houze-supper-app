import 'package:flutter/material.dart';
import 'package:houze_super/presentation/index.dart';

typedef void CallBackHandlerVoid();

class BaseScaffold extends StatelessWidget {
  final Widget child;
  final String title;
  final IconData icon;
  final List<Widget>? actions;
  final Widget? bottomAppBar;
  final Widget? trailing;
  final CallBackHandlerVoid? callback;

  BaseScaffold({
    required this.title,
    this.trailing,
    required this.child,
    this.icon = Icons.arrow_back,
    this.actions,
    this.bottomAppBar,
    this.callback,
  });

  @override
  Widget build(BuildContext context) {
    final ModalRoute<Object?>? parentRoute = ModalRoute.of(context);
    final bool useCloseButton =
        parentRoute is PageRoute<dynamic> && parentRoute.fullscreenDialog;

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            LocalizationsUtil.of(context).translate(title),
            style: AppFonts.medium18.copyWith(letterSpacing: 0.29),
          ),
          backgroundColor: Colors.white,
          elevation: 0.0,
          leading: callback != null
              ? IconButton(
                  icon: Icon(
                    this.icon,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    callback ?? Navigator.pop(context);
                  },
                )
              : IconButton(
                  icon: Icon(
                    useCloseButton ? Icons.close : Icons.arrow_back,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
          actions: actions,
        ),
        resizeToAvoidBottomInset: true,
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
            child: this.child),
        bottomNavigationBar: this.bottomAppBar);
  }
}
