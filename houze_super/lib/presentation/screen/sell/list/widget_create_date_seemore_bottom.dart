import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../index.dart';

class CreateDateSeemoreBottom extends StatelessWidget {
  final String created;
  const CreateDateSeemoreBottom({@required this.created});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          DateUtil.format('dd/MM/yyyy - HH:mm', created.toString()),
          style: AppFonts.semibold13.copyWith(color: Color(0xff6001d2)),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(LocalizationsUtil.of(context).translate('more'),
                style: AppFonts.semibold13.copyWith(color: Color(0xff6001d2))),
            const SizedBox(width: 10.0),
            SvgPicture.asset(AppVectors.ic_arrow_right),
          ],
        )
      ],
    );
  }
}
