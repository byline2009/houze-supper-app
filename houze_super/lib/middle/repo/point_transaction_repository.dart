import 'package:houze_super/middle/api/point_transaction_api.dart';
import 'package:houze_super/middle/model/houze_point/point_transaction_history_model.dart';

class PointTransationRepository {
  PointTransationHistoryAPI api = PointTransationHistoryAPI();
  Future<List<PointTransationHistoryModel>> getPointTransactionHistory(
      {String buildingId,
      String action,
      int offset = 0,
      int limit = 5,
      String date}) async {
    final result = await api.getPointTransactionHistory(
        action: action, limit: limit, offset: offset, date: date);
    if (result != null) {
      return (result.results as List)
          .map((e) => PointTransationHistoryModel.fromJson(e))
          .toList();
    }
    return null;
  }

  Future<TotalPointModel> getTotalPoint() async {
    final result = await api.getTotalPoint();
    if (result != null) {
      return result;
    }
    return null;
  }
}
