import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Displays a [Banner] saying "DEBUG" when running in debug mode.
/// [MaterialApp] builds one of these by default.
/// Does nothing in release mode.
class HouzeModeBanner extends StatelessWidget {
  /// Creates a const debug mode banner.
  const HouzeModeBanner({
    Key? key,
    required this.child,
		required this.title
  }) : super(key: key);

  /// The widget to show behind the banner.
  ///
  /// {@macro flutter.widgets.ProxyWidget.child}
  final Widget child;
	final String title;

  @override
  Widget build(BuildContext context) {
    Widget result = child;
		// assert only run in debug mode
    assert(() {
      result = Banner(
        message: title,
        textDirection: TextDirection.ltr,
        location: BannerLocation.topEnd,
        child: result,
      );
      return true;
    }());
    return result;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    String message = 'disabled';
    assert(() {
      message = this.title;
      return true;
    }());
    properties.add(DiagnosticsNode.message(message));
  }
}