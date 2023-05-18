import 'package:dio/dio.dart';
import 'package:houze_super/middle/model/fee/fee_model.dart';
import 'package:houze_super/middle/model/page_model.dart';
import 'package:houze_super/middle/model/payment_bank_transfer_model.dart';
import 'package:houze_super/middle/model/payment_gateway_model.dart';
import 'package:houze_super/middle/model/payment_history_model.dart';
import 'package:houze_super/middle/model/payment_model.dart';
import 'package:houze_super/middle/model/result_error.dart';
import 'package:houze_super/utils/index.dart';

import 'oauth_api.dart';

abstract class PaymentApi extends OauthAPI {
  PaymentApi() : super(FeeV1Path.getFee);
  Future<List<PaymentGatewayModel>> getGateway(String buildingId);
  Future<PageModel> getPaymentHistory({
    required int page,
    String? apartmentId,
    String? isCreated,
    int? limit,
    int? offset,
    int? status,
  });
  Future<PaymentHistoryModel> getPaymentTransactionDetail(String id);
  Future<PaymentModel> createFeePayment(PaymentModel paymentModel);
  Future<PaymentInfoModel> getPaymentInfo(String id);
  Future<List<PaymentBankTransfer>> getBanks(String buildingId);
  Future<bool> cancelFeePayment(String id);
  Future<dynamic> getQRBank(
    String orderCodeV2,
    String bankCode,
  );
  Future<List<FeeGroupByApartments>> getFeeGroupByApartment(
      {required int status});
}

class PaymentAPI extends PaymentApi {
  PaymentAPI();

  @override
  Future<bool> cancelFeePayment(String id) async {
    final Response response =
        await this.put(FeeV1Path.baseCitizenUrlCancelFeePayment + "$id/");
    if (response.statusCode == 200) {
      AppController().updateOrderPage();
      if (response.data.isNotEmpty) {
        return response.data['citizen_json'] == 'Cancel successful' ||
            (response.data['citizen_json'] as String).contains('successful');
      } else {
        throw ErrorEmptyResponse();
      }
    } else {
      throw ErrorGettingResponseData('Error cancelFeePayment');
    }
  }

  @override
  Future<PaymentModel> createFeePayment(PaymentModel paymentModel) async {
    try {
      final Response response = await this
          .post(FeeV1Path.createFeePayment, data: paymentModel.toJson());

      return PaymentModel.fromJson(response.data);
    } on DioError catch (e) {
      print(e.toString());
      print(paymentModel.toJson());
      throw ("Loại thanh toán này đang bảo trì");
    }
  }

  @override
  Future<List<PaymentBankTransfer>> getBanks(String buildingId) async {

    final response = await this.get(
        FeeV1Path.basePaymentUrlBankTransfer + "?organization_id=$buildingId");

    if (response.statusCode == 200) {
      if (response.data.isNotEmpty) {
        return (response.data["payment_json"] as List)
            .map((e) => PaymentBankTransfer.fromJson(e))
            .toList();
      } else {
        throw ErrorEmptyResponse();
      }
    } else {
      throw ErrorGettingResponseData('Error getBanks');
    }
    // } catch (err) {
    //   rethrow;
    // }
  }

  @override
  Future<PageModel> getPaymentHistory(
      {int? page,
      String? apartmentId,
      String? isCreated,
      int? limit,
      int? offset,
      int? status}) async {
    int _limit = page == null ? (limit ?? 5) : AppConstant.limitDefault;
    int _offset =
        page == null ? offset ?? 0 : (page * AppConstant.limitDefault);
    final params = {
      'apartment_id': apartmentId ?? "",
      "limit": _limit,
      "offset": _offset,
    };

    if (status != null && status > -1) params['status'] = status;

    // try {
    final response =
        await this.get(FeeV1Path.paymentHistory, queryParameters: params);

    if (response.statusCode == 200) {
      if (response.data.isNotEmpty) {
        return PageModel.fromJson(response.data);
      } else {
        throw ErrorEmptyResponse();
      }
    } else {
      throw ErrorGettingResponseData('Error getPaymentHistory');
    }
    // } on DioError catch (err) {
    //   if (err.error is String) {
    //     final Map<String, dynamic> data = json.decode(err.error);

    //     return PageModel.fromJson(data);
    //   } else
    //     rethrow;
    // }
  }

