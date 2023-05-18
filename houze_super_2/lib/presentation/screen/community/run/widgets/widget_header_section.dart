import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:houze_super/presentation/index.dart';

import 'package:houze_super/utils/index.dart';

typedef void HeaderSectionViewAllCallBack();

class HeaderSection extends StatelessWidget {
  final String icon;
  final String title;
  final HeaderSectionViewAllCallBack callback;
  final bool isViewAll;
  const HeaderSection({
    required this.icon,
    required this.title,
    required this.callback,
    this.isViewAll = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: isViewAll
            ? MainAxisAlignment.spaceBetween
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(icon),
          const SizedBox(width: 8),
          Text(
            title,
            style: AppFonts.bold18,
            textAlign: TextAlign.left,
          ),
          isViewAll
              ? Expanded(
                  child: GestureDetector(
                    onTap: () => callback(),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        LocalizationsUtil.of(context).translate('see_all'),
                        style: AppFonts.medium14.copyWith(
                          color: Color(
                            0xff5b00e4,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              : const SizedBox.shrink()
        ],
      ),
    );
  }
}
