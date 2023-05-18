import 'dart:io';
import 'package:flutter/material.dart';
import 'package:houze_super/presentation/common_widgets/widget_dialog_custom.dart';
import 'package:permission_handler/permission_handler.dart';


/* camera and storage access permission handler */
class PermissionHandler {
  static checkAndRequestStoragePermission(
      {BuildContext? context, Function? func}) async {
    // Android
    if (Platform.isAndroid) {
      var status = await Permission.storage.status;
      // if (status.isUndetermined) {
      //   Map<Permission, PermissionStatus> statuses = await [
      //     Permission.storage,
      //   ].request();
      //   if (statuses[Permission.storage] == PermissionStatus.denied) {
      //     return;
      //   }
      //   if (statuses[Permission.storage] == PermissionStatus.granted &&
      //       func != null) {
      //     func();
      //   }
      // }
      if (status.isDenied) {
        Map<Permission, PermissionStatus> statuses = await [
          Permission.storage,
        ].request();
        print(statuses[Permission.storage]);
        if (statuses[Permission.storage] ==
            PermissionStatus.permanentlyDenied) {
          permissionAlertDialog(
              context: context!,
              title: 'file_media_permission',
              content: 'file_media_permission_msg',
              buttonText: 'settings',
              buttonCancel: 'houze_run_popup_location_permission_dont_allow');
          return;
        }
        if (statuses[Permission.storage] == PermissionStatus.granted &&
            func != null) {
          func();
        }
      }
      if (status.isPermanentlyDenied) {
        permissionAlertDialog(
            context: context!,
            title: 'file_media_permission',
            content: 'file_media_permission_msg',
            buttonText: 'settings',
            buttonCancel: 'houze_run_popup_location_permission_dont_allow');
        return;
      }
      if (status.isGranted && func != null) {
        func();
      }
    }

    // IOS
    if (Platform.isIOS) {
      if (func != null) {
        func();
      }
    }
  }

  static permissionAlertDialog(
      {BuildContext? context,
      String? title,
      String? content,
      String? buttonText,
      String? buttonCancel}) {
    DialogCustom.showAlertDialog(
      context: context!,
      title: title ?? "",
      content: content ?? "",
      buttonText: buttonText ?? "",
      buttonCancel: buttonCancel ?? "",
      onPressed: () {
        openAppSettings();
        Navigator.pop(context);
      },
    );
  }
}
