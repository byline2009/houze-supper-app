import 'dart:io';

import 'package:houze_super/middle/api/run_api.dart';

import 'package:houze_super/middle/model/run/run_lifestyle_model.dart';
import 'package:houze_super/presentation/screen/community/run/group/index.dart';

class GroupRepository {
  GroupRepository();

  final api = GroupAPI();

  Future<ActivityModel> startActivity(Map<String, dynamic> args) async {
    try {
      final result = await api.startActivity(args);

      return result;
    } catch (err) {
      print(err.toString());
      rethrow;
    }
  }

  Future<ActivityUpdate> finishActivity(String activityId) async {
    try {
      final result = await api.updateActivity(activityId);

      return result;
    } catch (err) {
      print(err.toString());
      rethrow;
    }
  }

  Future<String> uploadActivityFile({
    required String activityId,
    required File file,
    String? broadcastOrganization,
  }) async {
    try {
      final result = await api.uploadActivityFile(
          activityId: activityId,
          file: file,
          broadcastOrganization: broadcastOrganization);

      return result;
    } catch (err) {
      rethrow;
    }
  }

  Future<List<GroupModel>> getAllGroup(
      {required int page, required String eventID}) async {
    final rs = await api.getAllGroup(
      page: page,
      eventID: eventID,
    );
    return (rs.results as List).map((i) {
      return GroupModel.fromJson(i);
    }).toList();
  }

  Future<GroupModel> createNewGroup({
    required String name,
    required String eventID,
  }) async {
    return await api.createNewGroup(
      name: name,
      eventId: eventID,
    );
  }

  Future<List<RequestModel>> getEventsRequest({required String groupID}) async {
    final rs = await api.getEventsRequest(groupID: groupID);
    return (rs.results as List).map((i) {
      return RequestModel.fromJson(i);
    }).toList();
  }

  Future<bool> putConfirmRequestJoinTeam({
    required TypeRequestEvent type,
    required String requestID,
  }) async {
    return await api.putConfirmRequestJoinTeam(
        type: type, requestID: requestID);
  }

  Future<JoinTeamState> joinGroupByCode({
    required String code,
  }) async {
    return await api.putJoinGroupByCode(code: code);
  }

  Future<bool> putGroupRemoveMember({
    required String userID,
    required String groupID,
  }) async {
    final rs = await api.putGroupRemoveMember(userID: userID, groupID: groupID);
    return rs;
  }

  Future<bool> putCancelRequestJoinTeam({required String requestID}) async {
    final rs = await api.putCancelRequestJoinTeam(requestID: requestID);
    return rs;
  }

  Future<bool> deleteMyGroup({required String id}) async {
    final rs = await api.deleteMyGroup(id: id);
    return rs;
  }
}
