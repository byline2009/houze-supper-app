import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:houze_super/middle/api/oauth_api.dart';
import 'package:houze_super/middle/model/agent_model.dart';
import 'package:houze_super/middle/model/page_model.dart';
import 'package:houze_super/middle/model/image_model.dart';
import 'package:houze_super/utils/constant/index.dart';

class AgentAPI extends OauthAPI {
  AgentAPI() : super('');

  Future<ImageModel> uploadAuthenticationImage(File image) async {
    try {
      FormData formData = FormData.fromMap({
        "image": MultipartFile.fromFileSync(
          image.path,
          filename: image.path.split('/').last,
        )
      });

      final options =
          Options(sendTimeout: 30 * 1000, receiveTimeout: 30 * 1000);

      final response = await this.post(
        APIConstant.postApartmentImageAuthenticate,
        data: formData,
        options: options,
      );

      final rs = ImageModel.fromJson(response.data);
      debugPrint("Image with id: ${rs.id}");
      return rs;
    } on DioError catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<ImageModel> uploadImage(File image) async {
    try {
      FormData formData = FormData.fromMap({
        "image": MultipartFile.fromFileSync(
          image.path,
          filename: image.path.split('/').last,
        )
      });

      final options =
          Options(sendTimeout: 30 * 1000, receiveTimeout: 30 * 1000);

      final response = await this.post(
        APIConstant.postApartmentImage,
        data: formData,
        options: options,
      );

      final rs = ImageModel.fromJson(response.data);
      debugPrint("Image with id: ${rs.id}");
      return rs;
    } on DioError catch (e) {
      debugPrint(e.message);
      rethrow;
    }
  }

  Future hideAgentResell({required String id}) async {
    final response = await this.patch(APIConstant.patchApartmentResell + id,
        data: {"status_posted": 1});
    return response;
  }

  Future<PageModel> getResellList({String buildingId = "", int? page}) async {
    try {
      final response = await this.get(
        APIConstant.apartmentResell,
        queryParameters: {
          "building_id": buildingId,
          "limit": AppConstant.limitDefault,
          "offset": page! * AppConstant.limitDefault,
        },
      );

      return PageModel.fromJson(response.data);
    } on DioError catch (err) {
      if (err.response!.statusCode == 403) {
        rethrow;
      }
      if (err.error is String) {
        final Map<String, dynamic> data = json.decode(err.error);
        return PageModel.fromJson(data);
      } else
        rethrow;
    }
  }

  Future<SellModel> getResellDetail({String detailId = ""}) async {
    try {
      final response = await this.get(
        APIConstant.getApartmentResellDetail + detailId,
      );

      return SellModel.fromJson(response.data);
    } on DioError catch (err) {
      if (err.error is String) {
        final Map<String, dynamic> data = json.decode(err.error);

        return SellModel.fromJson(data);
      } else
        rethrow;
    }
  }

  Future<SellTicketModel> updateTicket(
      String id, SellTicketModel ticket) async {
    try {
      final json = ticket.toJsonRemoveImageThumb();
      debugPrint(json.toString());
      final response =
          await this.patch(APIConstant.patchApartmentResell + id, data: json);
      if (response.statusCode != 200) throw ('updateTicket failure');
      return SellTicketModel.fromJson(response.data);
    } catch (err) {
      rethrow;
    }
  }

  Future<SellTicketModel> sendTicket(SellTicketModel ticket) async {
    try {
      final json = ticket.toJsonRemoveImageThumb();
      final response = await this.post(APIConstant.apartmentResell, data: json);
      return SellTicketModel.fromJson(response.data);
    } on DioError catch (_) {
      rethrow;
    }
  }
}
