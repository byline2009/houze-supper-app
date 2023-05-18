import 'package:flutter/material.dart';
import 'package:houze_super/presentation/screen/base/base_widget.dart';
import 'package:houze_super/utils/index.dart';

import '../models/index.dart';

class MemberChatItem extends StatelessWidget {
  final UserModel user;
  const MemberChatItem({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: 20,
        // bottom: 20,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          //Avatar
          BaseWidget.avatar(
            size: 40,
            fullname: user.userFullName ?? "",
            imageUrl: user.userAvatar,
          ),

          const SizedBox(width: 10),
          //Message
          Expanded(
            child: SizedBox(
              height: 40,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    user.userFullName ?? "",
                    style: AppFonts.medium14.copyWith(color: Colors.black),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  // SizedBox(height: 2),
                  // Text(
                  //   'chat.phoneNumber',
                  //   overflow: TextOverflow.ellipsis,
                  //   style: AppFonts.semibold13.copyWith(color: Color(0xff838383),),
                  // ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 20),
          // GestureDetector(
          //   onTap: () async {},
          //   child: SizedBox(
          //     height: 40,
          //     width: 40,
          //     child: SvgPicture.asset(
          //       AppVectors.ic_call,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
