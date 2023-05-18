import 'package:flutter/material.dart';

class DividerCustom extends StatelessWidget {
  final Color color;

  const DividerCustom({this.color: const Color(0xfff5f5f5)});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 5.0,
      width: double.infinity,
      color: color,
    );
  }
}
