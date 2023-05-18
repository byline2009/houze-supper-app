import 'package:flutter/material.dart';
import 'package:houze_super/presentation/common_widgets/widget_button.dart';
import 'package:houze_super/presentation/index.dart';

class WidgetConfirmDialog extends StatefulWidget {
  final BuildContext parentContext;
  final Widget content;
  final VoidCallback confirmCallback;
  const WidgetConfirmDialog(
      {Key? key,
      required this.parentContext,
      required this.content,
      required this.confirmCallback})
      : super(key: key);

  @override
  _WidgetConfirmDialogState createState() => _WidgetConfirmDialogState();
}

class _WidgetConfirmDialogState extends State<WidgetConfirmDialog> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 235.0,
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 10.0),
          Text(
              LocalizationsUtil.of(widget.parentContext).translate(
                  'voting_confirm_dialog_title'), //'Xác nhận thực hiện',
              textAlign: TextAlign.center,
              style: AppFonts.bold18),
          Container(
            alignment: Alignment.center,
            margin:
                const EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
            child: widget.content,
          ),
          const SizedBox(height: 20.0),
          SizedBox(
            height: 48.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: WidgetButton.pink(
                    LocalizationsUtil.of(context).translate('back'),
                    callback: () {
                      Navigator.of(widget.parentContext).pop();
                    },
                  ),
                ),
                const SizedBox(width: 15.0),
                Expanded(
                  child: WidgetButton.outlinePurpleButton(
                    text: LocalizationsUtil.of(context).translate('confirm'),
                    style: TextStyle(
                        color: Color(0xff6001d2),
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold),
                    callback: () {
                      widget.confirmCallback();
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
