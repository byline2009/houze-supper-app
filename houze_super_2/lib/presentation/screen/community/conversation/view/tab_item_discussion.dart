import 'package:flutter/material.dart';
import 'package:houze_super/presentation/common_widgets/empty_page.dart';
import 'package:houze_super/utils/index.dart';

/*
 * Screen: Thảo luận
 */
class TabItemDiscussion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      key: PageStorageKey<String>('TabItemDiscusstion'),
      physics: NeverScrollableScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: Container(
            color: Colors.white,
            child: EmptyPage(
              svgPath: AppVectors.icChatLight,
              content: 'k_this_feature_is_being_worked_on',
              width: 60,
              height: 60,
            ),
          ),
        ),
      ],
    );
  }
}
