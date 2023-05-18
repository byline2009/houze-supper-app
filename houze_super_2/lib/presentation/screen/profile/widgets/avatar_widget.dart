import 'dart:async';
import 'package:flutter/material.dart';
import 'package:houze_super/middle/local/storage.dart';
import 'package:houze_super/middle/model/image_model.dart';
import 'package:houze_super/presentation/screen/base/base_widget.dart';
import 'package:houze_super/utils/controller/app_controller.dart';
import 'package:houze_super/utils/controller/app_event_bus.dart';

class AvatarWidget extends StatefulWidget {
  @override
  _AvatarWidgetState createState() => _AvatarWidgetState();
}

class _AvatarWidgetState extends State<AvatarWidget> {
  String? image;
  StreamSubscription? subscriptionUpdateProfile;

  @override
  void initState() {
    super.initState();
    image = Storage.getAvatar();
    subscriptionUpdateProfile =
        AppController().eventBus.on<EventProfileUpdateAvatar>().listen(
      (event) {
        handleEventProfileUpdateAvatar(event.imageModel);
      },
    );
  }

  handleEventProfileUpdateAvatar(ImageModel imageModel) {
    if (mounted)
      setState(() {
        image = imageModel.imageThumb;
      });
  }

  @override
  Widget build(BuildContext context) {
    return BaseWidget.avatar(
      imageUrl: image ?? '',
      fullname: Storage.getUserName() ?? '',
      size: 40,
    );
  }

  @override
  void dispose() {
    if (subscriptionUpdateProfile != null) subscriptionUpdateProfile?.cancel();
    super.dispose();
  }
}
