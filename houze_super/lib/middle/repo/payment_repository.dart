import 'package:houze_super/middle/api/payment_api.dart';
import 'package:houze_super/middle/model/page_model.dart';
import 'package:houze_super/middle/model/payment_bank_transfer_model.dart';
import 'package:houze_super/middle/model/payment_gateway_model.dart';
import 'package:houze_super/middle/model/payment_history_model.dart';
import 'package:houze_super/middle/model/payment_model.dart';

class PaymentRepository {
  final paymentAPI = new PaymentAPI();

  PaymentRepository();

  Future<List<PaymentGatewayModel>> getGateway(String buildingId) async {
    //Call Dio API
    try {
      final rs = await paymentAPI.getGateway(buildingId);
      if (rs != null) {
        return rs;
      }
      return null;
    } catch (e) {
      return throw (e.toString());
    }
  }

  Future<PageModel> getPaymentHistory(
      {String apartmentId,
      String isCreated,
      int limit,
      int offset,
      int status}) async {
    //Call Dio API
    try {
      final rs = await paymentAPI.getPaymentHistory(
          apartmentId: apartmentId,
          isCreated: isCreated,
          limit: limit,
          offset: offset,
          status: status);
      if (rs != null) {
        return rs;
      }
      return null;
    } catch (e) {
      return throw (e.toString());
    }
  }

  Future<PaymentHistoryModel> getPaymentTransactionDetail(String id) async {
    //Call Dio API
    try {
      final rs = await paymentAPI.getPaymentTransactionDetail(id);
      if (rs != null) {
        return rs;
      }
      return null;
    } catch (e) {
      return throw (e.toString());
    }
  }

  Future<PaymentModel> createFeePayment(PaymentModel paymentModel) async {
    //Call Dio API
    try {
      final rs = await paymentAPI.createFeePayment(paymentModel);
      if (rs != null) {
        return rs;
      }
      return null;
    } catch (e) {
      return throw (e.toString());
    }
  }

  Future<List<PaymentBankTransfer>> getBanks(String buildingID) async {
    try {
      final rs = await paymentAPI.getBanks(buildingID);
      return rs;
    } catch (err) {
      rethrow;
    }
  }

  Future<dynamic> getQRBank(
    String orderCodeV2,
    String bankCode,
  ) async {
    try {
      final rs = await paymentAPI.getQRBank(orderCodeV2, bankCode);
      return rs;
    } catch (err) {
      rethrow;
    }
  }

  Future<dynamic> cancelFeePayment(String id) async {
    try {
      final rs = await paymentAPI.cancelFeePayment(id);

      return rs;
    } catch (err) {
      rethrow;
    }
  }

  Future<PaymentInfoModel> getPaymentInfo(String id) async {
    try {
      final rs = await paymentAPI.getPaymentInfo(id);
      return rs;
    } catch (err) {
      rethrow;
    }
  }
}
