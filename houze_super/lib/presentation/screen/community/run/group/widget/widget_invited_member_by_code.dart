import 'package:flutter/material.dart';
import 'package:houze_super/utils/constants/constants.dart';
import 'package:houze_super/utils/index.dart';

class InvitedMemberByCode extends StatelessWidget {
  final String code;
  const InvitedMemberByCode({
    Key key,
    @required this.code,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 11),
      child: RichText(
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
          textAlign: TextAlign.start,
          text: TextSpan(
              style: AppFonts.semibold13.copyWith(
                color: Color(0xff838383),
              ),
              children: <TextSpan>[
                TextSpan(
                  text: LocalizationsUtil.of(context).translate(
                          'k_please_invite_more_teammates_through_the_code') +
                      ' ', //'Hãy mời thêm đồng đội thông qua mã code ',
                ),
                TextSpan(
                    text: code,
                    style:
                        AppFonts.semibold13.copyWith(color: Color(0xff6001d2)))
              ])),
    );
  }
}
