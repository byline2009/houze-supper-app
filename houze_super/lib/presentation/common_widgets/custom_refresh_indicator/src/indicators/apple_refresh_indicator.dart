import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// This function can be passed to the [CupertinoSliverRefreshControl] builder function
// in order to achieve a much more natural pull-to-refresh spinner.  The out-of-the-box
// implementation provided by Flutter uses a down-arrow which is very unfamiliar to iOS
// users. This implementation is an attempt to make a more faithful implementation.
//
// It isn't perfect (in iOS, the spinner stays pinned to the top, whereas this implementation
// allows it to scroll down with the content), but the spinner implementation is much more
// like the standard iOS implementation which does the following:
//
// * As you drag down, the spinner fades in
// * As it fades in, it draws the ticks one at a time (ie. it isn't just the spinner rotating)
// * Once you're refreshing, the standard spinner shows
// * When you're done, the spinner shrinks out of view
//
// You can use it like so:
// ```
//   CupertinoSliverRefreshControl(
//    ...
//    builder: buildHackyAppleRefreshIndicator,
//   )
// ```
//
// See https://github.com/flutter/flutter/issues/29159 which is tracking the real
// implementation.
//
// The starting point for this class was looking at the [CupertinoActivityIndicator] that
// is provided with the Flutter SDK.
//
// IMPORTANT: Many of the constants (such as the default radius and colours) are copied
// from the SDK at a certain point in time so may diverge from the standard implementation.
// Use at your own risk.

// The radius of the spinner
const double kDefaultRadius = 14.0;
// Used as a reference size in order to calculate the segment sizes
const double _kDefaultIndicatorRadius = 10.0;
// How many ticks are in the spinner
const int _kTickCount = 12;
// Colours for the ticks
const Color _kActiveTickColor = CupertinoDynamicColor.withBrightness(
  color: Color(0xFF3C3C44),
  darkColor: Color(0xFFEBEBF5),
);

class DraggingActivityIndicator extends StatelessWidget {
  final double percentageComplete;
  final double radius;

  DraggingActivityIndicator(
      {@required this.percentageComplete, @required this.radius});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: radius * 2,
      width: radius * 2,
      child: CustomPaint(
        painter: _DraggingActivityIndicatorPainter(
          percentageComplete: percentageComplete,
          activeColor:
              CupertinoDynamicColor.resolve(_kActiveTickColor, context),
          radius: radius,
        ),
      ),
    );
  }
}

class _DraggingActivityIndicatorPainter extends CustomPainter {
  _DraggingActivityIndicatorPainter({
    @required this.percentageComplete,
    @required this.activeColor,
    double radius,
  }) : tickFundamentalRRect = RRect.fromLTRBXY(
          -radius,
          radius / _kDefaultIndicatorRadius,
          -radius / 2.0,
          -radius / _kDefaultIndicatorRadius,
          radius / _kDefaultIndicatorRadius,
          radius / _kDefaultIndicatorRadius,
        );

  final double percentageComplete;
  final RRect tickFundamentalRRect;
  final Color activeColor;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    canvas.save();
    canvas.translate(size.width / 2.0, size.height / 2);

    // The standard implementation has the top tick appearing first, so
    // need to rotate so that that is the first one that gets drawn
    canvas.rotate(pi / 2);

    for (var i = 0; i < (percentageComplete * _kTickCount); ++i) {
      paint.color = activeColor.withAlpha(147);
      canvas.drawRRect(tickFundamentalRRect, paint);
      canvas.rotate(pi * 2.0 / _kTickCount);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(_DraggingActivityIndicatorPainter oldPainter) {
    return oldPainter.percentageComplete != percentageComplete ||
        oldPainter.activeColor != activeColor;
  }
}
