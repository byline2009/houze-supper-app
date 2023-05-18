import 'package:flutter/material.dart';
import 'package:houze_super/middle/local/storage.dart';
import 'package:houze_super/presentation/screen/base/base_widget.dart';
import '../models/index.dart';

class GroupChatAvatarWidget extends StatelessWidget {
  const GroupChatAvatarWidget({
    required this.users,
    required this.user,
  });
  final List<UserModel> users;
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    if (users.length == 0) {
      return SizedBox(
        width: 54,
        height: 54,
        child: BaseWidget.avatar(
          fullname: Storage.getUserName() ?? '',
          imageUrl: Storage.getAvatar(),
          size: 54,
        ),
      );
    }
    if (users.length >= 1) {
      List<UserModel> _users = users;
      if (_users.length == 1) {
        return SizedBox(
          width: 54,
          height: 54,
          child: BaseWidget.avatar(
            fullname: _users[0].userFullName ?? "",
            imageUrl: _users[0].userAvatar,
            size: 54,
          ),
        );
      }

      final UserModel firstUser =
          user.id?.isNotEmpty == true ? user : _users.first;
      UserModel secondUser = _users[1];
      if (_users.any((u) => u.id != firstUser.id)) {
        secondUser = _users.firstWhere(
          (element) => element.id != firstUser.id,
        );
      }

      return SizedBox(
        width: 54,
        height: 54,
        child: Stack(
          children: [
            Positioned(
                child: BaseWidget.avatar(
                  imageUrl: secondUser.userAvatar,
                  fullname: secondUser.userFullName ?? "",
                  size: 32,
                ),
                top: 0,
                right: 0),
            Positioned(
                child: BaseWidget.avatar(
                  fullname: firstUser.userFullName ?? "",
                  imageUrl: firstUser.userAvatar,
                  size: 43,
                ),
                bottom: 0,
                left: 0),
          ],
        ),
      );
    }
    return SizedBox(
      width: 54,
      height: 54,
      child: BaseWidget.avatar(
        fullname: Storage.getUserName() ?? '',
        imageUrl: Storage.getAvatar(),
        size: 54,
      ),
    );
  }
}
