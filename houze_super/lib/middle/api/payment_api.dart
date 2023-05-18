import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:houze_super/middle/model/page_model.dart';
import 'package:houze_super/middle/model/payment_bank_transfer_model.dart';
import 'package:houze_super/middle/model/payment_gateway_model.dart';
import 'package:houze_super/middle/model/payment_history_model.dart';
import 'package:houze_super/middle/model/payment_model.dart';
import 'package:houze_super/utils/constants/constants.dart';

import 'oauth_api.dart';

class PaymentAPI extends OauthAPI {
  PaymentAPI() : super(null);

  /* Danh sách API gateway */
  Future<List<PaymentGatewayModel>> getGateway(String buildingId) async {
    final response = await this.get(PaymentPath.getGateways + buildingId + "/");

    return (response.data['payment_json'] as List).map((i) {
      return PaymentGatewayModel.fromJson(i);
    }).toList();
  }

  Future<PageModel> getPaymentHistory({
    String apartmentId,
    String isCreated,
    int limit,
    int offset,
    int status,
  }) async {
    final params = {
      'apartment_id': apartmentId ?? "",
      'limit': limit,
      'offset': offset
    };

    if (status != null && status > -1) params['status'] = status;

    try {
      final response =
          await this.get(FeeV1Path.paymentHistory, queryParameters: params);

      return PageModel.fromJson(response.data);
    } catch (err) {
      if (err.error is String) {
        final Map<String, dynamic> data = json.decode(err.error);

        return PageModel.fromJson(data);
      } else
        rethrow;
    }
  }

  Future<PaymentHistoryModel> getPaymentTransactionDetail(String id) async {
    try {
      final response = await this.get("${FeeV1Path.paymentHistory}$id\/");

      return PaymentHistoryModel.fromJson(response.data);
    } catch (err) {
      if (err.error is String) {
        final Map<String, dynamic> data = json.decode(err.error);

        return PaymentHistoryModel.fromJson(data);
      } else
        rethrow;
    }
  }

  Future<PaymentModel> createFeePayment(PaymentModel paymentModel) async {
    try {
      final response = await this
          .post(FeeV1Path.createFeePayment, data: paymentModel.toJson());

      return PaymentModel.fromJson(response.data);
    } on DioError catch (e) {
      print(e.toString());
      print(paymentModel.toJson().toString());
      throw ("Loại thanh toán này đang bảo trì");
    }
  }

  Future<List<PaymentBankTransfer>> getBanks(String buildingId) async {
    try {
      final response = await this.get(FeeV1Path.basePaymentUrlBankTransfer +
          "?organization_id=$buildingId");

      return (response.data["payment_json"] as List)
          .map((e) => PaymentBankTransfer.fromJson(e))
          .toList();
    } catch (err) {
      rethrow;
    }
  }

  Future<PaymentInfoModel> getPaymentInfo(String id) async {
    try {
      final response = await this.get(FeeV1Path.paymentHistory + id + '/');

      final PaymentHistoryModel paymentHistory =
          PaymentHistoryModel.fromJson(response.data);

      return PaymentInfoModel(
        amount: int.parse(paymentHistory.amount),
        orderCodeV2: paymentHistory.orderCodeV2,
      );
    } catch (err) {
      rethrow;
    }
  }

  Future<dynamic> getQRBank(
    String orderCodeV2,
    String bankCode,
  ) async {
    try {
      final response = await this.get(FeeV1Path.basePaymentUrlBankTransfer +
          "/$orderCodeV2?bank=$bankCode");

      return response.data;
    } catch (err) {
      rethrow;
    }
  }

  Future<dynamic> cancelFeePayment(String id) async {
    try {
      final response =
          await this.put(FeeV1Path.baseCitizenUrlCancelFeePayment + "$id/");

      return response.data;
    } catch (err) {
      rethrow;
    }
  }
}
