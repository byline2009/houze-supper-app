import 'package:houze_super/middle/api/fee_api.dart';
import 'package:houze_super/middle/model/page_model.dart';
import 'package:houze_super/middle/model/fee_model.dart';
import 'package:houze_super/utils/constant/index.dart';

class FeeRepository {
  final feeAPI = new FeeAPI();

  FeeRepository();

  Future<List<FeeMessageModel>> getFeesListWithType(
          {String building = "",
          String apartment = "",
          List<int>? types,
          dynamic status = ""}) async =>
      await feeAPI.getFeesListWithType(
          building: building,
          apartment: apartment,
          types: types,
          status: status);

  Future<List<FeeByMonth>> getFeeChart({
    String? building,
    String? apartment,
    required int feeType,
    int? year,
  }) async {
    final rs = await feeAPI.getFeeChart(
      building: building!,
      apartment: apartment!,
      feeType: feeType,
      year: year,
    );

    return rs;
  }

  Future<List<FeeDetailMessageModel>> getFeeLimitList({
    required String building,
    required String apartment,
    required int feeType,
    int? limit,
    int? year,
  }) async =>
      await feeAPI.getFeeLimitList(
        limit: limit,
        building: building,
        apartment: apartment,
        feeType: feeType,
        year: year,
      );

  // Future<List<FeeGroupByApartments>> getFeeGroupByApartment() async =>
  //     await feeAPI.getFeeGroupByApartment(status: 1);

  Future<List<FeeMessageModel>> getFeesList(
          {String building = "",
          String apartment = "",
          dynamic type = "",
          dynamic status = ""}) async
      //Call Dio API
      =>
      await feeAPI.getFeesList(
        building: building,
        apartment: apartment,
        type: type,
        status: status,
      );

  Future<List<FeeDetailMessageModel>> getFees(
      {int? page,
      dynamic year = "",
      String building = "",
      String apartment = "",
      dynamic type = "",
      dynamic status = ""}) async {
    //Call Dio API
    final rs = await feeAPI.getFees(
        page: page,
        year: year,
        building: building,
        apartment: apartment,
        type: type,
        status: status);
    return (rs.results as List)
        .map((e) => FeeDetailMessageModel.fromJson(e))
        .toList();
  }

  Future<List<FeeDetailMessageModel>> getAllFees(
      {required String building,
      required String apartment,
      required dynamic type,
      required dynamic status}) async {
    try {
      final response = await feeAPI.get(
        FeeV1Path.getFee,
        queryParameters: {
          "building": building,
          "apartment": apartment,
          "type": type,
          "status": status,
          "limit": 30,
        },
      );
      final pageModel = PageModel.fromJson(response.data);

      return (pageModel.results as List)
          .map((e) => FeeDetailMessageModel.fromJson(e))
          .toList();
    } catch (e) {
      throw e;
    }
  }

  Future<FeeTotalModel> getFeeTotal(
          {int? page,
          String building = "",
          String apartment = "",
          dynamic type = "",
          dynamic status = ""}) async
      //Call Dio API
      =>
      await feeAPI.getFeeTotal(
          building: building, apartment: apartment, type: type, status: status);

  Future<String> getFeeDetail(
          {String? feeId, String token = "", String locale = ""}) async
      //Call Dio API
      =>
      await feeAPI.getFeeDetail(feeId: feeId, token: token, locale: locale);

  Future<String> getReceiptDetail(
          {String? receiptId, String token = "", String locale = ""}) async
      //Call Dio API
      =>
      await feeAPI.getReceiptDetail(
          receiptId: receiptId, token: token, locale: locale);

  Future<PageModel> getFeeList({
    String? building,
    String? apartment,
    required int feeType,
    required int page,
    int? year,
  }) async =>
      await feeAPI.getFeeList(
        building: building!,
        apartment: apartment!,
        feeType: feeType,
        year: year,
        page: page,
      );
}
