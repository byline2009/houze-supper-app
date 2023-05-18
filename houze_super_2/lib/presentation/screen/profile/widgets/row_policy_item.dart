import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:houze_super/presentation/index.dart';
import 'package:houze_super/utils/index.dart';

class PolicyItemWidget extends StatelessWidget {
  final String policy;
  const PolicyItemWidget(this.policy);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onPressViewDetailPolicy,
      child: Container(
        key: Key(policy),
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
              child: Text(
                policy,
                style: AppFonts.regular15,
              ),
            ),
            IconButton(
                icon: Icon(Icons.arrow_forward_rounded),
                onPressed: _onPressViewDetailPolicy),
          ],
        ),
      ),
    );
  }

  void _onPressViewDetailPolicy() => print('Clicked to $policy');
}
