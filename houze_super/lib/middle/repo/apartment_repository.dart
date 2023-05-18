import 'package:houze_super/middle/api/apartment_api.dart';
import 'package:houze_super/middle/model/apartment_model.dart';
import 'package:houze_super/utils/string_util.dart';

class ApartmentRepository {
  final apartmentAPI = ApartmentAPI();

  Future<List<ApartmentMessageModel>> getApartments(
      {String buildingId, int page = 1}) async {
    //Call Dio API
    if (StringUtil.isEmpty(buildingId)) {
      final rs = await apartmentAPI.getApartments();
      return rs;
    }

    return await apartmentAPI.getApartments(buildingId: buildingId);
  }

  Future<ApartmentDetailModel> getApartmentByID({String id}) async {
    //Call Dio API
    final rs = await apartmentAPI.getApartmentByID(id: id);
    return rs;
  }
}
