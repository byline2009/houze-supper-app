// A ListItem that contains data to display a message.
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:houze_super/presentation/index.dart';

import '../index.dart';

typedef void PolicyItemCallback();

class PolicyItem implements ListItem {
  final PolicyElement policy;
  const PolicyItem({required this.policy});

  Future<void> _launchHouzePolicy() async {
    print(policy.link);
    await Utils.launchURL(url: policy.link);
  }

  @override
  Widget buildItem(BuildContext context) => GestureDetector(
        onTap: () async => _launchHouzePolicy(),
        child: Container(
          height: 72,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(
                width: 1.0,
                color: Color(0xffdcdcdc),
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(AppVectors.icon_policy),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text( LocalizationsUtil.of(context).translate(policy.title), style: AppFonts.regular15,)
                // child: Text(
                //   policy.title,
                //   style: AppFonts.regular15,
                // ),
              ),
              SvgPicture.asset(
                AppVectors.ic_arrow_right,
                color: Colors.black,
              )
            ],
          ),
        ),
      );
}
