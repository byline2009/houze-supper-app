import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:houze_super/presentation/screen/community/run/statistic/index.dart';
import 'package:houze_super/presentation/screen/community/run/statistic/model/distace_lastest_model.dart';
import 'package:houze_super/utils/constant/index.dart';

import '../../presentation/screen/community/run/statistic/blocs/bloc/statistics_by_year_bloc.dart';
import 'oauth_api.dart';

class StatisticApi extends OauthAPI {
  StatisticApi() : super(RunPath.getStatisticOverview);

  Future<StatisticOverviewModel> getStatisticOverViewByYear({
    required int year,
  }) async {
    try {
      final url = RunPath.getStatisticOverview + year.toString() + '/';
      final response = await this.get(url);

      return response.statusCode != 200
          ? throw ('getStatisticOverViewByYear failure')
          : StatisticOverviewModel.fromJson(response.data);
    } on DioError catch (err) {
      if (err.error is String) {
        final Map<String, dynamic> data = json.decode(err.error);
        return StatisticOverviewModel.fromJson(data);
      }
      rethrow;
    } catch (error) {
      errorLog('getStatisticOverViewByYear', error.toString());
      rethrow;
    }
  }

  Future<DistanceDateModel> getDistaceLastest({
    required TypeDistanceDate type,
    required String year,
  }) async {
    try {
      String _type = '0';
      switch (type) {
        case TypeDistanceDate.months12:
          _type = '2';
          break;
        case TypeDistanceDate.weeks12:
          _type = '1';
          break;
        default:
          _type = '0';
          break;
      }

      final url = RunPath.getDistanceDate + _type + '/' + year + '/';
      final response = await this.get(url);

      return DistanceDateModel.fromJson(response.data);
    } on DioError catch (err) {
      if (err.error is String) {
        final Map<String, dynamic> data = json.decode(err.error);
        return DistanceDateModel.fromJson(data);
      } else {
        rethrow;
      }
    } catch (error) {
      errorLog('getStatisticOverViewByYear', error.toString());
      rethrow;
    }
  }

  void errorLog(String functionName, String content) {
    debugPrint('[*** StatisticApi] $functionName \t $content');
  }
}
