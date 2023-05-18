import 'package:flutter/material.dart';
import 'package:houze_super/utils/constants/constants.dart';

class MessageOnChat extends StatelessWidget {
  final String text;
  const MessageOnChat({
    @required this.text,
  });
  @override
  Widget build(BuildContext context) {
    return SelectableText(
      text,
      style: AppFonts.regular14,
      toolbarOptions: ToolbarOptions(
        copy: true,
        selectAll: true,
        cut: false,
        paste: false,
      ),
    );
  }
}
