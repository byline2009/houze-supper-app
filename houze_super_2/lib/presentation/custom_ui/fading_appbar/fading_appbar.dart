import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FadingAppbar extends StatefulWidget {
  final Widget leading;
  final Widget title;
  final Color? backgroundColor;
  final BoxDecoration? decoration;

  final SystemUiOverlayStyle? brightness;

  FadingAppbar(
      {Key? key,
      required this.title,
      required this.leading,
      this.decoration,
      this.backgroundColor,
      this.brightness})
      : super(key: key);

  @override
  FadingAppbarState createState() => new FadingAppbarState();
}

class FadingAppbarState extends State<FadingAppbar> {
  Widget actions = SizedBox.shrink();
  double elevation = 0;
  // double _defaultElevation = 4.0;
  late AppBarTheme appBarTheme;

  FadingAppbarState();

  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;
    final ThemeData themeData = Theme.of(context);
    this.appBarTheme = AppBarTheme.of(context);

    // AppBar height
    double _kLeadingWidth = kToolbarHeight;
    // Status bar height
    double _statusBarHeight = MediaQuery.of(context).padding.top;
    final padding = _screenSize.width * 15 / 100;

    final SystemUiOverlayStyle brightness = widget.brightness ??
        appBarTheme.systemOverlayStyle ??
        SystemUiOverlayStyle.light;
    final SystemUiOverlayStyle overlayStyle =
        brightness == SystemUiOverlayStyle.dark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark;

    return Semantics(
      container: true,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: overlayStyle,
        child: Material(
          color: widget.backgroundColor ??
              appBarTheme.backgroundColor ??
              themeData.primaryColor,
          elevation: this.elevation,
          child: Semantics(
            explicitChildNodes: true,
            child: PreferredSize(
              preferredSize: Size(double.infinity, _kLeadingWidth),
              child: Container(
                color: widget.backgroundColor,
                decoration:
                    widget.backgroundColor == null ? widget.decoration : null,
                width: MediaQuery.of(context).size.width,
                child: Container(
                  margin: EdgeInsets.fromLTRB(0, _statusBarHeight, 0, 0),
                  height: _kLeadingWidth,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(width: padding, child: widget.leading),
                      widget.title,
                      SizedBox(width: padding)
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    final SystemUiOverlayStyle overlayStyle =
        this.appBarTheme.systemOverlayStyle == SystemUiOverlayStyle.dark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark;
    SystemChrome.setSystemUIOverlayStyle(overlayStyle);
    super.dispose();
  }
}
