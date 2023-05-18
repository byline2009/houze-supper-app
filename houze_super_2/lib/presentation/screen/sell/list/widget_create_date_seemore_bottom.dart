import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../index.dart';

class CreateDateSeemoreBottom extends StatelessWidget {
  final String created;
  const CreateDateSeemoreBottom({required this.created});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          DateUtil.format('dd/MM/yyyy - HH:mm', created.toString()),
          style: AppFont.SEMIBOLD_PURPLE_6001d2_13,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(LocalizationsUtil.of(context).translate('more'),
                style: AppFont.SEMIBOLD_PURPLE_6001d2_13),
            SizedBox(width: 10.0),
            SvgPicture.asset(AppVectors.ic_arrow_right),
          ],
        )
      ],
    );
  }
}
