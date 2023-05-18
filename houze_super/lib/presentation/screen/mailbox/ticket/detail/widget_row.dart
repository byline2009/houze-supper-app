import 'package:flutter/material.dart';
import 'package:houze_super/utils/index.dart';

class WidgetRow extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const WidgetRow({
    @required this.label,
    @required this.value,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(LocalizationsUtil.of(context).translate(label),
              textAlign: TextAlign.left,
              style: TextStyle(
                  color: color ?? Color(0xff808080),
                  fontSize: 14,
                  fontFamily: AppFonts.font_family_display)),
          const SizedBox(width: 20),
          Flexible(
            child: Text(
              LocalizationsUtil.of(context).translate(value),
              textAlign: TextAlign.right,
              style: TextStyle(
                color: color ?? Colors.black,
                fontSize: 14,
                fontFamily: AppFonts.font_family_display,
              ),
            ),
          )
        ],
      ),
    );
  }
}
