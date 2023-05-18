import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:houze_super/middle/api/oauth_api.dart';
import 'package:houze_super/middle/model/ticket_model.dart';
import 'package:houze_super/utils/constants/constants.dart';

class TicketAPI extends OauthAPI {
  TicketAPI() : super(TicketPath.ticketBase);

  Future<TicketModel> sendTicket(TicketModel ticket) async {
    var response;
    try {
      if (ticket.videoUrl != null) {
        response =
            await this.post(TicketPath.postTicket, data: ticket.toJson());
      } else {
        response = await this
            .post(TicketPath.postTicket, data: ticket.toJsonWithoutVideoUrl());
      }
      return TicketModel.fromJson(response.data);
    } on DioError catch (e) {
      print(e.toString());
      throw ("Dữ liệu không hợp lệ");
    }
  }

  Future<RatingModel> sendRatingReview(RatingModel rating) async {
    try {
      final response = await this
          .post(TicketPath.ticketBase + "rating/", data: rating.toJson());

      return RatingModel.fromJson(response.data);
    } on DioError catch (e) {
      print(e.message.toUpperCase());
      throw ("Dữ liệu không hợp lệ");
    }
  }

  Future<TicketDetailModel> getTicketByID(String id) async {
    try {
      final response = await this.get(this.baseUrl + "$id/");
      if (response.data['assignee'] != null) {
        print(response.data['assignee']);
      }
      return TicketDetailModel.fromJson(response.data);
    } catch (err) {
      if (err.error is String) {
        final Map<String, dynamic> data = json.decode(err.error);

        return TicketDetailModel.fromJson(data);
      }
      rethrow;
    }
  }
}
