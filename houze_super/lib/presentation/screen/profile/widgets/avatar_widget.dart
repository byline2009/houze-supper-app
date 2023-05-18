import 'dart:async';
import 'package:flutter/material.dart';
import 'package:houze_super/common/blocs/app_event_bloc.dart';
import 'package:houze_super/middle/local/storage.dart';
import 'package:houze_super/middle/model/image_model.dart';
import 'package:houze_super/presentation/screen/base/base_widget.dart';

class AvatarWidget extends StatefulWidget {
  @override
  _AvatarWidgetState createState() => _AvatarWidgetState();
}

class _AvatarWidgetState extends State<AvatarWidget> {
  String image;
  StreamSubscription<BlocEvent> _subAvatarChange;

  @override
  void initState() {
    super.initState();
    image = Storage.getAvatar();
    _subAvatarChange = AppEventBloc().listenEvent(
      eventName: EventName.profileChangeAvatar,
      handler: _handleProfileChangeAvatar,
    );
  }

  void _handleProfileChangeAvatar(BlocEvent evt) {
    final value = evt.value;

    if (mounted && value is ImageModel) {
      setState(() {
        image = value.imageThumb;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget.avatar(
      imageUrl: image,
      fullname: Storage.getUserName(),
      size: 40,
    );
  }

  @override
  void dispose() {
    if (_subAvatarChange != null) _subAvatarChange.cancel();
    super.dispose();
  }
}
