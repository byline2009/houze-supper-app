import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

import 'package:houze_super/utils/index.dart';

class FilterAllStatus extends StatelessWidget {
  const FilterAllStatus({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      padding: const EdgeInsets.symmetric(vertical: 12),
      borderType: BorderType.RRect,
      radius: Radius.circular(5),
      strokeCap: StrokeCap.square,
      color: Color(0xff838383),
      strokeWidth: 1,
      dashPattern: [10, 5, 10, 5, 10, 5],
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        child: Align(
          alignment: Alignment.center,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.add,
                color: Color(0xff838383),
                size: 18.0,
              ),
              const SizedBox(width: 8.0),
              Text(
                LocalizationsUtil.of(context).translate('status'),
                style: AppFonts.semibold13.copyWith(
                  color: Color(
                    0xff838383,
                  ),
                ),
              ),
              const SizedBox(width: 10.0),
            ],
          ),
        ),
      ),
    );
  }
}
