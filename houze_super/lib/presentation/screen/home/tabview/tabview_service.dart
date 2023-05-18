import 'package:flutter/material.dart' hide NestedScrollView;
import 'package:houze_super/presentation/common_widgets/stateless/widget_coming_soon.dart';

class TabViewService extends StatefulWidget {
  final Key tabKey;
  final String tabName;

  const TabViewService({
    Key key,
    this.tabKey,
    this.tabName,
  }) : super(key: key);

  @override
  _TabViewServiceState createState() => _TabViewServiceState();
}

class _TabViewServiceState extends State<TabViewService> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      key: PageStorageKey<String>("page_service"),
      slivers: <Widget>[
        SliverToBoxAdapter(
          child: WidgetComingSoon(),
        ),
      ],
    );
  }
}
