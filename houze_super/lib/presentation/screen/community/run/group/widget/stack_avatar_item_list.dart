import 'package:flutter/material.dart';
import 'package:houze_super/presentation/screen/base/base_widget.dart';
import '../model/index.dart';

class StackAvatarHorizontal extends StatelessWidget {
  final List<JoinedModel> users;
  const StackAvatarHorizontal({
    Key key,
    @required this.users,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (users == null || users.length == 0) return SizedBox();
    return Stack(
        children: users
            .asMap()
            .entries
            .map((e) {
              int index = e.key;
              JoinedModel item = e.value;
              return Container(
                width: 60,
                height: 30,
                margin: EdgeInsets.only(left: index * 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    avatar(user: item.user),
                  ],
                ),
              );
            })
            .toList()
            .reversed
            .toList());
  }

  Widget avatar({MemberModel user}) => BaseWidget.avatar(
        imageUrl: user.imageThumb,
        fullname: user.fullname,
        size: 30,
      );
}
