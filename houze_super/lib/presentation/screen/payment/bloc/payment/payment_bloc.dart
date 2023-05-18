import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:houze_super/middle/model/payment_gateway_model.dart';
import 'package:houze_super/middle/model/payment_history_model.dart';
import 'package:houze_super/middle/repo/payment_repository.dart';
import 'package:houze_super/presentation/screen/payment/bloc/payment/payment_event.dart';
import 'package:houze_super/presentation/screen/payment/bloc/payment/payment_state.dart';
import 'package:houze_super/utils/settings/fee.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  PaymentRepository paymentRepository = new PaymentRepository();

  PaymentBloc() : super(PaymentInitial());

  @override
  Stream<PaymentState> mapEventToState(PaymentEvent event) async* {
    if (event is PaymentLoadGateway) {
      yield PaymentLoading();

      try {
        final gateWayData =
            await paymentRepository.getGateway(event.buildingId);

        List<PaymentGatewayModel> results = List<PaymentGatewayModel>();

        gateWayData.forEach((element) {
          final paymentGateway =
              FeeSettings.paymentGateways[element.gatewayName];
          if (paymentGateway != null && paymentGateway.isCheck) {
            results.add(paymentGateway);
          }
        });

        yield PaymentLoadGatewaySuccessful(
          result: results,
        );
      } catch (error) {
        yield PaymentFailure(error: error);
      }
    }

    if (event is PaymentLoadHistory) {
      yield PaymentLoading();

      try {
        final result = await paymentRepository.getPaymentHistory(
            apartmentId: event.apartmentId,
            limit: event.limit,
            status: event.status);

        final results = (result.results as List).map((i) {
          return PaymentHistoryModel.fromJson(i);
        }).toList();

        yield PaymentLoadHistorySuccessful(
            result: results, total: result.count);
      } catch (error) {
        if (error != null &&
            error.startsWith('DioError [DioErrorType.DEFAULT]')) {
          final String jsonStr = error.substring(error.indexOf('{'));

          final Map<String, dynamic> data = json.decode(jsonStr);

          final List<PaymentHistoryModel> results = (data['results'] as List)
              .map((e) => PaymentHistoryModel.fromJson(e))
              .toList();

          yield PaymentLoadHistorySuccessful(
            result: results,
            total: data['count'],
          );
        } else
          yield PaymentFailure(error: error);
      }
    }

    if (event is PaymentGetDetail) {
      try {
        final result =
            await paymentRepository.getPaymentTransactionDetail(event.id);
        yield PaymentGetDetailSuccessful(result: result);
      } catch (error) {
        yield PaymentFailure(error: error);
      }
    }

    if (event is PaymentBankTransferEvent) {
      try {
        yield PaymentLoading();

        final banks = await paymentRepository.getBanks(event.buildingId);

        final paymentInfo = await paymentRepository.getPaymentInfo(event.id);

        if (banks != null && paymentInfo != null) {
          yield PaymentBankTransferSuccessful(
            banks: banks,
            paymentInfo: paymentInfo,
          );
        } else {
          yield PaymentFailure(error: 'error');
        }
      } catch (error) {
        yield PaymentFailure(error: error.toString());
      }
    }
  }
}
