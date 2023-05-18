import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:houze_super/utils/constants/app_constants.dart';

const Duration defaultDuration = Duration(milliseconds: 300);
const double ICON_SIZE = 24.0;

class LikeAnimate extends StatelessWidget {
  const LikeAnimate({
    Key key,
    @required this.press,
    @required this.isLike,
  }) : super(key: key);

  final VoidCallback press;
  final bool isLike;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: AnimatedSwitcher(
        duration: defaultDuration,
        switchInCurve: Curves.easeInOutBack,
        transitionBuilder: (child, animation) => ScaleTransition(
          scale: animation,
          child: child,
        ),
        child: isLike
            ? SvgPicture.asset(
                AppVectors.icLike,
                key: ValueKey("like"),
                width: ICON_SIZE,
                height: ICON_SIZE,
              )
            : SvgPicture.asset(
                AppVectors.icLikeActive,
                key: ValueKey("unlike"),
                width: ICON_SIZE,
                height: ICON_SIZE,
              ),
      ),
    );
  }
}
