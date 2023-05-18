import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:houze_super/middle/model/run/run_lifestyle_model.dart';
import 'package:houze_super/middle/repo/group_repo.dart';
import 'package:houze_super/utils/file_util.dart';
import 'package:houze_super/utils/index.dart';

class RunRequest {
  final repo = GroupRepository();

  Future<ActivityUpdate?> sendActivity(
    File? file,
    ProgressHUD progressHUD,
  ) async {
    try {
      progressHUD.state.show();
      final activity = await repo.startActivity(
        <String, dynamic>{
          "name": "Houze App",
          "type": 0,
        },
      );

      if (activity.id != null) {
        final String activityId = await repo.uploadActivityFile(
          activityId: activity.id!,
          file: file!,
          broadcastOrganization: Sqflite.currentBuilding?.id,
        );
        if (activityId.length > 0) {
          final activityUpdate = await repo.finishActivity(activityId);
          return activityUpdate;
        }
      }
      return null;
    } on DioError catch (err) {
      if (err.error is! SocketException) {
        await file?.delete();
      }
      rethrow;
    } catch (e) {
      rethrow;
    } finally {
      FileUtil.singleton.deleteDirectory('run_log');
      progressHUD.state.dismiss();
    }
  }
}
