import 'dart:convert';

import 'package:houze_super/presentation/screen/community/conversation/forum/polls/models/poll_model.dart';
import 'package:houze_super/presentation/screen/community/conversation/forum/polls/models/user_permission_model.dart';
import 'package:houze_super/presentation/screen/community/conversation/forum/polls/networking/poll_api.dart';

class PollRepository {
  PollApi _api = PollApi();
  Future<List<PollModel>> getPolls({int offset = 0, int limit = 5}) async {
    final result = await _api.getPolls(offset: offset, limit: limit);
    if (result != null) {
      return (result.results as List)
          .map((e) => PollModel.fromJson(e))
          .toList();
    }
    return null;
  }

  Future<List<VotingModel>> getVoting(
      {int offset = 0, int limit = 5, String id}) async {
    final result = await _api.getVoting(offset: offset, limit: limit, id: id);
    if (result != null) {
      return (result.results as List)
          .map((e) => VotingModel.fromJson(e))
          .toList();
    }
    return null;
  }

  Future<VotingModel> sendVote({String userChoiceID, String choiceID}) async {
    final result =
        await _api.sendVote(userChoiceID: userChoiceID, choiceID: choiceID);
    if (result != null) {
      return result;
    }
    return null;
  }

  Future<UserPermission> getUserPermission() async {
    final result = await _api.getUserPermission();
    if (result != null) {
      print(json.encode(result));
      return result;
    }
    return null;
  }
}
