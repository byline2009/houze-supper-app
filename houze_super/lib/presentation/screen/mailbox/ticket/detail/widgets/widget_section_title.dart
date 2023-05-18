import 'package:flutter/material.dart';
import 'package:houze_super/utils/index.dart';

class WidgetSectionTitle extends StatelessWidget {
  final String title;
  final Widget trailing;
  const WidgetSectionTitle({
    @required this.title,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 51,
      color: const Color(0xfff5f5f5),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(LocalizationsUtil.of(context).translate(title),
              style: AppFonts.medium14.copyWith(color: Color(0xff808080))),
          trailing == null ? const SizedBox.shrink() : trailing,
        ],
      ),
    );
  }
}
