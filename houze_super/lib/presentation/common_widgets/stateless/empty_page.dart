import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/utils/index.dart';

class EmptyPage extends StatelessWidget {
  final String svgPath;
  final String content;
  final double width;
  final double height;

  const EmptyPage({
    this.svgPath,
    @required this.content,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Align(
        alignment: Alignment.topCenter,
        child: Column(
          children: <Widget>[
            const SizedBox(height: 120),
            svgPath == null
                ? const SizedBox.shrink()
                : SvgPicture.asset(
                    svgPath,
                    width: width ?? 80.0,
                    height: height ?? 80.0,
                  ),
            const SizedBox(height: 16.0),
            Text(
              LocalizationsUtil.of(context).translate(content),
              style: AppFonts.regular15.copyWith(
                color: Color(0xff838383),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
