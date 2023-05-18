import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:houze_super/middle/api/oauth_api.dart';
import 'package:houze_super/middle/model/page_model.dart';
import 'package:houze_super/middle/model/fee/fee_model.dart';
import 'package:houze_super/middle/model/fee_model.dart';
import 'package:houze_super/utils/constants/constants.dart';

class FeeAPI extends OauthAPI {
  FeeAPI() : super(null);

  Future<List<FeeMessageModel>> getFeesListWithType({
    String building = "",
    String apartment = "",
    List<int> types,
    int status,
  }) async {
    final _type = List<String>();
    types.forEach((val) {
      _type.add("type=$val");
    });

    final url = FeeV1Path.getFeeList +
        "?building=${building ?? ""}&apartment=${apartment ?? ""}&status=$status&${_type.join("&")}";

    try {
      final response = await this.get(url);

      return (response.data['citizen_json'] as List)
          .map((i) => FeeMessageModel.fromJson(i))
          .toList();
    } catch (err) {
      if (err.error is String) {
        final Map<String, dynamic> data = json.decode(err.error);

        return (data['citizen_json'] as List)
            .map((i) => FeeMessageModel.fromJson(i))
            .toList();
      }

      rethrow;
    }
  }

  Future<List<FeeByMonth>> getFeeChart({
    String building: '',
    String apartment: '',
    @required int feeType,
    int year,
  }) async {
    try {
      final response = await this.get(
        APIConstant.getFeeByMonth,
        queryParameters: {
          'building': building,
          'apartment': apartment,
          'type': feeType,
          'year': year,
        },
      );

      return (response.data as List)
          .map((e) => FeeByMonth.fromJson(e))
          .toList();
    } catch (err) {
      if (err.error is String) {
        print(err.error);
        final List<dynamic> data = json.decode(err.error);

        return data.map((e) => FeeByMonth.fromJson(e)).toList();
      } else
        rethrow;
    }
  }

  Future<PageModel> getFeeList({
    String building: '',
    String apartment: '',
    @required int feeType,
    @required int page,
    int year,
  }) async {
    try {
      final response = await this.get(
        FeeV1Path.getFee,
        queryParameters: {
          'building': building,
          'apartment': apartment,
          'type': feeType,
          'year': year,
          "limit": 10,
          "offset": page * 10,
        },
      );

      return PageModel.fromJson(response.data);
    } catch (err) {
      if (err.error is String) {
        final Map<String, dynamic> data = json.decode(err.error);

        return PageModel.fromJson(data);
      } else
        rethrow;
    }
  }

  Future<PageModel> getFeeLimitList({
    @required String building,
    @required String apartment,
    @required int feeType,
    int limit,
    int year,
  }) async {
    try {
      final response = await this.get(
        FeeV1Path.getFee,
        queryParameters: {
          "building": building ?? "",
          "apartment": apartment ?? "",
          "type": feeType,
          "year": year,
          "limit": limit,
        },
      );

      return PageModel.fromJson(response.data);
    } catch (err) {
      if (err.error is String) {
        final Map<String, dynamic> data = json.decode(err.error);

        return PageModel.fromJson(data);
      } else
        rethrow;
    }
  }

  Future<List<FeeGroupByApartments>> getFeeGroupByApartment(
      {int status}) async {
    try {
      final response = await this.get(
        FeeV1Path.getFeeGroupByApartment,
        queryParameters: {"status": status},
      );

      return (response.data['citizen_json'] as List)
          .map((i) => FeeGroupByApartments.fromJson(i))
          .toList();
    } catch (err) {
      if (err.error is String) {
        final Map<String, dynamic> data = json.decode(err.error);

        final List<FeeGroupByApartments> results =
            (data['citizen_json'] as List)
                .map((e) => FeeGroupByApartments.fromJson(e))
                .toList();

        return results;
      } else
        rethrow;
    }
  }

  Future<List<FeeMessageModel>> getFeesList({
    String building = "",
    String apartment = "",
    dynamic type,
    dynamic status,
  }) async {
    try {
      final response = await this.get(
        FeeV1Path.getFeeList,
        queryParameters: {
          "building": building ?? "",
          "apartment": apartment ?? "",
          "type": type,
          "status": status,
        },
      );

      return (response.data['citizen_json'] as List).map((i) {
        return FeeMessageModel.fromJson(i);
      }).toList();
    } catch (error) {
      if (error.error is String) {
        final Map<String, dynamic> data = json.decode(error.error);

        final List<FeeMessageModel> feeMessages = (data['citizen_json'] as List)
            .map((e) => FeeMessageModel.fromJson(e))
            .toList();

        return feeMessages;
      }

      rethrow;
    }
  }

  Future<PageModel> getFees({
    String building = "",
    String apartment = "",
    dynamic type,
    dynamic status,
    dynamic year,
  }) async {
    try {
      final response = await this.get(
        FeeV1Path.getFee,
        queryParameters: {
          "building": building ?? "",
          "apartment": apartment ?? "",
          "type": type ?? "",
          "status": status ?? "",
          "year": year ?? "",
          "limit": 100,
          "offset": 0, //limit 10
        },
      );

      return PageModel.fromJson(response.data);
    } catch (err) {
      if (err.error is String) {
        final Map<String, dynamic> data = json.decode(err.error);

        return PageModel.fromJson(data);
      }

      rethrow;
    }
  }

  Future<FeeTotalModel> getFeeTotal(
      {String type = "",
      String status = "",
      String building = "",
      String apartment = ""}) async {
    final response = await this.get(FeePath.getFeeTotal, queryParameters: {
      "building": building ?? "",
      "apartment": apartment ?? "",
      "type": type ?? "",
      "status": status ?? "", //limit 10
    });
    return FeeTotalModel.fromJson(response.data);
  }

  Future<String> getFeeDetail({
    String feeId,
    String token,
    String locale = "",
  }) async {
    try {
      final String url = FeePath.feeDetail + feeId + '/';
      final response = await this.get(
        url,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Accept-Language": locale
          },
        ),
      );

      return response.data;
    } catch (err) {
      if (err.error is String) {
        final String data = json.decode(err.error);

        return data;
      }

      rethrow;
    }
  }

  Future<String> getReceiptDetail(
      {String receiptId, String token = "", String locale = ""}) async {
    String url = FeePath.getReceiptDetail + receiptId + '/';
    final response = await this.get(url);

    return response.data;
  }
}
