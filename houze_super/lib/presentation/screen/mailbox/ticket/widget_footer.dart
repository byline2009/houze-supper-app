import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:houze_super/presentation/common_widgets/stateless/widget_no_data_display.dart';
import 'package:houze_super/presentation/index.dart';

class WidgetFooter extends StatelessWidget {
  final List<dynamic> datasource;
  final bool shouldLoadMore;
  const WidgetFooter({
    Key key,
    @required this.datasource,
    @required this.shouldLoadMore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomFooter(
      builder: (BuildContext context, LoadStatus mode) {
        Widget body = SizedBox.shrink();

        if (shouldLoadMore == false) {
          mode = LoadStatus.noMore;
        }

        switch (mode) {
          case LoadStatus.idle:
          case LoadStatus.loading:
            body = CupertinoActivityIndicator();

            break;
          case LoadStatus.canLoading:
            print("release to load more");
            break;
          case LoadStatus.failed:
            print("Load Failed!Click retry!");
            break;

          default:
            if (datasource.length > 0)
              body = NoDataBottomLine(parentContext: context);
            break;
        }

        return SizedBox(
          height: 55.0,
          child: Center(child: body),
        );
      },
    );
  }
}
