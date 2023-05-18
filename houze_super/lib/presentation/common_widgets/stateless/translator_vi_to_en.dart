import 'package:flutter/material.dart';
import 'package:houze_super/utils/index.dart';
import 'package:houze_super/utils/localizations_util.dart';
import 'package:translator/translator.dart';

void showSnackBar(BuildContext context, String content) {
  Scaffold.of(context).showSnackBar(
    SnackBar(
      content: Text(LocalizationsUtil.of(context).translate(content)),
    ),
  );
}

class TranslatorViToEn extends StatelessWidget {
  final String source;
  final String locale;

  const TranslatorViToEn(this.source, this.locale);

  @override
  Widget build(BuildContext context) {
    final translator = GoogleTranslator();
    final localeCode = {
      "en": "en",
      "vi": "vn",
      "zh": "zh-cn",
      "ko": "ko",
      "ja": "ja",
    };

    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: FlatButton(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(Icons.translate, color: Colors.black),
            const SizedBox(
              width: 5.0,
            ),
            Text('TRANSLATE', style: AppFonts.regular12),
          ],
        ),
        onPressed: () {
          translator
              .translate(source, from: 'vi', to: localeCode[locale] ?? 'en')
              .then((translated) {
            showSnackBar(context, translated.text);
          });
        },
      ),
    );
  }
}
