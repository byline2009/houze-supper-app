import 'package:flutter/material.dart';
import 'package:houze_super/presentation/common_widgets/button_widget.dart';
import 'package:houze_super/utils/localizations_util.dart';
import 'package:url_launcher/url_launcher.dart';

class WidgetFileAttach extends StatelessWidget {
  final String file;
  const WidgetFileAttach({required this.file});

  @override
  Widget build(BuildContext context) {
    if (file.isNotEmpty) {
      return Padding(
          padding: const EdgeInsets.all(20),
          child: ButtonWidget(
            isActive: true,
            callback: () => launch(file),
            defaultHintText:
                LocalizationsUtil.of(context).translate('open_attachment'),
          ));
    }
    return SizedBox.shrink();
  }
}
