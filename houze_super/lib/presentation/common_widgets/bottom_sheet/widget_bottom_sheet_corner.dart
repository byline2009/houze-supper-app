import 'package:flutter/material.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/presentation/screen/community/run/group/index.dart';

class BottomSheetCornerWidget extends StatelessWidget {
  final String title;
  final Widget body;
  final double height;

  const BottomSheetCornerWidget(
      {Key key, @required this.title, @required this.body, this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 300,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(StyleHomePage.borderRadius),
          topRight: Radius.circular(StyleHomePage.borderRadius),
        ),
      ),
      child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderBottomSheet(title: title, parentContext: context),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: body ?? const SizedBox.shrink(),
            )
          ]),
    );
  }
}
