import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../index.dart';

class NaviagationBottom {
  final BottomNavigationBarItem barItem;
  const NaviagationBottom(this.barItem);
}

class NavigationBottomList {
  final List<String> activeIcons = [
    AppVectors.icTabHouze,
    AppVectors.icTabCommunity,
    AppVectors.icTabInvoice,
    AppVectors.icTabMailbox,
    AppVectors.icTabProfile,
  ];
  final List<String> unactiveIcons = [
    AppVectors.icTabHouzeUnactive,
    AppVectors.icTabCommunityUnactive,
    AppVectors.icTabInvoiceUnactive,
    AppVectors.icTabMailboxUnactive,
    AppVectors.icTabProfileUnactive,
  ];
  final List<String> labels = [
    'home_page',
    'community',
    'pay',
    'inbox',
    'profile',
  ];
  static List<NaviagationBottom> makeBottom({
    @required BuildContext context,
  }) {
    return [
      NaviagationBottom(
        BottomNavigationBarItem(
          activeIcon: SvgPicture.asset(AppVectors.icTabHouze),
          icon: SvgPicture.asset(AppVectors.icTabHouzeUnactive),
          label: LocalizationsUtil.of(context).translate('home_page'),
        ),
      ),
      NaviagationBottom(
        BottomNavigationBarItem(
          activeIcon: SvgPicture.asset(AppVectors.icTabCommunity),
          icon: SvgPicture.asset(AppVectors.icTabCommunityUnactive),
          label: LocalizationsUtil.of(context).translate('community'),
        ),
      ),
      NaviagationBottom(
        BottomNavigationBarItem(
          activeIcon: NavigationItem(
            image: SvgPicture.asset(AppVectors.icTabInvoice),
          ),
          icon: NavigationItem(
            image: SvgPicture.asset(AppVectors.icTabInvoiceUnactive),
          ),
          label: LocalizationsUtil.of(context).translate('pay'),
        ),
      ),
      NaviagationBottom(
        BottomNavigationBarItem(
          activeIcon: NavigationItem(
            image: SvgPicture.asset(AppVectors.icTabMailbox),
          ),
          icon: NavigationItem(
            image: SvgPicture.asset(AppVectors.icTabMailboxUnactive),
          ),
          label: LocalizationsUtil.of(context).translate('inbox'),
        ),
      ),
      NaviagationBottom(
        BottomNavigationBarItem(
          activeIcon: NavigationItem(
            image: SvgPicture.asset(AppVectors.icTabProfile),
          ),
          icon: NavigationItem(
            image: SvgPicture.asset(AppVectors.icTabProfileUnactive),
          ),
          label: LocalizationsUtil.of(context).translate('profile'),
        ),
      ),
    ];
  }
}

class NavigationItem extends StatelessWidget {
  final SvgPicture image;
  final String badge;

  const NavigationItem({@required this.image, this.badge});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 50,
        height: 28,
        child: Stack(
          children: <Widget>[
            Align(alignment: Alignment.bottomCenter, child: image),
          ],
        ));
  }
}
