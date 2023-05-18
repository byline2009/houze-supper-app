import 'package:flutter/material.dart';
import 'package:houze_super/presentation/common_widgets/widget_button.dart';
import 'package:houze_super/presentation/index.dart';

class WidgetConfirmDialog extends StatelessWidget {
  final Widget content;
  final VoidCallback confirmCallback;
  const WidgetConfirmDialog({
    Key key,
    @required this.content,
    @required this.confirmCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 235,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 10),
            Text(
              LocalizationsUtil.of(context)
                  .translate('k_action_confirmation'), //'Xác nhận hành động',
              textAlign: TextAlign.center,
              style: AppFonts.bold18.copyWith(
                letterSpacing: 0.29,
              ),
            ),
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 30,
              ),
              child: content,
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 48,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: WidgetButton.pink(
                      LocalizationsUtil.of(context).translate('back'),
                      callback: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: WidgetButton.outline(
                      LocalizationsUtil.of(context).translate('confirm'),
                      callback: () =>
                          confirmCallback != null ? confirmCallback() : null,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
