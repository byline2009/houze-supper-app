import 'package:flutter/cupertino.dart';
import 'package:houze_super/presentation/common_widgets/widget_no_data_display.dart';
import 'package:houze_super/presentation/index.dart';

class WidgetFooter extends StatelessWidget {
  final List<dynamic> datasource;
  final bool shouldLoadMore;
  const WidgetFooter({
    Key? key,
    required this.datasource,
    required this.shouldLoadMore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomFooter(
      builder: (context, mode) {
        Widget body = SizedBox.shrink();
        if (shouldLoadMore == false) {
          mode = LoadStatus.noMore;
          return SizedBox(
            height: 60.0,
            child: Center(
              child: NoDataBottomLine(parentContext: context),
            ),
          );
        }
        if (mode == LoadStatus.idle) {
          body = CupertinoActivityIndicator();
        } else if (mode == LoadStatus.loading) {
          body = CupertinoActivityIndicator();
        } else {
          body = SizedBox.shrink();
        }
        print('**********LoadStatus Mode: ' + mode.toString());

        return SizedBox(
          height: 60.0,
          child: Center(
            child: body,
          ),
        );
      },
    );
  }
}
