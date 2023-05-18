import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:houze_super/middle/api/oauth_api.dart';
import 'package:houze_super/middle/model/page_model.dart';

import 'package:houze_super/middle/model/run/run_lifestyle_model.dart';
import 'package:houze_super/presentation/screen/community/run/group/index.dart';
import 'package:houze_super/utils/constants/constants.dart';
import 'package:houze_super/utils/index.dart';
import 'package:path/path.dart';

enum JoinTeamState { success, notFound, isFull, cannotJoin, error }

class GroupAPI extends OauthAPI {
  GroupAPI() : super(RunPath.baseUrl);

  Future<ActivityModel> startActivity(Map<String, dynamic> args) async {
    try {
      final response = await this.post(
        RunPath.runActivities,
        data: args,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      final result = ActivityModel.fromJson(response.data);

      print(result.toString());

      return result;
    } catch (err) {
      print(err.toString());
      rethrow;
    }
  }

  Future<ActivityUpdate> updateActivity(String activityId) async {
    try {
      final response = await this.put(
        RunPath.runActivities + '$activityId/update_status/',
        data: <String, int>{"status": 2},
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      print(response.data);

      final result = ActivityUpdate.fromJson(response.data);

      return result;
    } catch (err) {
      print(err.toString());
      rethrow;
    }
  }

  Future<String> uploadActivityFile({
    String activityId,
    @required File file,
    String broadcastOrganization,
  }) async {
    final mFile = MultipartFile.fromFileSync(
      file.path,
      filename: basename(file.path),
    );

    try {
      final response = await this.post(
        RunPath.uploadFile,
        data: FormData.fromMap(
          <String, dynamic>{
            "activity": activityId,
            "file": mFile,
            "broadcast_to_organization": broadcastOrganization
          },
        ),
      );

      print(response.data);

      return response.data['activity'];
    } catch (err) {
      print(err.response.data['error_lifestyle_json']['http_body']);
      rethrow;
    }
  }

  Future<PageModel> getAllGroup(
      {@required int page, @required String eventID}) async {
    try {
      String url = GroupPath.baseUrl;
      final response = await this.get(url, queryParameters: {
        "event_id": eventID,
        "limit": AppConstant.limitDefault,
        "offset": page * AppConstant.limitDefault
      });

      return PageModel.fromJson(response.data);
    } on DioError catch (err) {
      if (err.error is String) {
        final Map<String, dynamic> data = json.decode(err.error);
        return PageModel.fromJson(data);
      } else {
        return null;
      }
    }
  }

  Future<GroupModel> createNewGroup(
      {@required String eventId, @required String name}) async {
    try {
      final options = Options(contentType: Headers.formUrlEncodedContentType);

      final response = await this.post(GroupPath.baseUrl,
          data: {
            "event_id": eventId,
            "name": name,
          },
          options: options);

      return GroupModel.fromJson(response.data);
    } on DioError catch (err) {
      if (err.error is String) {
        final Map<String, dynamic> data = json.decode(err.error);
        return GroupModel.fromJson(data);
      } else
        rethrow;
    }
  }

/*Lấy danh sách yêu cầu tham gia nhóm*/
  Future<PageModel> getEventsRequest({@required String groupID}) async {
    try {
      final response = await this.get(RunPath.getEventsRequest,
          queryParameters: {"group_id": groupID});
      return PageModel.fromJson(response.data);
    } on DioError catch (err) {
      if (err.error is String) {
        final Map<String, dynamic> data = json.decode(err.error);
        return PageModel.fromJson(data);
      } else
        rethrow;
    }
  }

  /*Chủ room 
  Duyệt yêu cầu: status == 1
  Từ chối yêu cầu:status == 2
   */

  Future<bool> putConfirmRequestJoinTeam(
      {@required TypeRequestEvent type, @required String requestID}) async {
    try {
      int status = type == TypeRequestEvent.approve ? 1 : 2;

      final response =
          await this.put(RunPath.getEventsRequest + requestID + '/',
              data: {
                'status': status,
              },
              options: Options(contentType: Headers.formUrlEncodedContentType));

      return response.statusCode == 200;
    } on DioError catch (e) {
      print("putConfirmRequestJoinTeam: ${e.response.data}");
    }
    return false;
  }

  /*Tham gia đội bởi mã*/
  Future<JoinTeamState> putJoinGroupByCode({@required String code}) async {
    try {
      final response = await this.put(
        GroupPath.joinGroupByCode,
        data: {
          'code': code,
        },
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );
      if (response.statusCode == 200) {
        return JoinTeamState.success;
      }
      ResponeJoinGroupCodeError data =
          ResponeJoinGroupCodeError.fromJson(response);
      return onErrorJoinGroup(
        errorDetail: data.errorDetail,
        statusCode: response.statusCode,
      );
    } on DioError catch (err) {
      if (err.response.data is String &&
          !StringUtil.isEmpty(err.response.data)) {
        final httBody = err.response.data['error_lifestyle_json']['http_body'];

        final Map<String, dynamic> data = json.decode(httBody);
        final rs = ResponeJoinGroupCodeError.fromJson(data);
        final httpStatusCode =
            err.response.data['error_lifestyle_json']['http_status_code'];
        return onErrorJoinGroup(
          errorDetail: rs.errorDetail,
          statusCode: httpStatusCode,
        );
      }
      return JoinTeamState.error;
    } catch (error) {
      print(error);
    }
    return JoinTeamState.notFound;
  }

  JoinTeamState onErrorJoinGroup({
    @required int statusCode,
    @required String errorDetail,
  }) {
    switch (statusCode) {
      case 200:
        return JoinTeamState.success;
        break;

      case 400:
        if (errorDetail == 'group_is_joined' ||
            errorDetail == 'group_requested') {
          return JoinTeamState.success;
        }
        if (errorDetail == 'group_not_exists') {
          return JoinTeamState.notFound;
        }
        if (errorDetail == 'group_is_full') {
          return JoinTeamState.isFull;
        }
        if (errorDetail == 'group_not_available') {
          return JoinTeamState.cannotJoin;
        }
        break;
    }
    return JoinTeamState.notFound;
  }

  Future<bool> putGroupRemoveMember(
      {@required String userID, @required String groupID}) async {
    try {
      final url = GroupPath.baseUrl + groupID + '/remove/';
      print(
          "[PUT]: removeUser url: $url \n userID: $userID \t groupID: $groupID ");

      List<String> ids = [userID].toList();
      RemoveUserModel model = RemoveUserModel(users: ids);
      final response = await this.put(url, data: model.toJson());
      return response.statusCode == 200;
    } on DioError catch (e) {
      print("[PUT]: removeUser url:$url \t response ${e.response.data} ");
    }
    return false;
  }

  /*User hủy yêu cầu tham gia đội chạy của mình */
  Future<bool> putCancelRequestJoinTeam({@required String requestID}) async {
    try {
      final response =
          await this.put(RunPath.putCancelJoinTeam + requestID + '/',
              data: {
                'status': 2,
              },
              options: Options(contentType: Headers.formUrlEncodedContentType));

      return response.statusCode == 200;
    } on DioError catch (e) {
      errorLog('deleteMyGroup', e.toString());
      return false;
    }
  }

  //Owner xóa đội chạy

  Future<bool> deleteMyGroup({@required String id}) async {
    try {
      final response = await this.delete(
        GroupPath.deleteAGroup + id + '/destroy/',
      );

      return response.statusCode == 200;
    } on DioError catch (e) {
      errorLog('deleteMyGroup', e.toString());
    }
    return false;
  }

  void errorLog(String functionName, String content) {
    print('[*** GroupAPI] $functionName \t $content');
  }
}
