import 'package:houze_super/middle/api/payment_api.dart';
import 'package:houze_super/middle/model/fee/fee_model.dart';
import 'package:houze_super/middle/model/page_model.dart';
import 'package:houze_super/middle/model/payment_bank_transfer_model.dart';
import 'package:houze_super/middle/model/payment_gateway_model.dart';
import 'package:houze_super/middle/model/payment_history_model.dart';
import 'package:houze_super/middle/model/payment_model.dart';

class PaymentRepository {
  const PaymentRepository({
    required this.api,
  });
  final PaymentAPI api;

  Future<List<FeeGroupByApartments>> getFeeGroupByApartment() async =>
      api.getFeeGroupByApartment(status: 1);

  Future<List<PaymentGatewayModel>> getGateway(String buildingId) async =>
      api.getGateway(buildingId);

  Future<PageModel> getPaymentHistory(
          {String? apartmentId,
          String? isCreated,
          int? limit,
          int? offset,
          int? page,
          int? status}) async =>
      api.getPaymentHistory(
          apartmentId: apartmentId,
          isCreated: isCreated,
          page: page,
          limit: limit,
          offset: offset,
          status: status);

  Future<PaymentHistoryModel> getPaymentTransactionDetail(String id) async =>
      api.getPaymentTransactionDetail(id);

  Future<PaymentModel> createFeePayment(PaymentModel paymentModel) async =>
      await api.createFeePayment(paymentModel);
  Future<List<PaymentBankTransfer>> getBanks(String buildingId) async =>
      api.getBanks(buildingId);

  Future<dynamic> getQRBank(
    String orderCodeV2,
    String bankCode,
  ) async =>
      getQRBank(orderCodeV2, bankCode);

  Future<bool> cancelFeePayment(String id) async => api.cancelFeePayment(id);
  Future<dynamic> getPaymentInfo(String id) async => api.getPaymentInfo(id);
}
