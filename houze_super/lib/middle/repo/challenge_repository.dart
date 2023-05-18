import 'package:flutter/material.dart';
import 'package:houze_super/middle/api/challenge_api.dart';
import 'package:houze_super/presentation/screen/community/run/challenge/model/event_model.dart';

class ChallengeRepository {
  ChallengeRepository();

  final api = ChallengeAPI();
  Future<List<EventModel>> getAllEvent({
    @required int page,
    @required String buildingID,
  }) async {
    final rs = await api.getAllEvent(
      page: page,
      buildingID: buildingID,
    );
    if (rs != null) {
      return (rs.results as List).map((i) {
        return EventModel.fromJson(i);
      }).toList();
    }
    return null;
  }

  Future<EventModel> getEventDetail({
    @required String id,
  }) async {
    final rs = await api.getEventByID(id: id);
    if (rs != null) {
      return rs;
    }
    return null;
  }
}
