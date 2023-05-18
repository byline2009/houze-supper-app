import 'package:flutter/material.dart';
import 'package:houze_super/utils/constants/constants.dart';

class WidgetRichText extends StatelessWidget {
  final String myString;
  final String wordToStyle;
  final TextStyle style;

  WidgetRichText(
      {@required this.myString, this.style, @required this.wordToStyle});

  List<TextSpan> _getSpans(String text, String matchWord, TextStyle style) {
    List<TextSpan> spans = [];
    int spanBoundary = 0;

    if (matchWord == null) {
      spans.add(TextSpan(text: text));
      return spans;
    }

    do {
      // look for the next match
      final startIndex = text.indexOf(matchWord, spanBoundary);

      // if no more matches then add the rest of the string without style
      if (startIndex == -1) {
        spans.add(TextSpan(text: text.substring(spanBoundary)));
        return spans;
      }

      // add any unstyled text before the next match
      if (startIndex > spanBoundary) {
        spans.add(TextSpan(text: text.substring(spanBoundary, startIndex)));
      }

      // style the matched text
      final endIndex = startIndex + matchWord.length;
      final spanText = text.substring(startIndex, endIndex);
      spans.add(TextSpan(text: spanText, style: style));

      // mark the boundary to start the next search from
      spanBoundary = endIndex;

      // continue until there are no more matches
    } while (spanBoundary < text.length);

    return spans;
  }

  @override
  Widget build(BuildContext context) {
    final spans = _getSpans(
        myString,
        wordToStyle,
        this.style != null
            ? this.style
            : AppFonts.bold15.copyWith(color: Color(0xff6001d2)));

    return RichText(
      text: TextSpan(
          style: AppFonts.regular13.copyWith(
            color: Color(0xff838383),
          ),
          children: spans),
    );
  }
}
