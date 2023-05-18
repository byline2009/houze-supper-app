import 'package:flutter/material.dart';
import 'package:houze_super/utils/constants/app_fonts.dart';

class HouzePay extends StatelessWidget {
  const HouzePay({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Text(
        'Houze Pay',
        style: AppFonts.bold18.copyWith(
          color: Colors.white,
        ),
      ),
    );
  }
}
