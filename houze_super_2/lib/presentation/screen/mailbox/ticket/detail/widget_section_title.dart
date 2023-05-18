import 'package:flutter/material.dart';
import 'package:houze_super/utils/index.dart';

class WidgetSectionTitle extends StatelessWidget {
  final String title;
  final Widget? trailing;
  const WidgetSectionTitle({required this.title, this.trailing});

  @override
  Widget build(BuildContext context) {
    Widget _trailing = trailing == null ? Center() : trailing!;
    return Container(
      width: double.infinity,
      height: 51,
      color: AppColor.gray_f5f5f5,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            LocalizationsUtil.of(context).translate(title),
            style: AppFont.MEDIUM_GRAY_838383_14,
          ),
          _trailing,
        ],
      ),
    );
  }
}
