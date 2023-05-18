import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/utils/toast.dart';

class CodeLineWidget extends StatelessWidget {
  final String code;

  const CodeLineWidget({Key key, @required this.code}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: RichText(
            text: TextSpan(
              style: AppFonts.bold18,
              children: [
                TextSpan(
                    text: 'Code: ',
                    style: AppFonts.bold15
                        .copyWith(color: Color(0xff838383), fontSize: 18)),
                TextSpan(text: code)
              ],
            ),
          ),
        ),
        copyCodeButton(context)
      ],
    );
  }

  Widget copyCodeButton(BuildContext parentContext) {
    return GestureDetector(
        onTap: () {
          Clipboard.setData(
            ClipboardData(text: code),
          ).then((_) {
            ToastUtil.show(
                ToastDecorator(
                    backgroundColor: Color(0xfff2f2f2),
                    widget: RichText(
                      textAlign: TextAlign.left,
                      text: TextSpan(children: [
                        TextSpan(
                          text: LocalizationsUtil.of(parentContext)
                                  .translate('k_copied_code') +
                              ': ',
                          style: AppFonts.medium
                              .copyWith(color: Color(0xff808080)),
                        ),
                        TextSpan(
                            text: code,
                            style: AppFonts.medium14
                                .copyWith(color: Colors.black)
                                .copyWith(
                                    fontWeight: FontWeight.bold, fontSize: 16))
                      ]),
                    )),
                parentContext,
                gravity: ToastPosition.bottom,
                duration: 3);
          });
        },
        child: Container(
          height: 30,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
              color: Color(0xfff2e8ff),
              borderRadius: BorderRadius.all(Radius.circular(4.0))),
          child: Text(LocalizationsUtil.of(parentContext).translate('k_copy'),
              style: AppFonts.medium14.copyWith(color: Color(0xff6001d2)),
              textAlign: TextAlign.center),
        ));
  }
}
