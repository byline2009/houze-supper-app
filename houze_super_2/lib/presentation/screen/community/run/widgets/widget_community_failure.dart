import 'package:flutter/material.dart';
import 'package:houze_super/presentation/common_widgets/widget_something_went_wrong.dart';

class CommunitySomethingWentWrong extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: Center(
        child: SomethingWentWrong(true),
      ),
    );
  }
}
