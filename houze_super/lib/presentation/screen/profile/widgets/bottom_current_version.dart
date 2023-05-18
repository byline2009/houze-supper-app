import 'package:flutter/material.dart';
import 'package:houze_super/utils/index.dart';

class BottomCurrentVersion extends StatelessWidget {
  final String version;

  const BottomCurrentVersion({Key key, this.version}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 16.0),
      child: Text(
        'Houze ${LocalizationsUtil.of(context).translate('version')} $version',
        style: AppFonts.regular15.copyWith(
          color: Color(0xff808080),
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
