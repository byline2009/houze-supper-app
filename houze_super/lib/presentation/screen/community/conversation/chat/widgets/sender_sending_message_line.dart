import 'package:flutter/material.dart';
import 'package:houze_super/middle/local/storage.dart';
import 'package:houze_super/utils/localizations_util.dart';
import '../models/index.dart';
import 'package:houze_super/utils/constants/constants.dart';
import 'package:houze_super/utils/date_util.dart';

class SenderSendingMessage extends StatelessWidget {
  final MessageModel message;
  const SenderSendingMessage({
    @required this.message,
  });
  @override
  Widget build(BuildContext context) {
    String owner = message.user != null
        ? message.user.userFullName
        : LocalizationsUtil.of(Storage.scaffoldKey.currentContext)
            .translate('k_stranger');
    String title = message.senderUid != Storage.getUserID()
        ? owner +
            ' - ' +
            DateUtil.createAtMessage(
              message.createdAt,
              context: context,
            )
        : DateUtil.createAtMessage(
            message.createdAt,
            context: context,
          );
    return Text(
      title,
      style: AppFonts.medium11.copyWith(
        color: Color(0xff9c9c9c),
        letterSpacing: 0.22,
      ),
    );
  }
}
