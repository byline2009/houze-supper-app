import 'package:flutter/material.dart';

class VerticalDividerWidget extends StatelessWidget {
  final double width, height;

  const VerticalDividerWidget(
    this.width,
    this.height,
  );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: VerticalDivider(
        color: const Color(0xffc4c4c4),
        width: width,
        thickness: 1.0,
      ),
    );
  }
}
