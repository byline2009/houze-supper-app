import 'package:flutter/material.dart';
import 'package:houze_super/presentation/screen/base/base_widget.dart';
import 'package:houze_super/presentation/screen/community/run/group/index.dart';

class AvatarListWidget extends StatelessWidget {
  final GroupModel group;
  AvatarListWidget({@required this.group});
  @override
  Widget build(BuildContext context) {
    MemberModel owner = group.createdBy;
    final MemberModel userRight =
        group.joined.firstWhere((value) => value.user.id != owner.id).user;
    final MemberModel userLeft = group.joined
        .firstWhere((value) =>
            value.user.id != owner.id && value.user.id != userRight.id)
        .user;
    return SizedBox(
      width: 60,
      height: 32,
      child: Stack(
        children: [
          Positioned(
              child: BaseWidget.avatar(
                  imageUrl: userLeft.imageThumb,
                  fullname: userLeft.fullname,
                  size: 30),
              top: 0,
              right: 0),
          Positioned(
              child: BaseWidget.avatar(
                imageUrl: owner.imageThumb,
                fullname: owner.fullname,
                size: 30,
              ),
              top: 0,
              right: 0),
          Positioned(
              child: BaseWidget.avatar(
                imageUrl: userRight.imageThumb,
                fullname: userRight.fullname,
                size: 30,
              ),
              bottom: 0,
              left: 0),
        ],
      ),
    );
  }
}
