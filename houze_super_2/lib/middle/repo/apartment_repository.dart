import 'package:houze_super/middle/api/apartment_api.dart';
import 'package:houze_super/middle/model/apartment_model.dart';

class ApartmentRepository {
  final apartmentAPI = ApartmentAPI();

  Future<List<ApartmentMessageModel>> getApartments(
      {required String buildingId, int page = 1}) async {
    return await apartmentAPI.getApartments(buildingId: buildingId);
  }

  Future<ApartmentDetailModel> getApartmentByID({required String id}) async {
    //Call Dio API
    final rs = await apartmentAPI.getApartmentByID(id: id);
    return rs;
  }

  Future<ApartmentAccModel> getApartmentAccByID({required String id}) async {
    //Call Dio API
    final rs = await apartmentAPI.getApartmentAccByID(id: id);
    return rs;
  }
}
