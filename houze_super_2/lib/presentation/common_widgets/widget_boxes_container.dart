import 'package:flutter/material.dart';
import 'package:houze_super/middle/local/storage.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/presentation/screen/base/base_widget.dart';

class WidgetBoxesContainer extends StatelessWidget {
  final Widget child;
  final String? title;
  final TextStyle? styleTitle;
  final EdgeInsets? padding;
  final Widget? action;
  final bool hasLine;

  WidgetBoxesContainer({
    required this.child,
    this.title,
    this.styleTitle,
    this.action,
    this.padding,
    this.hasLine = true,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
        decoration: hasLine
            ? BaseWidget.decorationDividerGray
            : BoxDecoration(
                color: Colors.white,
              ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
                padding: this.padding != null ? this.padding! : EdgeInsets.zero,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    this.title != null
                        ? Expanded(
                            child: Text(
                              LocalizationsUtil.of(
                                      Storage.scaffoldKey.currentContext)
                                  .translate(title),
                              style: styleTitle ?? AppFont.BOLD_BLACK_15,
                              maxLines: 3,
                            ),
                          )
                        : Center(),
                    this.action != null ? this.action! : Center()
                  ],
                )),
            child
          ],
        ));
  }
}