  @override
  Future<PaymentInfoModel> getPaymentInfo(String id) async {
    // try {
    final response = await this.get(FeeV1Path.paymentHistory + id + '/');

    if (response.statusCode == 200) {
      if (response.data.isNotEmpty) {
        final PaymentHistoryModel paymentHistory =
            PaymentHistoryModel.fromJson(response.data);
        return PaymentInfoModel(
          amount: int.parse(paymentHistory.amount!),
          orderCodeV2: paymentHistory.orderCodeV2!,
        );
      } else {
        throw ErrorEmptyResponse();
      }
    } else {
      throw ErrorGettingResponseData('Error getPaymentInfo');
    }
    // } catch (err) {
    //   rethrow;
    // }
  }

  @override
  Future<PaymentHistoryModel> getPaymentTransactionDetail(String id) async {
    // try {
    final response = await this.get("${FeeV1Path.paymentHistory}$id\/");

    if (response.statusCode == 200) {
      if (response.data.isNotEmpty) {
        return PaymentHistoryModel.fromJson(response.data);
      } else {
        throw ErrorEmptyResponse();
      }
    } else {
      throw ErrorGettingResponseData('Error getPaymentTransactionDetail');
    }
    // } catch (err) {
    //   // if (err.error is String) {
    //   //   final Map<String, dynamic> data = json.decode(err.error);

    //   //   return PaymentHistoryModel.fromJson(data);
    //   // } else
    //   rethrow;
    // }
  }

  @override
  Future getQRBank(String orderCodeV2, String bankCode) async {
    // try {
    final response = await this.get(
        FeeV1Path.basePaymentUrlBankTransfer + "/$orderCodeV2?bank=$bankCode");

    if (response.statusCode == 200) {
      if (response.data.isNotEmpty) {
        return response.data;
      } else {
        throw ErrorEmptyResponse();
      }
    } else {
      throw ErrorGettingResponseData('Error getQRBank');
    }
    // } catch (err) {
    //   rethrow;
    // }
  }

  @override
  Future<List<PaymentGatewayModel>> getGateway(String buildingId) async {
    final response = await this.get(PaymentPath.getGateways + buildingId + "/");

    if (response.statusCode == 200) {
      if (response.data.isNotEmpty) {
        return (response.data['payment_json'] as List).map((i) {
          return PaymentGatewayModel.fromJson(i);
        }).toList();
      } else {
        throw ErrorEmptyResponse();
      }
    } else {
      throw ErrorGettingResponseData('Error getGateway');
    }
  }

  @override
  Future<List<FeeGroupByApartments>> getFeeGroupByApartment(
      {required int status}) async {
    final Response response = await this.get(
      FeeV1Path.getFeeGroupByApartment,
      queryParameters: {"status": status},
    );

    if (response.statusCode == 200) {
      if (response.data.isNotEmpty) {
        return (response.data['citizen_json'] as List)
            .map((i) => FeeGroupByApartments.fromJson(i))
            .toList();
      } else {
        throw ErrorEmptyResponse();
      }
    } else {
      throw ErrorGettingResponseData('Error getGateway');
    }
  }

  // /* Danh sách API gateway */
  // Future<List<PaymentGatewayModel>> getGateway(String buildingId) async {
  //   final response = await this.get(PaymentPath.getGateways + buildingId + "/");

  //   return (response.data['payment_json'] as List).map((i) {
  //     return PaymentGatewayModel.fromJson(i);
  //   }).toList();
  // }

  // Future<PageModel> getPaymentHistory({
  //   String? apartmentId,
  //   String? isCreated,
  //   int? limit,
  //   int? offset,
  //   int? status,
  // }) async {
  //   final params = {
  //     'apartment_id': apartmentId ?? "",
  //     'limit': limit,
  //     'offset': offset
  //   };

  //   if (status != null && status > -1) params['status'] = status;

  //   try {
  //     final response =
  //         await this.get(FeeV1Path.paymentHistory, queryParameters: params);

  //     return PageModel.fromJson(response.data);
  //   } on DioError catch (err) {
  //     if (err.error is String) {
  //       final Map<String, dynamic> data = json.decode(err.error);

  //       return PageModel.fromJson(data);
  //     } else
  //       rethrow;
  //   }
  // }

  // Future<PaymentHistoryModel> getPaymentTransactionDetail(String id) async {

  // }

  // Future<PaymentModel> createFeePayment(PaymentModel paymentModel) async {

  // }

  // Future<List<PaymentBankTransfer>> getBanks(String buildingId) async {

  // }

  // Future<PaymentInfoModel> getPaymentInfo(String id) async {

  // }

  // Future<dynamic> getQRBank(
  //   String orderCodeV2,
  //   String bankCode,
  // ) async {

  // }

  // Future<dynamic> cancelFeePayment(String id) async {

  // }
}
