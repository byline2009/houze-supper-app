import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:houze_super/middle/api/oauth_api.dart';
import 'package:houze_super/middle/model/page_model.dart';
import 'package:houze_super/middle/model/fee_model.dart';
import 'package:houze_super/utils/constant/index.dart';

class FeeAPI extends OauthAPI {
  FeeAPI() : super(null);

  Future<List<FeeMessageModel>> getFeesListWithType({
    String building = "",
    String apartment = "",
    List<int>? types,
    int? status,
  }) async {
    final List<String> _type = [];
    types!.forEach((val) {
      _type.add("type=$val");
    });

    final url = FeeV1Path.getFeeList +
        "?building=$building&apartment=$apartment&status=$status&${_type.join("&")}";

    try {
      final response = await this.get(url);

      return (response.data['citizen_json'] as List)
          .map((i) => FeeMessageModel.fromJson(i))
          .toList();
    } catch (err) {
      rethrow;
    }
  }

  Future<List<FeeByMonth>> getFeeChart({
    String building: '',
    String apartment: '',
    required int feeType,
    int? year,
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
      if (response.statusCode == 200) {
        return (response.data as List)
            .map((e) => FeeByMonth.fromJson(e))
            .toList();
      }
      throw Exception('Failed to load fee');
    } catch (err) {
      // if (err.error is String) {
      //   print(err.error);
      //   final List<dynamic> data = json.decode(err.error);

      //   return data.map((e) => FeeByMonth.fromJson(e)).toList();
      // } else
      rethrow;
    }
  }

  Future<PageModel> getFeeList({
    String building: '',
    String apartment: '',
    required int feeType,
    required int page,
    int? year,
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

      return response.statusCode == 200
          ? PageModel.fromJson(response.data)
          : throw Exception('Failed to load fee');
    } catch (err) {
      // if (err.error is String) {
      //   final Map<String, dynamic> data = json.decode(err.error);

      //   return PageModel.fromJson(data);
      // } else
      rethrow;
    }
  }

  Future<List<FeeDetailMessageModel>> getFeeLimitList({
    required String building,
    required String apartment,
    required int feeType,
    int? limit,
    int? year,
  }) async {
    try {
      final response = await this.get(
        FeeV1Path.getFee,
        queryParameters: {
          "building": building,
          "apartment": apartment,
          "type": feeType,
          "year": year,
          "limit": limit,
        },
      );
      if (response.statusCode == 200) {
        final rs = PageModel.fromJson(response.data);

        return (rs.results as List)
            .map((e) => FeeDetailMessageModel.fromJson(e))
            .toList();
      }
      throw Exception('Failed to load fee');
    } catch (err) {
      // if (err.error is String) {
      //   final Map<String, dynamic> data = json.decode(err.error);

      //   return PageModel.fromJson(data);
      // } else
      rethrow;
    }
  }

  // Future<List<FeeGroupByApartments>> getFeeGroupByApartment(
  //     {int? status}) async {
  //   try {
  //     final response = await this.get(
  //       FeeV1Path.getFeeGroupByApartment,
  //       queryParameters: {"status": status},
  //     );

  //     return (response.data['citizen_json'] as List)
  //         .map((i) => FeeGroupByApartments.fromJson(i))
  //         .toList();
  //   } catch (err) {
  //     rethrow;
  //   }
  // }

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
          "building": building,
          "apartment": apartment,
          "type": type,
          "status": status,
        },
      );

      return response.statusCode == 200
          ? (response.data['citizen_json'] as List).map((i) {
              return FeeMessageModel.fromJson(i);
            }).toList()
          : throw Exception('Failed to load fee');
    } on DioError catch (error) {
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
    int? page,
    String building = "",
    String apartment = "",
    dynamic type,
    dynamic status,
    dynamic year,
  }) async {
    final limit = 10;

    try {
      final response = await this.get(
        FeeV1Path.getFee,
        queryParameters: {
          "building": building,
          "apartment": apartment,
          "type": type ?? "",
          "status": status ?? "",
          "year": year ?? "",
          "limit": limit,
          "offset": (page! - 1) * limit, //limit 10
        },
      );
      if (response.statusCode == 200) return PageModel.fromJson(response.data);
      throw Exception('Failed to load fee');
    } catch (err) {
      // if (err.error is String) {
      //   final Map<String, dynamic> data = json.decode(err.error);

      //   return PageModel.fromJson(data);
      // }

      rethrow;
    }
  }

  Future<FeeTotalModel> getFeeTotal(
      {String type = "",
      String status = "",
      String building = "",
      String apartment = ""}) async {
    final response = await this.get(FeePath.getFeeTotal, queryParameters: {
      "building": building,
      "apartment": apartment,
      "type": type,
      "status": status, //limit 10
    });
    return response.statusCode == 200
        ? FeeTotalModel.fromJson(response.data)
        : throw Exception('Failed to load fee total');
  }

  Future<String> getFeeDetail({
    String? feeId,
    String? token,
    String locale = "",
  }) async {
    try {
      final String url = FeePath.feeDetail + feeId! + '/';
      final response = await this.get(
        url,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Accept-Language": locale
          },
        ),
      );

      return response.statusCode == 200
          ? response.data
          : throw Exception('Failed to load fee detail');
    } catch (err) {
      // if (err.error is String) {
      //   final String data = json.decode(err.error);

      //   return data;
      // }

      rethrow;
    }
  }

  Future<String> getReceiptDetail(
      {String? receiptId, String token = "", String locale = ""}) async {
    String url = FeePath.getReceiptDetail + receiptId! + '/';
    final response = await this.get(url);

    return response.statusCode == 200
        ? response.data
        : throw Exception('Failed to load receipt detail');
  }
}
