import 'package:flutter/material.dart';
import 'package:houze_super/presentation/common_widgets/stateless/widget_home_scaffold.dart';
import 'package:houze_super/presentation/screen/profile/widgets/row_info_owner.dart';

import '../index.dart';
import '../models/index.dart';

class HouzePolicyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<ListItem> items =
        List.generate(infoOwnerList.length + policies.length + 1, (index) {
      if (index >= 0 && index < 3) return PolicyItem(policy: policies[index]);
      if (index == 3) return HeadingItem('information_of_the_owner');
      int i = index - 4;
      return InfomationOwnerItem(infoOwnerList[i].hint, infoOwnerList[i].title);
    });

    return HomeScaffold(
        title: 'policy_houze',
        child: ListView.builder(
            padding: const EdgeInsets.all(0),
            physics: const AlwaysScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];

              if (item is PolicyItem) {
                return item.buildItem(context);
              }
              if (item is HeadingItem)
                return Container(
                  height: 60,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: item.buildItem(context),
                );

              if (item is InfomationOwnerItem) return item.buildItem(context);
              return const SizedBox.shrink();
            }));
  }
}
