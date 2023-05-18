import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:houze_super/utils/index.dart';

class HeaderBottomSheet extends StatelessWidget {
  final String title;
  final BuildContext parentContext;

  const HeaderBottomSheet(
      {Key? key, required this.title, required this.parentContext})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(left: 10.0),
          padding: const EdgeInsets.all(20),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: AppFonts.medium18,
          ),
        ),
        Positioned(
          left: 17,
          child: GestureDetector(
            onTap: () {
              Navigator.of(parentContext).pop();
            },
            child: Container(
              width: 35,
              height: 35,
              color: Colors.white,
              child: Center(
                child: SvgPicture.asset(
                  AppVectors.icClose,
                  width: 14,
                  height: 14,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
