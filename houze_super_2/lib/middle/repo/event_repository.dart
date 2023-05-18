import 'package:houze_super/middle/api/event_api.dart';
import 'package:houze_super/presentation/screen/community/run/challenge/model/event_model.dart';

class EventRepository {
  EventRepository();

  final api = EventAPI();
  Future<List<EventModel>> getAllEvent(
      {required int page, required String buildingID}) async {
    final rs = await api.getAllEvent(page: page, buildingID: buildingID);
    return (rs.results as List).map((i) {
      return EventModel.fromJson(i);
    }).toList();
  }

  Future<EventModel> getEventDetail({required String id}) async {
    final rs = await api.getEventByID(id: id);
    return rs;
  }
}
