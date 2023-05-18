import 'package:flutter/material.dart';
import 'package:houze_super/utils/index.dart';
import 'package:package_info_plus/package_info_plus.dart';

class BottomCurrentVersion extends StatelessWidget {
  const BottomCurrentVersion({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PackageInfo>(
        future: PackageInfo.fromPlatform(),
        builder: (_, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            return Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                'Houze ${LocalizationsUtil.of(context).translate('version')} ${snapshot.data!.version}',
                style: AppFonts.regular15.copyWith(
                  color: Color(
                    0xff838383,
                  ),
                ),
                textAlign: TextAlign.center,
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        });
  }
}
