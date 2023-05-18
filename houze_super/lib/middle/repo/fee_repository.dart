import 'package:flutter/material.dart';
import 'package:houze_super/middle/api/fee_api.dart';
import 'package:houze_super/middle/model/page_model.dart';
import 'package:houze_super/middle/model/fee/fee_model.dart';
import 'package:houze_super/middle/model/fee_model.dart';

class FeeRepository {
  final feeAPI = new FeeAPI();

  FeeRepository();

  Future<List<FeeMessageModel>> getFeesListWithType(
      {String building = "",
      String apartment = "",
      List<int> types,
      dynamic status = ""}) async {
    //Call Dio API
    final rs = await feeAPI.getFeesListWithType(
        building: building, apartment: apartment, types: types, status: status);
    return rs;
  }

  Future<List<FeeByMonth>> getFeeChart({
    String building,
    String apartment,
    @required int feeType,
    int year,
  }) async {
    final rs = await feeAPI.getFeeChart(
      building: building,
      apartment: apartment,
      feeType: feeType,
      year: year,
    );

    return rs;
  }

  Future<PageModel> getFeeLimitList({
    @required String building,
    @required String apartment,
    @required int feeType,
    int limit,
    int year,
  }) async {
    final rs = await feeAPI.getFeeLimitList(
      limit: limit,
      building: building,
      apartment: apartment,
      feeType: feeType,
      year: year,
    );

    return rs;
  }

  Future<List<FeeGroupByApartments>> getFeeGroupByApartment() async {
    //Status: 1 , payment not yet
    final rs = await feeAPI.getFeeGroupByApartment(status: 1);
    return rs;
  }

  Future<List<FeeMessageModel>> getFeesList(
      {String building = "",
      String apartment = "",
      dynamic type = "",
      dynamic status = ""}) async {
    //Call Dio API
    final rs = await feeAPI.getFeesList(
        building: building, apartment: apartment, type: type, status: status);
    return rs;
  }

  Future<PageModel> getFees(
      {dynamic year = "",
      String building = "",
      String apartment = "",
      dynamic type = "",
      dynamic status = ""}) async {
    //Call Dio API
    final rs = await feeAPI.getFees(
        year: year,
        building: building,
        apartment: apartment,
        type: type,
        status: status);
    return rs;
  }

  Future<FeeTotalModel> getFeeTotal({
    String building = "",
    String apartment = "",
    dynamic type = "",
    dynamic status = "",
  }) async {
    //Call Dio API
    final rs = await feeAPI.getFeeTotal(
      building: building,
      apartment: apartment,
      type: type,
      status: status,
    );
    return rs;
  }

  Future<String> getFeeDetail(
      {String feeId, String token = "", String locale = ""}) async {
    //Call Dio API
    final rs =
        await feeAPI.getFeeDetail(feeId: feeId, token: token, locale: locale);
    return rs;
  }

  Future<String> getReceiptDetail(
      {String receiptId, String token = "", String locale = ""}) async {
    //Call Dio API
    final rs = await feeAPI.getReceiptDetail(
        receiptId: receiptId, token: token, locale: locale);
    return rs;
  }

  Future<PageModel> getFeeList({
    String building,
    String apartment,
    @required int feeType,
    @required int page,
    int year,
  }) async {
    final rs = await feeAPI.getFeeList(
      building: building,
      apartment: apartment,
      feeType: feeType,
      year: year,
      page: page,
    );

    return rs;
  }
}
